import 'dart:convert';

import 'package:flash_chat/components/RoundedButton.dart';
import 'package:flash_chat/components/criptografia.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/home_tab_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flash_chat/components/AlertBtn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final auth = FirebaseAuth.instance;


  String name, email, password;
  bool progress = false;
  String message;


  final _fireStore = Firestore.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: progress,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 100.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                onChanged: (value) {
                  name = value;
                },
                decoration: kTextFildInputDecration.copyWith(hintText: 'Enter with your Name'),
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFildInputDecration.copyWith(hintText: 'Enter with your E-mail'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFildInputDecration.copyWith(hintText: 'Enter with your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                color: Colors.blueAccent,
                title: 'Register',
                onPressed: () async {

                  print(password);
                  try {
                    setState(() {
                      progress = true;
                    });

                    _fireStore.collection('Users').reference().document(Criptografia.encode(email)).setData({
                      'email' : email,
                      'name' : name,
                      'status' : 'Novo no Flash Chat',
                      'contatos' : [],
                      'conversations' : [],
                    });


                    final newUser = await auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser != null) {
                      FirebaseUser user;
                      user = await auth.currentUser();
                      UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
                      userUpdateInfo.displayName = name;
                      user.updateProfile(userUpdateInfo);



                      Navigator.pushNamed(context, Home_Tab_Screen.id);
                    }

                    setState(() {
                      progress = false;
                    });
                  }
                  catch(e) {
                    setState(() {
                      progress = false;
                    });
                    print(e.code);

                    AlertBtnErros(context: context, error: e.code, icon: Icon(Icons.mood_bad, color: Colors.grey, size: 100.0,),);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
