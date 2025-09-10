import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_assistance_mobile/controller/local/locale.dart';
import 'package:legal_assistance_mobile/controller/local/localecontroller.dart';
import 'package:legal_assistance_mobile/controller/usercontroller.dart';
import 'package:legal_assistance_mobile/view/auth/signin.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  final userController = Get.put(SignInController());
  await userController.getRole();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeData mytheme = ThemeData(
    primaryColor: Color(0xffffcf40),
    appBarTheme: AppBarTheme(color: Color(0xffffcf40)),
  );

  @override
  Widget build(BuildContext context) {
    Get.put(MyLocaleController());
    return GetMaterialApp(
      theme: mytheme,
      locale: Locale('ar'),
      home: SignIn(),
      translations: MyLocale(),
    );
  }
}
