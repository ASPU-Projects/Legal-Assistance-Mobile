import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_assistance_mobile/controller/usercontroller.dart';
import 'package:legal_assistance_mobile/view/agencies.dart';
import 'package:legal_assistance_mobile/view/auth/lawyers.dart';
import 'package:legal_assistance_mobile/view/profile.dart';
import 'package:legal_assistance_mobile/view/settings.dart';
import 'package:legal_assistance_mobile/view/chat/chatPage.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String role = Get.find<SignInController>().role.value;
  String username = Get.find<SignInController>().name.value;

  String email = Get.find<SignInController>().email.value;

  String avatar = Get.find<SignInController>().avatar.value;

  @override
  Widget build(BuildContext context) {
    // User Drawer
    if (role == "user" || role == "lawyer") {
      return Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(avatar),
              ),
              accountName: Text(username),
              accountEmail: Text(email),
            ),

            Expanded(
              child: ListView(
                children: [
                  InkWell(
                    child: ListTile(title: Text("profile".tr)),
                    onTap: () => Get.to(() => Profile()),
                  ),
                  InkWell(
                    child: ListTile(title: Text("agencies".tr)),
                    onTap: () => Get.to(() => AgenciesPage()),
                  ),
                  InkWell(
                    child: ListTile(title: Text("issues".tr)),
                    // onTap: () => Get.to(Issues()),
                  ),
                  InkWell(
                    child: ListTile(title: Text("settings".tr)),
                    onTap: () => Get.to(Settings()),
                  ),
                  InkWell(
                    child: ListTile(title: Text("chat".tr)),
                    onTap: () => Get.to(ChatPage()),
                  ),
                  InkWell(
                    child: ListTile(title: Text("lawyers".tr)),
                    onTap: () => Get.to(Lawyers()),
                  ),
                  InkWell(
                    child: ListTile(title: Text("fasih".tr)),
                    onTap: () {},
                  ),
                  ListTile(title: Text("recommendation_system".tr)),
                  ListTile(title: Text("logout".tr)),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Drawer(
        child: Column(
          children: [
            Obx(
              () => UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(avatar),
                ),
                accountName: Text(username),
                accountEmail: Text(email),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  InkWell(
                    child: ListTile(title: Text("profile".tr)),
                    onTap: () => Get.to(Profile()),
                  ),
                  InkWell(
                    child: ListTile(title: Text("settings".tr)),
                    onTap: () => Get.to(Settings()),
                  ),
                  InkWell(
                    child: ListTile(title: Text("lawyers".tr)),
                    onTap: () => Get.to(Lawyers()),
                  ),
                  InkWell(
                    child: ListTile(title: Text("agencies".tr)),
                    // onTap: () => Get.to(Lawyers()),
                  ),
                  ListTile(title: Text("logout".tr)),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
