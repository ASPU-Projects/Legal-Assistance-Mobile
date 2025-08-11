import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_assistance_mobile/componant/myDrawer.dart';
import 'package:legal_assistance_mobile/controller/userController.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String role = Get.find<UserController>().role.value;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("home_page".tr),
          backgroundColor: Color(0xffffcf40),
        ),
        drawer: MyDrawer(),
        body: Text(role),
      ),
    );
  }
}
