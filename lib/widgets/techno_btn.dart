import 'package:flutter/material.dart';
class TechnoBtn extends StatelessWidget {
  final String title;
  final Function onPressed;
  TechnoBtn({this.title="",this.onPressed});
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      highlightColor: Colors.lime,
      color: Theme.of(context).primaryColor,
      splashColor: Colors.green,
      onPressed: onPressed,
      elevation: 10.0,
      child: Container(
          padding: EdgeInsets.all(10.0),
          height: 60,
          width: MediaQuery.of(context).size.width - 80,
          child: Center(
              child: Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ))),
    );
  }
}
