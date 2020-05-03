import 'package:flutter/material.dart';
import 'package:call_tukang/constants/constants.dart';
import 'package:call_tukang/screens/widgets/custom_shape.dart';
import 'package:call_tukang/screens/widgets/responsive_ui.dart';
import 'package:call_tukang/screens/widgets/formfield.dart';
import 'package:call_tukang/actions/action_presenter.dart';
import 'package:provider/provider.dart';
import 'package:call_tukang/models/user.dart';
import 'package:call_tukang/utils/validator.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> implements ActionScreenContract {
  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  Map<String, dynamic> _errorValidationMessage = {};
  ActionScreenPresenter _presenter;
  Validator _validator = new Validator();

  bool _isLoading = false;

  void _submit() {
    // print("button Login pressed");
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _presenter.doSignUp({
          "email": _emailController.text, 
          "password": _passwordController.text, 
          "first": _firstNameController.text, 
          "last": _lastNameController.text, 
          "phone": _phoneController.text
        });
    }
  }

  _SignUpScreenState() {
    _presenter = new ActionScreenPresenter(this);
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
    _showDialog("Notification","Terima kasih telah melakukan pendaftaran");
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
    final SignUpButton = CustomButton(hint:"Sign up",callAction: _submit ,minWidth:MediaQuery.of(context).size.width);
    
    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
        child: SingleChildScrollView(
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
                    form(),
                    acceptTermsTextRow(),
                    SizedBox(height: _height/35,),
                    _isLoading ? new CircularProgressIndicator() : SignUpButton,
                    signInTextRow(),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    )
    );
  }

  Widget form() {
    return Container(
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            clipShape(),
            SizedBox(height: _height / 60.0),
            firstNameTextFormField(),
            SizedBox(height: _height / 60.0),
            lastNameTextFormField(),
            SizedBox(height: _height/ 60.0),
            emailTextFormField(),
            SizedBox(height: _height / 60.0),
            phoneTextFormField(),
            SizedBox(height: _height / 60.0),
            passwordTextFormField(),
          ],
        ),
      ),
    );
  }
  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large? _height/8 : (_medium? _height/7 : _height/6.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff01A0C7), Color(0xff2a83d0)],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large? _height/12 : (_medium? _height/11 : _height/10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff01A0C7), Color(0xff2a83d0)],
                ),
              ),
            ),
          ),
        ),
        // Container(
        //   height: _height / 5.5,
        //   alignment: Alignment.center,
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     shape: BoxShape.circle,
        //   ),
        //   child: GestureDetector(
        //       onTap: (){
        //         print('Adding photo');
        //       },

        //       child: Icon(Icons.add_a_photo, size: _large? 40: (_medium? 33: 31),color: Color(0xff01A0C7),)),
        // ),
      ],
    );
  }
  Widget firstNameTextFormField() {
    return CustomTextField(
      validatorAction: (value)=> _validator.validateRequired(value),
      keyboardType: TextInputType.text,
      textEditingController:_firstNameController,
      icon: Icons.person,
      hint: "First Name",
    );
  }

  Widget lastNameTextFormField() {
    return CustomTextField(
      validatorAction: (value)=> _validator.validateRequired(value),
      keyboardType: TextInputType.text,
      textEditingController:_lastNameController,
      icon: Icons.person,
      hint: "Last Name",
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      validatorAction: (value)=> _validator.validateEmail(value),
      keyboardType: TextInputType.emailAddress,
      textEditingController:_emailController,
      errorText:_errorValidationMessage["email"] != null ? _errorValidationMessage["email"][0] : null,
      icon: Icons.email,
      hint: "Email ID",
    );
  }

  Widget phoneTextFormField() {
    return CustomTextField(
      validatorAction: (value)=> _validator.validateRequired(value),
      keyboardType: TextInputType.number,
      textEditingController:_phoneController,
      errorText:_errorValidationMessage["phone"] != null ? _errorValidationMessage["phone"][0] : null,
      icon: Icons.phone,
      hint: "Mobile Number",
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      validatorAction: (value)=> _validator.validatePasswordLength(value),
      keyboardType: TextInputType.text,
      textEditingController:_passwordController,
      obscureText: true,
      icon: Icons.lock,
      hint: "Password",
    );
  }

  Widget acceptTermsTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 100.0),
      child: Row(
        children: <Widget>[
          Checkbox(
              activeColor: Color(0xff01A0C7),
              value: checkBoxValue,
              onChanged: (bool newValue) {
                setState(() {
                  checkBoxValue = newValue;
                });
              }),
          Text(
            "I accept all terms and conditions",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: _large? 12: (_medium? 11: 10)),
          ),
        ],
      ),
    );
  }
  // void _SignUpAction() { print("Routing to your account"); }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Already have an account?",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop(SIGN_IN);
              print("Routing to Sign up screen");
            },
            child: Text(
              "Sign in",
              style: TextStyle(
                  fontWeight: FontWeight.w800, color: Color(0xff01A0C7), fontSize: 19),
            ),
          )
        ],
      ),
    );
  }
}