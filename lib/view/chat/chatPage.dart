import 'package:flutter/material.dart';
import 'package:legal_assistance_mobile/componant/chatList.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(appBar: AppBar(title: Text("Chat")), body: Chatlist()),
    );
  }
}
