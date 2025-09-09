import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_assistance_mobile/controller/local/localecontroller.dart';

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
        appBar: AppBar(title: Text("settings".tr)),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("theme".tr),
                SizedBox(width: 50),
                Row(
                  children: [
                    Text("light".tr),
                    Switch(
                      value: themeSwitchValue,
                      onChanged: (value) {
                        setState(() {
                          themeSwitchValue = value;
                        });
                      },
                    ),
                    Text("dark".tr),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("language".tr),
                SizedBox(width: 50),
                Row(
                  children: [
                    Text("arabic".tr),
                    Switch(
                      value: languageSwitchValue,
                      onChanged: (value) {
                        setState(() {
                          languageSwitchValue = value;
                          if (value == false) {
                            controller.changeLanguage("ar");
                          } else {
                            controller.changeLanguage("en");
                          }
                        });
                      },
                    ),
                    Text("english".tr),
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
