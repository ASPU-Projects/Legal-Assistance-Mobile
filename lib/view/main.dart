import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:legal_assistance_mobile/controller/local/locale.dart';
import 'package:legal_assistance_mobile/view/auth/signin.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: Get.deviceLocale,
      home: SignIn(),
      translations: MyLocale(),
    );
  }
}
