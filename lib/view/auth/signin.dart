import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_assistance_mobile/componant/mybutton.dart';
import 'package:legal_assistance_mobile/controller/usercontroller.dart';
import 'package:legal_assistance_mobile/view/auth/signup.dart';
import 'package:http/http.dart' as http;
import 'package:legal_assistance_mobile/view/homepage.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? role, userName, userEmail, avatar, token, id;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void signin(
    BuildContext context,
    TextEditingController emailcontroller,
    TextEditingController passwordcontroller,
  ) async {
    // String token = "";

    setState(() {
      _isLoading = true;
    });

    String email = emailcontroller.text;
    String password = passwordcontroller.text;

    Future<http.Response> fetchData() async {
      final response = await http.post(
        Uri.parse(
          "http://osamanaser2003-21041.portmap.host:21041/api/v1/auth/login",
        ),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      setState(() {
        _isLoading = false;
      });
      return response;
    }

    // انتظر الـ response
    final responseAPI = await fetchData();

    // طباعة البيانات المفيدة

    // print("Status code: ${responseAPI.statusCode}");
    // print("Response body: ${responseAPI.body}");

    // Store role
    var decoded = jsonDecode(responseAPI.body);

    id = decoded['data']['id'].toString();
    role = decoded['data']['role'];
    userName = decoded['data']['name'];
    userEmail = decoded['data']['email'];
    avatar = decoded['data']['avatar'];
    token = decoded['access_token'];

    // print(role);
    // print(userName);
    // print(userEmail);
    // print(avatar);
    // print(token);

    Get.find<SignInController>().setId(id ?? "");
    Get.find<SignInController>().setRole(role ?? "");
    Get.find<SignInController>().setName(userName ?? "");
    Get.find<SignInController>().setEmail(userEmail ?? "");
    Get.find<SignInController>().setAvatar(avatar ?? "");
    Get.find<SignInController>().setToken(token ?? "");

    // بإمكانك تفحص الحالة مثلًا:
    if (responseAPI.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login_successful".tr),
          backgroundColor: Colors.green,
        ),
      );
      // print("Login successful!");
      Get.off(HomePage());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login_failed".tr),
          backgroundColor: Colors.red,
        ),
      );
      // print("Login failed!");
    }
    // Get.to(HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "signin".tr,
                    style: TextStyle(fontSize: 50),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 60),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "field_is_empty".tr;
                        }
                        if (!value.contains("@")) {
                          return "enter_valid_email".tr;
                        }
                        return null;
                      },
                      controller: _emailController,
                      decoration: InputDecoration(hintText: "email".tr),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "field_is_empty".tr;
                        }
                        if (value.length < 6) {
                          return "less_then_6_characters".tr;
                        }
                        return null;
                      },
                      controller: _passwordController,
                      decoration: InputDecoration(hintText: "password".tr),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("do_not_have_an_accout".tr),
                      InkWell(
                        onTap: () {
                          Get.to(SignUp());
                        },
                        child: Text(
                          "create_one".tr,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  _isLoading
                      ? CircularProgressIndicator()
                      : MyButton(
                        text: "signin".tr,
                        function: () {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            signin(
                              context,
                              _emailController,
                              _passwordController,
                            );
                          }
                        },
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
