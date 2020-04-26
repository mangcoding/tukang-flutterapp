import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url) {
    return http.get(url).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        var jsondata = _decoder.convert(res);
        throw new Exception(jsondata["message"]);
      }
      return _decoder.convert(res);
    });
  }
  Future<dynamic> rawPost(String url, dynamic data) async {
    return await http.post(url, body: data, headers: {"Accept": "application/json"});
  }

  Future<dynamic> post(String url, {Map headers, body, encoding}) {
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      if (statusCode == 422) {
        var data = _decoder.convert(res);
        // print(data);
        final Map<String, dynamic> jsonData = data;
        jsonData.forEach((k,v) => throw new Exception("Error: "+v[0].toString()));
      }
      if (statusCode < 200 || statusCode > 400 || json == null) {
        var jsondata = _decoder.convert(res);
        throw new Exception(jsondata["message"]);
      }
      return _decoder.convert(res);
    });
  }
}