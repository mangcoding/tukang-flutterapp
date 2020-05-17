import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:call_tukang/constants/constants.dart';
import 'package:call_tukang/models/user.dart';

class AppDrawer extends StatelessWidget {
  BuildContext _context;

  @override
  void logout() {
    Provider.of<UserModel>(_context, listen: false).logout();
    Navigator.pushReplacementNamed(_context,SIGN_IN);
  }

  Widget build(BuildContext context) {
    _context = context;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
              icon: Icons.note,
              text: 'Orders',
              onTap: () =>
                  print("notes")),
          Divider(),
          _createDrawerItem(icon: Icons.collections_bookmark, text: 'Categories'),
          _createDrawerItem(icon: Icons.face, text: 'About Us'),
          _createDrawerItem(
              icon: Icons.history, text: 'History'),
          Divider(),
          _createDrawerItem(icon: Icons.exit_to_app, text: 'Logout',onTap: () => logout()),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
        // image: DecorationImage(
        //     fit: BoxFit.fill,
        //     image: AssetImage('res/images/drawer_header_background.png'))),
        gradient: LinearGradient( colors:[Color(0xff01A0C7), Color(0xff2a83d0)])),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("Our Navigation",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}