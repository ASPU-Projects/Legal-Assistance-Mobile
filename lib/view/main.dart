import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_assistance_mobile/controller/local/locale.dart';
import 'package:legal_assistance_mobile/controller/local/localeController.dart';
import 'package:legal_assistance_mobile/controller/userController.dart';
import 'package:legal_assistance_mobile/view/homepage.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  final userController = Get.put(UserController());
  await userController.getRole();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeData mytheme = ThemeData(
    primaryColor: Colors.amber[200],
    appBarTheme: AppBarTheme(color: Colors.amber[200]),
  );

  @override
  Widget build(BuildContext context) {
    Get.put(MyLocaleController());
    return GetMaterialApp(
      theme: mytheme,
      locale: Locale('ar'),
      home: HomePage(),
      translations: MyLocale(),
    );
  }
}
