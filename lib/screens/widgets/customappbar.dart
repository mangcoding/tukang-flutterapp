import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  @override
  String _title;
  final void Function() leftAction;

  CustomAppBar(this._title, this.leftAction);
  Widget _simplePopup() => PopupMenuButton<int>(
    itemBuilder: (context) => [
          PopupMenuItem(
            value: 2,
            child: Row(
              children: <Widget>[
                Icon(Icons.notifications_none),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text("Notifications"),
                )
              ],
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: Row(
              children: <Widget>[
                Icon(Icons.settings),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text("Settings"),
                )
              ],
            ),
          ),
          PopupMenuItem(
            value: 3,
            child: Row(
              children: <Widget>[
                Icon(Icons.exit_to_app),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text("Logout"),
                )
              ],
            ),
          ),
        ],
    onSelected: (value) {
      print("value:$value");
    },
    icon: Icon(
      Icons.more_vert,
      color: Colors.white,
    ),
    offset: Offset(0, 100),
  );

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Color fontColor = Colors.white;

    return Material(
      child: Container(
        height: height/10,
        width: width,
        padding: EdgeInsets.only(left: 15, top: 25),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors:[Color(0xff01A0C7), Color(0xff2a83d0)]
          ),
        ),
        child:Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            InkWell(
              child: Icon(Icons.menu, color: fontColor),
              onTap: leftAction
            ),
            Text(_title, style: TextStyle(fontSize: 20, color: fontColor)),
            _simplePopup()
          ],
        ),
      ),
      ),
    );
  }
}