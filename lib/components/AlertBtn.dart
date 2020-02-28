import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/criptografia.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


void AlertBtnErros({ BuildContext context,String error, Icon icon}) {

  String message = 'Error desconhecido';
  if (error == 'ERROR_WEAK_PASSWORD')
    message = 'Senha fraca';
  else if (error == 'ERROR_INVALID_EMAIL')
    message = 'E-mail invalido';
  else if (error == 'ERROR_EMAIL_ALREADY_IN_USE')
    message = 'E-mail já em uso';
  else if (error == 'ERROR_WRONG_PASSWORD')
    message = 'Senha incorreta';
  else if (error == 'ERROR_USER_NOT_FOUND')
    message = 'Usuario não existe!';
  else if (error == 'FAIL_ADD')
    message = 'Algum erro ocorreu, tente novamente!';
  else if (error == 'SUCCESS_ADD')
    message = 'Usuario adicionado com sucesso!';

  Alert(
      context: context,
      content: icon,
      title: message,
      buttons: [
        DialogButton(
          child: Text(
            'Entendido',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
          color: Colors.lightBlue,
        ),
      ]
  ).show();
}





final _firebaseStore = Firestore.instance;

String email;

void addFriend() async {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedUser = await _auth.currentUser();
  bool finded = false;

  final exist = await _firebaseStore.collection('Users').document(Criptografia.encode(email)).snapshots().elementAt(0);

  if (exist.data != null) {
    var snapshot = await _firebaseStore.collection('Users').document(
        Criptografia.encode(loggedUser.email)).snapshots().elementAt(0);

    var data = snapshot.data['contatos'];
    if (!data.contains(email)) {
      data.add(email);
      _firebaseStore.collection('Users').document(
          Criptografia.encode(loggedUser.email)).updateData({
        'contatos': data,
      });
    }
  }
  else {
    print('Email inexistente');
  }

}

void AlertAddFriend({BuildContext context}) async{
  Alert(
      context: context,
      content: Column(
        children: <Widget>[
          Icon(Icons.group_add,
            size: 100.0,
            color: Colors.lightBlueAccent,
          ),
          TextField(
            onChanged: (value) {
              email = value;
            },
            decoration: kTextFildInputDecration.copyWith(hintText: 'exemple@hotmail.com'),
          ),
        ],
      ),
      title: 'Insira o email para adicionar um novo amigo.',

      buttons: [
        DialogButton(
          child: Text(
            'Adicionar',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            addFriend();
          },
          width: 120,
          color: Colors.lightBlue,
        ),
        DialogButton(
          child: Text(
            'Cancelar',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
          color: Colors.lightBlueAccent,
        )
      ]
  ).show();
}


