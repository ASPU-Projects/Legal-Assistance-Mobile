import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:legal_assistance_mobile/componant/mybutton.dart';
import 'package:legal_assistance_mobile/componant/profilelist.dart';
import 'package:legal_assistance_mobile/controller/usercontroller.dart';
import 'package:legal_assistance_mobile/view/user/hire_dialog.dart';

class HireLawyer extends StatefulWidget {
  const HireLawyer({super.key, required this.lawyer_id});
  final String lawyer_id;

  @override
  State<HireLawyer> createState() => _HireLawyerState();
}

class _HireLawyerState extends State<HireLawyer> {
  String role = Get.find<SignInController>().role.value;
  String avatar = Get.find<SignInController>().avatar.value;
  String get lawyerId => widget.lawyer_id;
  dynamic lawyer;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    getLawyer();
  }

  Future<void> getLawyer() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    String token = Get.find<SignInController>().token.value;
    try {
      final response = await http.get(
        Uri.parse(
          "http://osamanaser2003-21041.portmap.host:21041/api/v1/web/byUser/lawyers/$lawyerId",
        ),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      print(lawyerId);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          lawyer = data['data'] ?? {};
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = "Failed to load lawyer. Status: ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Error: $e";
        _isLoading = false;
      });
      print("Error fetching lawyer: $e");
    }
  }

  void _showHireDialog() {
    showDialog(
      context: context,
      builder: (context) => HireDialog(lawyerId: lawyerId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("lawyer_details".tr)),
        body: Container(
          margin: EdgeInsets.all(20),
          child:
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(child: Text(_error!))
                  : SingleChildScrollView(
                    child: Column(
                      children: [
                        CircleAvatar(
                          minRadius: 80,
                          backgroundImage:
                              lawyer != null && lawyer['avatar'] != null
                                  ? NetworkImage(lawyer['avatar'])
                                  : AssetImage('assets/placeholder_avatar.png')
                                      as ImageProvider,
                          onBackgroundImageError:
                              lawyer != null
                                  ? (exception, stackTrace) {
                                    print('Error loading avatar: $exception');
                                  }
                                  : null,
                          child:
                              lawyer == null || lawyer['avatar'] == null
                                  ? Icon(Icons.person, size: 80)
                                  : null,
                        ),
                        SizedBox(height: 20),
                        Column(
                          children: [
                            Profilelist(
                              title: "user_name".tr,
                              text: lawyer?['name'] ?? "N/A",
                              icon: Icon(Icons.person),
                            ),
                            Profilelist(
                              title: "union_branch".tr,
                              text: lawyer?["union_branch"] ?? "N/A",
                              icon: Icon(Icons.numbers),
                            ),
                            Profilelist(
                              title: "years_of_experience".tr,
                              text:
                                  lawyer?["years_of_experience"]?.toString() ??
                                  "N/A",
                              icon: Icon(Icons.work),
                            ),
                            Profilelist(
                              title: "descriptions".tr,
                              text: lawyer?["description"] ?? "N/A",
                              icon: Icon(Icons.description),
                            ),
                            Profilelist(
                              title: "phone".tr,
                              text: lawyer?["phone"] ?? "N/A",
                              icon: Icon(Icons.phone),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        MyButton(text: "hire".tr, function: _showHireDialog),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}
