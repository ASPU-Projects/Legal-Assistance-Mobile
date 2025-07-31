import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_assistance_mobile/controller/local/localeController.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool languageSwitchValue = false;
  bool themeSwitchValue = false;
  MyLocaleController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("3".tr)),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("5".tr),
                SizedBox(width: 50),
                Row(
                  children: [
                    Text("6".tr),
                    Switch(
                      value: themeSwitchValue,
                      onChanged: (value) {
                        setState(() {
                          themeSwitchValue = value;
                        });
                      },
                    ),
                    Text("7".tr),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("8".tr),
                SizedBox(width: 50),
                Row(
                  children: [
                    Text("10".tr),
                    Switch(
                      value: languageSwitchValue,
                      onChanged: (value) {
                        setState(() {
                          languageSwitchValue = value;
                          if (value == false) {
                            controller.changeLanguage("en");
                          } else {
                            controller.changeLanguage("ar");
                          }
                        });
                      },
                    ),
                    Text("9".tr),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
