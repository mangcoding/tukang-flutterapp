import 'package:flutter/material.dart';
import 'package:call_tukang/screens/widgets/responsive_ui.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController textEditingController;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 18.0);
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData icon;
  String Function(String value) validatorAction;
  double _width;
  double _pixelRatio;
  bool large;
  bool medium;


  CustomTextField(
    {this.hint,
      this.textEditingController,
      this.keyboardType,
      this.icon,
      this.obscureText= false,
      this.validatorAction,
     });

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium=  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Container(
      child: TextFormField(
        controller: textEditingController,
        validator: validatorAction,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 15),
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Color(0xff01A0C7), size: 20),
          hintText: hint
        ),
      ),
      decoration : new BoxDecoration(
        color: Colors.white,
        border: new Border(
          bottom: new BorderSide(color: Color(0xff01A0C7), style: BorderStyle.solid),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String hint;
  final void Function() callAction;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  double minWidth;
  bool large;
  bool medium;


  CustomButton(
    {this.hint,
      this.callAction,
      this.minWidth,
     });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialButton(
        minWidth: minWidth,
        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
        onPressed: callAction,
        child: Text(hint,
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Color(0xff01A0C7),
      ),
    );
  }
}