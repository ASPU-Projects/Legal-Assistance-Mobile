import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_assistance_mobile/controller/local/locale.dart';
import 'package:legal_assistance_mobile/controller/local/localeController.dart';
import 'package:legal_assistance_mobile/view/auth/signin.dart';
import 'package:legal_assistance_mobile/view/auth/signup.dart';
import 'package:legal_assistance_mobile/view/chat/chatPage.dart';
import 'package:legal_assistance_mobile/view/homepage.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MyLocaleController());
    return GetMaterialApp(
      locale: Get.deviceLocale,
      home: ChatPage(),
      translations: MyLocale(),
    );
  }
}
