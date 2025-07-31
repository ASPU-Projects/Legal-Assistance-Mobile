import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_assistance_mobile/view/settings.dart';
import 'package:legal_assistance_mobile/view/chat/chatPage.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("User Name"),
            accountEmail: Text("user@gmail.com"),
          ),
          Expanded(
            child: ListView(
              children: [
                InkWell(
                  child: ListTile(title: Text("2".tr)),
                  onTap: () {
                    // Get.to(Profile());
                  },
                ),
                InkWell(
                  child: ListTile(title: Text("3".tr)),
                  onTap: () {
                    Get.to(Settings());
                  },
                ),
                InkWell(
                  child: ListTile(title: Text("14".tr)),
                  onTap: () {
                    Get.to(ChatPage());
                  },
                ),
                InkWell(
                  child: ListTile(title: Text("15".tr)),
                  onTap: () {
                    // Get.to(Settings());
                  },
                ),
                ListTile(title: Text("4".tr)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
