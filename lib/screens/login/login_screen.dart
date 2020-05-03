import 'dart:ui';
import 'package:call_tukang/constants/constants.dart';
import 'package:call_tukang/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:call_tukang/actions/action_presenter.dart';
import 'package:provider/provider.dart';
import 'package:call_tukang/models/user.dart';
import 'package:call_tukang/screens/widgets/responsive_ui.dart';
import 'package:call_tukang/screens/widgets/formfield.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> implements ActionScreenContract {
  Validator _validator = new Validator();
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  ActionScreenPresenter _presenter;
  Map<String, dynamic> _errorValidationMessage;

  LoginScreenState() {
    _presenter = new ActionScreenPresenter(this);
  }

  void _submit() {
    // print("button Login pressed");
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _presenter.doLogin(_emailController.text, _passwordController.text);
    }
  }

  void _showDialog(String title, String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void onActionError(dynamic error) {
    if (error["message"] != null) {
      _showDialog("Opssss",error["message"]);
    }else{
      _errorValidationMessage.addAll(error);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onActionSuccess(dynamic res) {
    setState(() => _isLoading = false);
    User user = User.map(res["user"]);
    Profile profile = Profile.map(res["profile"]);
    var userModel = Provider.of<UserModel>(context, listen:false);
    userModel.user = user;
    userModel.profile = profile;
    Navigator.of(context).pushNamed(HOME);
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
     _width = MediaQuery.of(context).size.width;
     _pixelRatio = MediaQuery.of(context).devicePixelRatio;
     _large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
     _medium =  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    final emailField = CustomTextField(validatorAction: (value)=> _validator.validateEmail(value), keyboardType: TextInputType.emailAddress, textEditingController:_emailController, icon: Icons.email, hint: "Email ID", );
    final passwordField = CustomTextField( validatorAction: (value)=> _validator.validatePasswordLength(value), keyboardType: TextInputType.text, textEditingController:_passwordController, obscureText: true, icon: Icons.lock, hint: "Password");
    final loginButon = CustomButton(hint:"Sign in",callAction:_submit,minWidth:MediaQuery.of(context).size.width);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: 
            Center(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 155.0,
                      child: Image.asset(
                        "assets/logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 45.0),
                    Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          emailField,
                          SizedBox(height: _height / 25),
                          passwordField,
                          forgetPassTextRow(),
                          SizedBox(height: _height / 25),
                          _isLoading ? new CircularProgressIndicator() : loginButon,
                          SizedBox(height: _height / 25),
                          signUpTextRow()
                        ]
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
  Widget forgetPassTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Forgot your password?",
            style: TextStyle(fontWeight: FontWeight.w400,fontSize: _large? 14: (_medium? 12: 10)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              print("Routing");
            },
            child: Text(
              "Recover",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Color(0xff01A0C7)),
            ),
          )
        ],
      ),
    );
  }

  Widget signUpTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 120.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Don't have an account?",
            style: TextStyle(fontWeight: FontWeight.w400,fontSize: _large? 14: (_medium? 12: 10)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(SIGN_UP);
              print("Routing to Sign up screen");
            },
            child: Text(
              "Sign up",
              style: TextStyle(
                  fontWeight: FontWeight.w800, color: Color(0xff01A0C7), fontSize: _large? 19: (_medium? 17: 15)),
            ),
          )
        ],
      ),
    );
  }
}