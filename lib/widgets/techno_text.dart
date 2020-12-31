import 'package:flutter/material.dart';
class TechnoText extends StatelessWidget {
  final String hintText;
  final TextInputType keyboardType;
  final bool hideText;
  final Function onChanged;
  TechnoText({this.hintText,this.keyboardType=TextInputType.text,this.hideText=false,this.onChanged});
  @override
  Widget build(BuildContext context) {
    return   Container(
      margin: EdgeInsets.all(5.0),
      padding: EdgeInsets.all(10),
      child: TextField(
        onChanged:onChanged,

        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        obscureText: hideText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 20,
          ),
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          hintText: hintText,
          labelText: hintText,
          hintStyle: TextStyle(color:Colors.white),
          labelStyle: TextStyle(color:Colors.white),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(width: 0.8),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide:
            BorderSide(width: 0.8, color: Theme.of(context).primaryColor),
          ),
        ),
        keyboardType:keyboardType,
        style: TextStyle(color: Colors.white),

      ),
    );
  }
}
