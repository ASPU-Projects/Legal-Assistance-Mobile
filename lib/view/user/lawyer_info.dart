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
  final SignInController _userController = Get.find<SignInController>();
  String get lawyerId => widget.lawyer_id;

  dynamic lawyer;
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _getLawyerDetails();
  }

  Future<void> _getLawyerDetails() async {
    if (_isRefreshing) {
      setState(() {
        _error = null;
      });
    } else {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      String token = _userController.token.value;

      // Changed from POST to GET request
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

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          lawyer = data['data'] ?? {};
          _isLoading = false;
          _isRefreshing = false;
        });
      } else {
        setState(() {
          _error = "Failed to load lawyer. Status: ${response.statusCode}";
          _isLoading = false;
          _isRefreshing = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Error: $e";
        _isLoading = false;
        _isRefreshing = false;
      });
      print("Error fetching lawyer: $e");
    }
  }

  Future<void> _refreshLawyerDetails() async {
    setState(() {
      _isRefreshing = true;
    });
    await _getLawyerDetails();
  }

  void _showHireDialog() {
    showDialog(
      context: context,
      builder: (context) => HireDialog(lawyerId: lawyerId),
    );
  }

  void _startConversation() {
    // Navigate to conversation screen
    Get.toNamed(
      '/conversation',
      arguments: {'lawyer_id': lawyerId, 'lawyer_name': lawyer?['name'] ?? ''},
    );
  }

  void _makeReservation() {
    // Navigate to reservation screen
    Get.toNamed(
      '/reservation',
      arguments: {'lawyer_id': lawyerId, 'lawyer_name': lawyer?['name'] ?? ''},
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("lawyer_info".tr),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _isLoading ? null : _refreshLawyerDetails,
            ),
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshLawyerDetails,
              child: Text("retry".tr),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshLawyerDetails,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lawyer Profile Section
            _buildProfileSection(),

            SizedBox(height: 24),

            // Lawyer Information Section
            _buildInfoSection(),

            SizedBox(height: 32),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage:
                  lawyer != null && lawyer['avatar'] != null
                      ? NetworkImage(lawyer['avatar'])
                      : AssetImage('assets/placeholder_avatar.png')
                          as ImageProvider,
              onBackgroundImageError: (exception, stackTrace) {
                print('Error loading avatar: $exception');
              },
              child:
                  lawyer == null || lawyer['avatar'] == null
                      ? Icon(Icons.person, size: 60)
                      : null,
            ),
            SizedBox(height: 16),
            Text(
              lawyer?['name'] ?? "N/A",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (lawyer?['specialization'] != null) ...[
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  lawyer?['specialization'] ?? "",
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Profilelist(
              title: "user_name".tr,
              text: lawyer?['name'] ?? "N/A",
              icon: Icon(Icons.person),
            ),
            Profilelist(
              title: "union_branch".tr,
              text: lawyer?["union_branch"] ?? "N/A",
              icon: Icon(Icons.business),
            ),
            Profilelist(
              title: "years_of_experience".tr,
              text: lawyer?["years_of_experience"]?.toString() ?? "N/A",
              icon: Icon(Icons.work),
            ),
            Profilelist(
              title: "specialization".tr,
              text: lawyer?["specialization"] ?? "N/A",
              icon: Icon(Icons.category),
            ),
            Profilelist(
              title: "description".tr,
              text: lawyer?["description"] ?? "N/A",
              icon: Icon(Icons.description),
            ),
            Profilelist(
              title: "phone".tr,
              text: lawyer?["phone"] ?? "N/A",
              icon: Icon(Icons.phone),
            ),
            Profilelist(
              title: "email".tr,
              text: lawyer?["email"] ?? "N/A",
              icon: Icon(Icons.email),
            ),
            if (lawyer?['rating'] != null) ...[
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  SizedBox(width: 4),
                  Text(
                    lawyer?['rating']?.toString() ?? "0.0",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "(${lawyer?['reviews_count'] ?? 0} ${'reviews'.tr})",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Hire Button
        MyButton(text: "hire".tr, function: _showHireDialog),

        SizedBox(height: 12),

        // Conversation and Reservation Buttons Row
        Row(
          children: [
            Expanded(
              child: MyButton(
                text: "conversation".tr,
                function: _startConversation,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: MyButton(
                text: "reservation".tr,
                function: _makeReservation,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
