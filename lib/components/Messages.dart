import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageEmissario extends StatelessWidget {

  MessageEmissario({this.message, this.dateTime, this.sender});

  final String message;
  final String sender;
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
         children: <Widget>[
           Text(sender),
           Material(
             elevation: 5,
             borderRadius: BorderRadius.circular(30),
             color: Colors.lightBlueAccent,
             child: Padding(
               padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
               child: Text(
                 message,
                 style: TextStyle(
                   color: Colors.white,
                   fontSize: 15.0
                 ),
               ),
             ),
           ),
         ],
      ),
    );
  }
}


class MessageDestinatario extends StatelessWidget {

  MessageDestinatario({this.message, this.sender, this.dateTime});

  final String message;
  final String sender;
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(sender),
          Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(30),
            color: Colors.grey,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
