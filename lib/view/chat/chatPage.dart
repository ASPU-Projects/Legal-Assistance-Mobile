import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Chat")),
        body: ListView.builder(
          itemCount: 13,
          itemBuilder:
              (context, i) => Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: ListTile(
                  title: Text("User Name"),
                  leading: Icon(Icons.person, size: 60),
                  subtitle: Text("+963 948851543"),
                ),
              ),
        ),
      ),
    );
  }
}
