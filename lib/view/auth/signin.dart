import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

import 'package:legal_assistance_mobile/componant/myButton.dart';
import 'package:legal_assistance_mobile/componant/myTextFeild.dart';
import 'package:legal_assistance_mobile/view/auth/signup.dart';
import 'package:legal_assistance_mobile/view/homepage.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "11".tr,
                  style: TextStyle(fontSize: 50),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 60),
                MyTextFeild(text: "12".tr, obscureText: false),
                MyTextFeild(text: "13".tr, obscureText: true),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an accout "),
                    InkWell(
                      onTap: () {
                        Get.to(SignUp());
                      },
                      child: Text(
                        "Create one",
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                MyButton(text: "11".tr, function: signin),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void signin() {
  Get.to(HomePage());
}
