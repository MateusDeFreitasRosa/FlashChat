import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/criptografia.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';

class Conversation_Screen extends StatefulWidget {
  static String id = 'conversationScreen';

  @override
  _Conversation_ScreenState createState() => _Conversation_ScreenState();
}

class _Conversation_ScreenState extends State<Conversation_Screen> {

  List<FlatButton> conversationsButton = [];

  final _fireStore = Firestore.instance;
  FirebaseUser userLogged;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCorrentUser();

  }

  void getCorrentUser() async{
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        userLogged = user;
        print('UsuarioLogado Agora: '+userLogged.email);
        construct_conversations();
      }
    }catch(e) {
      print(e);
    }
  }

  void construct_conversations() async{
    final user = await _fireStore.collection('Users').document(Criptografia.encode(userLogged.email)).snapshots().elementAt(0);

    for(var conversation in user.data['conversations']) {
      print('CONVERSA: '+conversation);
      List<String> repart = [];
      repart = Criptografia.decode(conversation).split('?');

      String friend_email;

      if (repart[0] == userLogged.email) {
        friend_email = repart[1];
      }
      else {
        friend_email = repart[0];
      }

      final friend = await _fireStore.collection('Users').document(
          Criptografia.encode(friend_email)).snapshots().elementAt(0);

      final message = await _fireStore.collection('Conversations').document(
          conversation).snapshots().elementAt(0);

      if (message.data != null) {
        String lastMessage = '';
        Color colorMessage = Colors.black38;
        Widget notification = Container();

        if (message.data['pac'].last['sender'] == userLogged.email) {
          lastMessage = 'Você: ' + message.data['pac'].last['message'];
        }
        else {
          lastMessage = message.data['pac'].last['nameSender'] + ': ' +
              message.data['pac'].last['message'];
        }
        if (message.data['qnt'] > 0 && message.data['!view'] == userLogged.email) {
          colorMessage = Colors.black87;
          notification = Container(
            alignment: Alignment.centerRight,
            child: Container(
              width: 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueGrey,
                      elevation: 10,
                      child: Text(
                        message.data['qnt'].toString(),
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        conversationsButton.add(
          FlatButton(
            color: Colors.white70,
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30.0,
                      backgroundImage: AssetImage(
                          'images/usuario_sem_foto.png'),
                    ),
                    SizedBox(width: 10,),
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
                            SizedBox(height: 5,),
                            Row(
                              children: <Widget>[
                                Text(
                                  lastMessage,
                                  style: TextStyle(
                                    color: colorMessage,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),

                    notification,
                  ],
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ChatScreen(emailDestinatario: friend.data['email'],
                  nameDestinatario: friend.data['name'],);
              }));
              print('Clicked in + ' + friend.data['name']);
            },
          ),
        );
        setState(() {
          conversationsButton;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: conversationsButton,
          ),
        ),
      ),
    );
  }
}
