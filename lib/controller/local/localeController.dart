import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MyLocaleController extends GetxController {
  void changeLanguage(String codelang) {
    Locale locale = Locale(codelang);
    Get.updateLocale(locale);
  }
}
