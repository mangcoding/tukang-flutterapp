import 'package:flutter/material.dart';
import 'package:call_tukang/models/user.dart';
import 'package:provider/provider.dart';
import 'package:call_tukang/screens/home/griddashboard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:call_tukang/screens/widgets/customappbar.dart';
import 'package:call_tukang/screens/widgets/drawer.dart';

final Color backgroundColor = Colors.white;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _callMenu() {
    _scaffoldKey.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      drawer: AppDrawer(),
      body: Stack(
        children: <Widget>[
          dashboard(context),
        ],
      ),
    );
  }

  Widget dashboard(context) {
    final userModel = Provider.of<UserModel>(context);
    final _profile = userModel.profile;
    String lastName = _profile != null && _profile.lastName != null ? _profile.lastName : "";
    String fullName = _profile != null ? _profile.firstName+" "+lastName : "";
    Color fontColor = Colors.black;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Opacity(opacity: 0.88,child: CustomAppBar("Home",_callMenu)),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      fullName,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                          color: fontColor,
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
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
         GridDashboard(),
        ],
      ),
    );
  }
}