import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_assistance_mobile/view/chat/conversation.dart';

class Chatlist extends ListView {
  Chatlist({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 13,
      itemBuilder:
          (context, i) => InkWell(
            onTap: () {
              Get.to(Conversation());
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ListTile(
                title: Text("User Name"),
                leading: CircleAvatar(child: Icon(Icons.person)),
                subtitle: Text("user@gmail.com"),
              ),
            ),
          ),
    );
  }
}
