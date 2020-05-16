import 'package:flutter/material.dart';
import 'package:call_tukang/constants/constants.dart';
import 'package:call_tukang/screens/home/home_screen.dart';
import 'package:call_tukang/screens/order/order_screen.dart';
import 'package:call_tukang/screens/login/login_screen.dart';
import 'package:call_tukang/screens/login/singup_screen.dart';
import 'package:call_tukang/screens/order/history.dart';

final routes = {
  SIGN_UP: (BuildContext context) => new SignUpScreen(),
  SIGN_IN: (BuildContext context) => new LoginScreen(),
  HOME : (BuildContext context) => new HomeScreen(),
  ORDER : (BuildContext context) => new Order(),
  HISTORY : (BuildContext context) => new HistoryOrder(),
  // HISTORY : (BuildContext context) => new HistoryScreen(),
  '/' : (BuildContext context) => new LoginScreen(),
};