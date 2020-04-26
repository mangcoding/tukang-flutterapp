import 'dart:async';
import 'dart:convert';
import 'package:call_tukang/utils/network_util.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "http://192.168.100.2/";
  static final LOGIN_URL = BASE_URL + "login";
  static final REGISTER_URL = BASE_URL + "register";
  static final _API_KEY = "";

  Future<dynamic> login(String username, String password) {
    return _netUtil.post(LOGIN_URL, body: {
      "email": username,
      "password": password
    }).then((data) async {
      return data;
    });
  }

  Future<dynamic> register(dynamic datas) {
    return _netUtil.post(REGISTER_URL, body: {
      "email": datas["email"],
      "password": datas["password"],
      "first_name": datas["first"],
      "last_name": datas["last"],
      "phone": datas["phone"]
    }).then((data) async {
      return data;
    });
  }
}