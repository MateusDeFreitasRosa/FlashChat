import 'package:flash_chat/screens/contatos_screen.dart';
import 'package:flash_chat/screens/conversations_screen.dart';
import 'package:flutter/material.dart';

class Home_Tab_Screen extends StatefulWidget {
  static String id = 'homeTabScreen';

  @override
  _Home_Tab_ScreenState createState() => _Home_Tab_ScreenState();
}

class _Home_Tab_ScreenState extends State<Home_Tab_Screen> with SingleTickerProviderStateMixin {

  TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Flash Chat'),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: TabBar(
                controller: _controller,
                labelColor: Colors.black,
                tabs: <Widget>[
                  Tab(text: 'Conversas',),
                  Tab(text: 'Contatos',),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _controller,
                children: <Widget>[
                  Conversation_Screen(),
                  Contatos_Screen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
