import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:call_tukang/screens/widgets/footer_nav.dart';
import 'package:call_tukang/screens/widgets/customappbar.dart';
import 'package:call_tukang/models/user.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:call_tukang/constants/constants.dart';
import 'package:call_tukang/data/rest_ds.dart';
import 'dart:convert';

class HistoryOrder extends StatefulWidget {
  @override
  _HistoryOrderState createState() => _HistoryOrderState();
}

class _HistoryOrderState extends State<HistoryOrder> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String url = "";
  BuildContext _context;
  int historyLength = 0;
  List<dynamic> historyData = [];
  RestDatasource api = new RestDatasource();
  int _userid;
  String _token;
  bool _isLoading = true;
  final JsonDecoder _decoder = new JsonDecoder();

  void _callMenu() {
    _scaffoldKey.currentState.openDrawer();
  }

  void _showDialog(String title, String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void generateHistory(BuildContext context) async {
    await api.history(_token).then((response) {
        print(response);
        final List<dynamic> jsonData = response["history"];
        print(historyData);
        historyData = jsonData;
        historyLength = 1;
        setState(() => _isLoading = false);
      })
      .catchError((onError) async {
          String errMsg = onError.toString().replaceFirst(new RegExp(r'Exception: '), '');
          var error = _decoder.convert(errMsg);
          _showDialog("Opssss",error["message"]);
      });
  }

  void _selectedTab(int index) {
    setState(() {
      if (index == 0) {
        _callMenu();
      }
      else if (index == 1) {
        Navigator.of(_context).pushNamed(HOME);
      }
      else if (index == 2) {
        Navigator.of(_context).pushNamed(ORDER);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    final userModel = Provider.of<UserModel>(context);
    _token = userModel.token;
    _userid = userModel.user.userId;
    if (historyLength <1) {
      generateHistory(_context);
    }
    final _profile = userModel.profile;
    String lastName = _profile != null && _profile.lastName != null ? _profile.lastName : "";
    String fullName = _profile != null ? _profile.firstName+" "+lastName : "";

    return Scaffold(
      bottomNavigationBar: FABBottomAppBar(
        color: Colors.grey,
        selectedColor: Color(0xff01A0C7),
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: _selectedTab,
        items: [
          FABBottomAppBarItem(iconData: Icons.menu, text: 'Menu'),
          FABBottomAppBarItem(iconData: Icons.home, text: 'Home'),
          FABBottomAppBarItem(iconData: Icons.note_add, text: 'Orders'),
          FABBottomAppBarItem(iconData: Icons.settings, text: 'Settings'),
          FABBottomAppBarItem(iconData: Icons.info, text: 'About'),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 0),
        children: 
          <Widget>[
          //bar
          Opacity(opacity: 0.88,child: CustomAppBar("History",_callMenu)),
          //profile
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image(
                        width: 85,
                        height: 85,
                        fit: BoxFit.cover,
                        image: (url) != ""
                            ? NetworkImage(url)
                            : AssetImage("assets/festival.png"),
                      )),
                  Text(
                    fullName,
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    _profile != null ? _profile.phone : "",
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    _profile != null ? _profile.email : "",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 40, left: 20, bottom: 10),
              child: Text("Last Order",
                  style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.bold,
                      fontSize: 16))),
          Container(
              height: 300,
              //margin: EdgeInsets.only(top: 0, left: 20, right: 20),
              child: _isLoading ? Center( child:new CircularProgressIndicator()) : Flexible(
                fit: FlexFit.tight,
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) => Divider(),
                  itemCount: historyData.length,
                  padding: EdgeInsets.all(5),
                  itemBuilder: (context, int index) {
                    return createslide(index,historyData[index]);
                  }),
              )),
        ],
      ),
    );
  }
}

Slidable createslide(int index, historyData) {
  return Slidable(
    actionPane: SlidableDrawerActionPane(),
    actionExtentRatio: 0.25,
    child: Container(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(historyData["name"]),
            subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(historyData["merchant_name"]),
                  Text(historyData["created_at"]),
                ]),
            trailing:
              Column(
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                (historyData["price"] == "On Calculating") 
                  ? Text(historyData["price"], style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))
                  : Text(historyData["price"])
                ,
                (historyData["status"] == "0")
                    ? Text(historyData["statusMessage"], style: TextStyle(color: Colors.green))
                    : Text(historyData["statusMessage"], style: TextStyle(color: Colors.blue))
              ],
            ),
          ),
        ],
      ),
    ),
    actions: 
    <Widget>[
      IconSlideAction(
        caption: 'View',
        color: Colors.blue,
        icon: Icons.view_agenda ,
        onTap: () => print(index),
      ),
      IconSlideAction(
        caption: 'Delete',
        color: Colors.red,
        icon: Icons.delete,
        onTap: () => print(index),
      ),
    ],
    // secondaryActions: <Widget>[
      
    //   IconSlideAction(
    //     caption: 'Edit',
    //     color: Colors.blue,
    //     icon: Icons.edit,
    //     onTap: () => print(index)
    //   ),
    //   IconSlideAction(
    //     caption: 'Delete',
    //     color: Colors.red,
    //     icon: Icons.delete,
    //     onTap: () => print(index),
    //   ),
    // ],
  );
}
