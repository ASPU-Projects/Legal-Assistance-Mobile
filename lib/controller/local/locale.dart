import 'package:get/get.dart';

class MyLocale implements Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    "ar": {
      "1": "الصفحة الرئيسية",
      "2": "الصفحة الشخصية",
      "3": "الإعدادات",
      "4": "تسجيل الخروج",
      "5": "النمط",
      "6": "داكن",
      "7": "مضيئ",
      "8": "اللغة",
      "9": "العربية",
      "10": "الإنكليزية",
      "11": "تسجيل الدخول",
      "12": "البريد الإلكتروني",
      "13": "كلمة المرور",
    },
    "en": {
      "1": "Home Page",
      "2": "Profile",
      "3": "Settings",
      "4": "Logout",
      "5": "Theme",
      "6": "Dark",
      "7": "Light",
      "8": "Language",
      "9": "Arabic",
      "10": "English",
      "11": "Sign In",
      "12": "Email",
      "13": "Password",
    },
  };
}
