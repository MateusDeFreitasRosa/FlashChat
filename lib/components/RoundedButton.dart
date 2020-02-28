import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {

  RoundedButton({this.color, this.title, @required this.onPressed, this.verticalPadding = 16.0});

  final Color color;
  final String title;
  final Function onPressed;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          textColor: Colors.white,
          child: Text(
            title,
          ),
        ),
      ),
    );
  }
}
