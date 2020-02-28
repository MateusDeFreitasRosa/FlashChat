
import 'package:flash_chat/components/AlertBtn.dart';
import 'package:flash_chat/components/RoundedButton.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/home_tab_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final auth = FirebaseAuth.instance;

  bool progress = false;
  String email, password;
  double tam_icon = 100.0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  height: tam_icon,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                style: TextStyle(
                  color: Colors.black,

                ),
                decoration: kTextFildInputDecration.copyWith(hintText: "Enter with your E-mail"),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: kTextFildInputDecration.copyWith(hintText: "Enter with your password"),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                color: Colors.lightBlueAccent,
                title: 'Log In',
                onPressed: () async{
                  try {
                    setState(() {
                      progress = true;
                    });

                    final userLogged = await auth.signInWithEmailAndPassword(email: email, password: password);
                    if (userLogged != null) {
                      Navigator.pushNamed(context, Home_Tab_Screen.id);
                    }
                    setState(() {
                      progress = false;
                    });
                  }catch(e) {
                    setState(() {
                      progress = false;
                    });
                    print(e.code);

                    AlertBtnErros(context: context, error: e.code, icon: Icon(Icons.mood_bad, size: 100.0, color: Colors.grey,));
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
