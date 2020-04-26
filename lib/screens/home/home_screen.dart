import 'package:flutter/material.dart';
import 'package:call_tukang/models/user.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new Padding(
        padding: const EdgeInsets.all(10.0),
        child: ProfileDescription(),
      ),
    );
  }

}

class ProfileDescription extends StatelessWidget {
  const ProfileDescription({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);
    final _profile = userModel.profile;
    String lastName = _profile.lastName != null ? _profile.lastName : "";
    String fullName = _profile.firstName+" "+lastName;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      //ADA 4 BAGIAN YANG MEMBENTUK LIST SECARA VERTICAL, MAKA COLUMN MENGAMBIL PERANNYA
      //SEMUANYA MUDAH KARENA HANYA MENAMPILKAN TEKS BIASA SAJA
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            fullName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            _profile.phone,
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            _profile.email,
          ),
        ],
      ),
    );
  }
}