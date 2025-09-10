import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final SignInController _userController = Get.find<SignInController>();

  // Profile data variables
  Map<String, dynamic> profileData = {};
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
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
      String role = _userController.role.value;

      // Determine API endpoint based on user role
      String endpoint;
      switch (role) {
        case 'lawyer':
          endpoint =
              'http://osamanaser2003-21041.portmap.host:21041/api/v1/web/byLawyer/profile';
          break;
        case 'representative':
          endpoint =
              'http://osamanaser2003-21041.portmap.host:21041/api/v1/web/byRepresentative/profile';
          break;
        default:
          endpoint =
              'http://osamanaser2003-21041.portmap.host:21041/api/v1/web/byUser/profile';
      }

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        setState(() {
          profileData = decoded['data'] ?? {};
          _isLoading = false;
          _isRefreshing = false;
        });
      } else {
        setState(() {
          _error = "Failed to load profile. Status: ${response.statusCode}";
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
      print("Error fetching profile: $e");
    }
  }

  Future<void> _refreshProfile() async {
    setState(() {
      _isRefreshing = true;
    });
    await loadProfile();
  }

  void _editProfile() {
    // Navigate to edit profile page
    Get.toNamed(
      '/edit-profile',
      arguments: {
        'role': _userController.role.value,
        'profileData': profileData,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("profile".tr)),
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
            ElevatedButton(onPressed: _refreshProfile, child: Text("retry".tr)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshProfile,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header Section
            _buildProfileHeader(),

            SizedBox(height: 24),

            // Profile Information Section
            _buildProfileInfo(),

            SizedBox(height: 32),

            // Edit Button
            MyButton(text: "edit".tr, function: _editProfile),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
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
                  _userController.avatar.value.isNotEmpty
                      ? NetworkImage(_userController.avatar.value)
                      : AssetImage('assets/placeholder_avatar.png')
                          as ImageProvider,
              onBackgroundImageError: (exception, stackTrace) {
                print('Error loading avatar: $exception');
              },
              child:
                  _userController.avatar.value.isEmpty
                      ? Icon(Icons.person, size: 60)
                      : null,
            ),
            SizedBox(height: 16),
            Text(
              _userController.name.value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _userController.role.value.tr,
                style: TextStyle(
                  color: Colors.blue.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: _buildProfileFields()),
      ),
    );
  }

  List<Widget> _buildProfileFields() {
    List<Widget> fields = [];

    // Common fields for all user types
    fields.addAll([
      Profilelist(
        title: "user_name".tr,
        text: _userController.name.value,
        icon: Icon(Icons.person),
      ),
      Profilelist(
        title: "email".tr,
        text: _userController.email.value,
        icon: Icon(Icons.email),
      ),
    ]);

    // Add fields based on user role
    switch (_userController.role.value) {
      case 'user':
        fields.addAll([
          Profilelist(
            title: "birth_date".tr,
            text: profileData['birthdate'] ?? "N/A",
            icon: Icon(Icons.calendar_month),
          ),
          Profilelist(
            title: "birth_place".tr,
            text: profileData['birth_place'] ?? "N/A",
            icon: Icon(Icons.location_city),
          ),
          Profilelist(
            title: "address".tr,
            text: profileData['address'] ?? "N/A",
            icon: Icon(Icons.location_on),
          ),
          Profilelist(
            title: "national_number".tr,
            text: profileData['national_number'] ?? "N/A",
            icon: Icon(Icons.numbers),
          ),
          Profilelist(
            title: "gender".tr,
            text: profileData['gender'] ?? "N/A",
            icon: Icon(Icons.person),
          ),
          Profilelist(
            title: "phone".tr,
            text: profileData['phone'] ?? "N/A",
            icon: Icon(Icons.phone),
          ),
        ]);
        break;

      case 'lawyer':
        fields.addAll([
          Profilelist(
            title: "birth_date".tr,
            text: profileData['birthdate'] ?? "N/A",
            icon: Icon(Icons.calendar_month),
          ),
          Profilelist(
            title: "birth_place".tr,
            text: profileData['birth_place'] ?? "N/A",
            icon: Icon(Icons.location_city),
          ),
          Profilelist(
            title: "address".tr,
            text: profileData['address'] ?? "N/A",
            icon: Icon(Icons.location_on),
          ),
          Profilelist(
            title: "union_branch".tr,
            text: profileData['union_branch'] ?? "N/A",
            icon: Icon(Icons.business),
          ),
          Profilelist(
            title: "union_number".tr,
            text: profileData['union_number'] ?? "N/A",
            icon: Icon(Icons.numbers),
          ),
          Profilelist(
            title: "affiliation_date".tr,
            text: profileData['affiliation_date'] ?? "N/A",
            icon: Icon(Icons.calendar_month),
          ),
          Profilelist(
            title: "years_of_experience".tr,
            text: profileData['years_of_experience']?.toString() ?? "N/A",
            icon: Icon(Icons.work),
          ),
          Profilelist(
            title: "specialization".tr,
            text: profileData['specialization'] ?? "N/A",
            icon: Icon(Icons.category),
          ),
          Profilelist(
            title: "description".tr,
            text: profileData['description'] ?? "N/A",
            icon: Icon(Icons.description),
          ),
          Profilelist(
            title: "national_number".tr,
            text: profileData['national_number'] ?? "N/A",
            icon: Icon(Icons.numbers),
          ),
          Profilelist(
            title: "gender".tr,
            text: profileData['gender'] ?? "N/A",
            icon: Icon(Icons.person),
          ),
          Profilelist(
            title: "phone".tr,
            text: profileData['phone'] ?? "N/A",
            icon: Icon(Icons.phone),
          ),
        ]);
        break;

      case 'representative':
        fields.addAll([
          Profilelist(
            title: "birth_date".tr,
            text: profileData['birthdate'] ?? "N/A",
            icon: Icon(Icons.calendar_month),
          ),
          Profilelist(
            title: "birth_place".tr,
            text: profileData['birth_place'] ?? "N/A",
            icon: Icon(Icons.location_city),
          ),
          Profilelist(
            title: "address".tr,
            text: profileData['address'] ?? "N/A",
            icon: Icon(Icons.location_on),
          ),
          Profilelist(
            title: "national_number".tr,
            text: profileData['national_number'] ?? "N/A",
            icon: Icon(Icons.numbers),
          ),
          Profilelist(
            title: "gender".tr,
            text: profileData['gender'] ?? "N/A",
            icon: Icon(Icons.person),
          ),
          Profilelist(
            title: "phone".tr,
            text: profileData['phone'] ?? "N/A",
            icon: Icon(Icons.phone),
          ),
        ]);
        break;
    }

    return fields;
  }
}
