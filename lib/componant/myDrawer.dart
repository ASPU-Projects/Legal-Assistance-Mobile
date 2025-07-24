import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_assistance_mobile/settings.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("username"),
            accountEmail: Text("user email"),
          ),
          Expanded(
            child: ListView(
              children: [
                InkWell(
                  child: ListTile(title: Text("2".tr)),
                  onTap: () {
                    // Get.to(UserProfile());
                  },
                ),
                InkWell(
                  child: ListTile(title: Text("3".tr)),
                  onTap: () {
                    Get.to(Settings());
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
