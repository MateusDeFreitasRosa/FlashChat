import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/Messages.dart';
import 'package:flash_chat/components/criptografia.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  ChatScreen({this.emailDestinatario, this.nameDestinatario});

  String emailDestinatario;
  String nameDestinatario;

  @override
  _ChatScreenState createState() => _ChatScreenState(emailDestinatario: emailDestinatario,
      nameDestinatario: nameDestinatario);
}


class _ChatScreenState extends State<ChatScreen> {

  String emailDestinatario;
  String nameDestinatario;
  _ChatScreenState({this.emailDestinatario, this.nameDestinatario});


  final _auth = FirebaseAuth.instance;
  FirebaseUser userLogged;

  final _fireStore = Firestore.instance;
  String first,second;
  String cript;
  int totalMessages;

  @override
  void initState() {
    getCorrentUser();
    super.initState();
  }

  var builder = StreamBuilder(
    builder: (context, snap) {
      return Text('Carregando');
    }
  );

  void orderEmails() {
    if (this.emailDestinatario.toLowerCase().compareTo(userLogged.email.toLowerCase()) == -1) {
      first = this.emailDestinatario;
      second = userLogged.email;
    }
    else {
      first = userLogged.email;
      second = this.emailDestinatario;
    }
    cript = Criptografia.encode(first+'?'+second);
  }



  void getCorrentUser() async{
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        userLogged = user;
        print('UsuarioLogado Agora: '+userLogged.email);
        orderEmails();
        setState(() {
          builder = constructorStream();
        });
        final t = await _fireStore.collection('Conversations').document(cript).snapshots().elementAt(0);
        if (t.data['qnt'] > 0 && t.data['!view'] == userLogged.email) {
          _fireStore.collection('Conversations').document(cript).updateData({
            'qnt': 0,
          });
        }
      }
        print('Quantidade de mensagens'+ totalMessages.toString());
      }
      catch(e) {
        print(e);
      }
  }

  
  //Variaveis Screen.
  String textSend;
  TextEditingController _controllerText = new TextEditingController();


  //StreamConstructor;
  StreamBuilder constructorStream() {
    return StreamBuilder(
      stream: _fireStore.collection('Conversations').snapshots(),
      builder: (context, snapshot) {

        List<Widget> listMessagesEmissario = [];

        if (snapshot.hasData) {

          List<DocumentSnapshot> messages = snapshot.data.documents;

          for(var m in messages) {
            if (m.documentID == cript) {
              if (m['qnt'] > 0 && m['!view'] == userLogged.email) {
                _fireStore.collection('Conversations').document(cript).updateData({
                  'qnt' : 0,
                });
              }
              for (var message in m['pac']) {
                if (message['sender'] == userLogged.email) {
                  final widgetMessage = MessageEmissario(
                      sender: message['nameSender'],
                      message: message['message']);
                  listMessagesEmissario.add(widgetMessage);
                }
                else {
                  final widgetMessageDestin = MessageDestinatario(
                    sender: message['nameSender'],
                    message: message['message'],);
                  listMessagesEmissario.add(widgetMessageDestin);
                }
              }
            }
          }
        }
        return Expanded(
          child: ListView(
            children: listMessagesEmissario,
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.popAndPushNamed(context, LoginScreen.id);
              }),
        ],
        title: Text('⚡️Chat  -> '+ nameDestinatario),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            builder,
            Container (
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controllerText,
                      onChanged: (value) {
                       textSend = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {

                        _controllerText.clear();
                        print('FIRST: '+first);
                        print('SECOND: '+second);
                      },
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      if (textSend.isNotEmpty) {
                        final exist = await _fireStore.collection('Conversations').document(cript).snapshots().elementAt(0);
                        if (exist.data == null) {

                          _fireStore.collection('Conversations').document(cript).setData({
                            'pac' : [{
                              'sender': userLogged.email,
                              'message': textSend,
                              'date': DateTime.now(),
                              'nameSender': userLogged.displayName,
                            }],
                            '!view' : emailDestinatario,
                            'qnt' : 1,
                          });
                        }
                        else {
                          var data = exist.data['pac'];

                          print('É inteiro? '+ exist.data['qnt'].toString());

                          int n =  1+exist.data['qnt'];

                          data.add({
                            'sender' : userLogged.email,
                            'message' : textSend,
                            'date' : DateTime.now(),
                            'nameSender' : userLogged.displayName,
                          });

                          _fireStore.collection('Conversations').document(cript).updateData({
                            'pac': data,
                            'qnt' : n,
                          });
                        }
                        _controllerText.clear();
                        
                        final snapShotUser = await _fireStore.collection('Users').document(Criptografia.encode(userLogged.email)).snapshots().elementAt(0);
                        final snapShopFriendUser = await _fireStore.collection('Users').document(Criptografia.encode(emailDestinatario)).snapshots().elementAt(0);

                        var data = snapShotUser.data['conversations'];
                        var dataFriend = snapShopFriendUser.data['conversations'];

                        if(!data.contains(cript)) {
                          data.add(cript);
                          _fireStore.collection('Users').document(Criptografia.encode(userLogged.email)).updateData({
                            'conversations' : data,
                          });
                          print("ADD MESSAGE FOR YOU");
                        }
                        if (!dataFriend.contains(cript)) {
                          dataFriend.add(cript);
                          _fireStore.collection('Users').document(Criptografia.encode(emailDestinatario)).updateData({
                            'conversations' : dataFriend,
                          });
                          print('ADD MESSAGE FOR FRIEND');
                        }
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
