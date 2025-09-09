import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_assistance_mobile/componant/mybutton.dart';
import 'package:legal_assistance_mobile/componant/profilelist.dart';
import 'package:legal_assistance_mobile/controller/usercontroller.dart';

class HireLawyer extends StatefulWidget {
  const HireLawyer({super.key, required this.lawyer_id});
  final String lawyer_id;
  @override
  State<HireLawyer> createState() => _HireLawyerState();
}

class _HireLawyerState extends State<HireLawyer> {
  String role = Get.find<SignInController>().role.value;
  String avatar = Get.find<SignInController>().avatar.value;

  String get lawyerId =>widget.lawyer_id;

  @override
  void initState() {    
    super.initState();
    print(lawyerId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  minRadius: 80,
                  backgroundImage: NetworkImage(avatar),
                ),
                Column(
                  children: [
                    Profilelist(
                      title: "user_name".tr,
                      text: "Ahmed",
                      icon: Icon(Icons.person),
                    ),
                    Profilelist(
                      title: "union_branch".tr,
                      text: "1316496868",
                      icon: Icon(Icons.numbers),
                    ),
                    Profilelist(
                      title: "years_of_experience".tr,
                      text: "12",
                      icon: Icon(Icons.numbers),
                    ),
                    Profilelist(
                      title: "descriptions".tr,
                      text: "Text",
                      icon: Icon(Icons.numbers),
                    ),
                    Profilelist(
                      title: "phone".tr,
                      text: "1316496868",
                      icon: Icon(Icons.phone),
                    ),
                  ],
                ),
                MyButton(text: "hire".tr, function: hireLawyer),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void hireLawyer() {
  print("lawyer Hired");
}
