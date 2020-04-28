import 'package:flutter/foundation.dart';

class UserModel extends ChangeNotifier {
  User _user;
  Profile _profile;
  bool _isAuthenticated = false;

  User get user => _user;
  Profile get profile => _profile;
  String get token => _user.token;
  
  set user(User newUser) {
    _user = newUser;
    notifyListeners();
  }

  set profile(Profile data) {
    _profile = data;
    notifyListeners();
  }

  bool isAuthenticated() {
    return _isAuthenticated;
  }

  void login() {
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _user = null;
    _profile = null;
    notifyListeners();
  }
}

class User {
  String token; int role; int userId;

  User.map(dynamic obj) {
    this.userId = obj["user_id"];
    this.role = obj["role"];
    this.token = obj["token"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["user_id"] = userId;
    map["role"] = role;
    map["token"] = token;

    return map;
  }
}

class Profile {
  String firstName; String lastName; String phone; String nik; String email;

  Profile.map(dynamic obj) {
    this.firstName = obj["first_name"];
    this.lastName = obj["last_name"];
    this.phone = obj["phone"];
    this.nik = obj["nik"];
    this.email = obj["email"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["first_name"] = firstName;
    map["last_name"] = lastName;
    map["phone"] = phone;
    map["nik"] = nik;
    map["email"] = email;
    
    return map;
  }
}