import 'dart:async';
import 'dart:convert';
import 'package:call_tukang/utils/network_util.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "http://192.168.100.2/";
  static final LOGIN_URL = BASE_URL + "login";
  static final _API_KEY = "";

  Future<dynamic> login(String username, String password) {
    return _netUtil.post(LOGIN_URL, body: {
      "email": username,
      "password": password
    }).then((data) async {
      return data;
    });
  }
}