import 'package:flutter/material.dart';
import 'package:call_tukang/routes.dart';
import 'package:provider/provider.dart';
import 'package:call_tukang/models/user.dart';

void main() => runApp(ChangeNotifierProvider(
  create: (context) => UserModel(),
  child: LoginApp(),
));

class LoginApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'TukangTikung.id Login Area',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      routes: routes,
    );
  }
}
