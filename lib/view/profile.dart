import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:legal_assistance_mobile/componant/mybutton.dart';
import 'package:legal_assistance_mobile/componant/profilelist.dart';
import 'package:legal_assistance_mobile/controller/usercontroller.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? birthdate, birthplace, address, phone, nationalnumber, gender;

  @override
  void initState() {
    super.initState();
    print("initState Done");
    loadProfile();
  }

  void loadProfile() async {
    String token = Get.find<SignInController>().token.value;
    Future<http.Response> fetchData() async {
      final response = await http.get(
        Uri.parse(
          "http://osamanaser2003-21041.portmap.host:21041/api/v1/web/byUser/profile",
        ),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      print(response);
      return response;
    }

    final responseAPI = await fetchData();
    print(responseAPI.statusCode);
    print(responseAPI.body);
    var decoded = jsonDecode(responseAPI.body);

    birthdate = decoded['data']['birthdate'];
    birthplace = decoded['data']['birth_place'];
    nationalnumber = decoded['data']['national_number'];
    gender = decoded['data']['gender'];
    address = decoded['data']['address'];

    print(id);
    print(role);
    print(avatar);
    print(username);
    print(useremail);
    print(address);
    print(birthdate);
    print(birthplace);
    print(phone);
    print(nationalnumber);
    print(gender);
  }

  String id = Get.find<SignInController>().id.value;
  String role = Get.find<SignInController>().role.value;
  String avatar = Get.find<SignInController>().avatar.value;
  String username = Get.find<SignInController>().name.value;
  String useremail = Get.find<SignInController>().email.value;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:
            // User Profile
            role == "user"
                ? Container(
                  margin: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CircleAvatar(
                          minRadius: 80,
                          backgroundImage: NetworkImage(avatar),
                          backgroundColor: Colors.grey[200],
                        ),
                        Column(
                          children: [
                            Profilelist(
                              title: "user_name".tr,
                              text: username,
                              icon: Icon(Icons.person),
                            ),
                            Profilelist(
                              title: "email".tr,
                              text: useremail,
                              icon: Icon(Icons.email),
                            ),
                            Profilelist(
                              title: "birth_date".tr,
                              text: birthdate!,
                              icon: Icon(Icons.calendar_month),
                            ),
                            Profilelist(
                              title: "birth_place".tr,
                              text: birthplace!,
                              icon: Icon(Icons.location_city),
                            ),
                            Profilelist(
                              title: "address".tr,
                              text: address!,
                              icon: Icon(Icons.location_on),
                            ),
                            Profilelist(
                              title: "national_number".tr,
                              text: nationalnumber!,
                              icon: Icon(Icons.numbers),
                            ),
                            Profilelist(
                              title: "gender".tr,
                              text: gender!,
                              icon: Icon(Icons.person),
                            ),
                            Profilelist(
                              title: "phone".tr,
                              text: phone!,
                              icon: Icon(Icons.phone),
                            ),
                          ],
                        ),
                        MyButton(text: "edit".tr, function: editdata),
                      ],
                    ),
                  ),
                )
                // Lawyers Profile
                : Container(
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
                              text: username,
                              icon: Icon(Icons.person),
                            ),
                            Profilelist(
                              title: "email".tr,
                              text: useremail,
                              icon: Icon(Icons.email),
                            ),
                            Profilelist(
                              title: "birth_date".tr,
                              text: "birthdate",
                              icon: Icon(Icons.calendar_month),
                            ),
                            Profilelist(
                              title: "birth_place".tr,
                              text: "birthplace",
                              icon: Icon(Icons.location_city),
                            ),
                            Profilelist(
                              title: "address".tr,
                              text: "address",
                              icon: Icon(Icons.location_on),
                            ),
                            Profilelist(
                              title: "union_branch".tr,
                              text: "unionbranch",
                              icon: Icon(Icons.numbers),
                            ),
                            Profilelist(
                              title: "union_number".tr,
                              text: "unionnumber",
                              icon: Icon(Icons.numbers),
                            ),
                            Profilelist(
                              title: "affiliation_date".tr,
                              text: "affiliationdate",
                              icon: Icon(Icons.calendar_month),
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
                              title: "national_number".tr,
                              text: "nationalnumber",
                              icon: Icon(Icons.numbers),
                            ),
                            Profilelist(
                              title: "gender".tr,
                              text: "gender",
                              icon: Icon(Icons.person),
                            ),
                            Profilelist(
                              title: "phone".tr,
                              text: "phone",
                              icon: Icon(Icons.phone),
                            ),
                          ],
                        ),
                        MyButton(text: "edit".tr, function: editdata),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}

void editdata() {}
