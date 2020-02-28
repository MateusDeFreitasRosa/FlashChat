import 'package:flash_chat/components/AlertBtn.dart';
import 'package:flash_chat/components/criptografia.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Contatos_Screen extends StatefulWidget {
  static String id = 'contatosScreen';


  @override
  _Contatos_ScreenState createState() => _Contatos_ScreenState();
}

class _Contatos_ScreenState extends State<Contatos_Screen> {

  final _firebaseStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedUser;

  List<FlatButton> contactsWidgets = [];

  @override
  void initState() {
    super.initState();
      getUserLogged();
  }



  void getUserLogged() async{
    try {
      final user = await _auth.currentUser();
      if(user != null) {
        loggedUser = user;
        constructWidgetContacts();
      }

    }
    catch(e) {
      print(e);
    }
  }


  void constructWidgetContacts() async{
    final userData = await _firebaseStore.collection('Users').document(Criptografia.encode(loggedUser.email)).snapshots().elementAt(0);

    for(var contatos in userData.data['contatos']) {
      final friend = await _firebaseStore.collection('Users').document(Criptografia.encode(contatos)).snapshots().elementAt(0);

      contactsWidgets.add(
         FlatButton(
           child: Column (
             children: <Widget>[
               Row(
                 children: <Widget>[
                   CircleAvatar(
                     radius: 30.0,
                     backgroundImage: AssetImage('images/usuario_sem_foto.png'),
                   ),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                       Column(
                         children: <Widget>[
                           Text(
                               friend.data['name'],
                             style: TextStyle(
                               color: Colors.black,
                             ),
                           ),
                           SizedBox(height: 3,),
                           Text(
                               friend.data['status'],
                             style: TextStyle(
                               color: Colors.black38,
                             ),
                           ),
                         ],
                       )
                     ],
                   ),
                 ],
               ),
             ],
           ),
           onPressed: () {
             Navigator.push(context, MaterialPageRoute(builder: (context) {
               return ChatScreen(emailDestinatario: friend.data['email'], nameDestinatario: friend.data['name'],);
             }));
             print('Clicked in + '+ friend.data['name']);
           },
         ),
      );
      setState(() {
        contactsWidgets;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            AlertAddFriend(context: context);
          },
        ),
        body: SafeArea(
          child: Column(
            children: contactsWidgets,
          ),
        ),
      ),
    );
  }
}


