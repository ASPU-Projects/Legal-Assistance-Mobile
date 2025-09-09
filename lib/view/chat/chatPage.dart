import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_assistance_mobile/componant/chatlist.dart';

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
        appBar: AppBar(title: Text("chat".tr)),
        body: Center(
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "search".tr,
                      suffix: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.search, color: Colors.black),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Expanded(child: Chatlist()),
            ],
          ),
        ),
      ),
    );
  }
}
