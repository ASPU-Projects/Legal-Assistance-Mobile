import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:legal_assistance_mobile/controller/usercontroller.dart';
import 'package:legal_assistance_mobile/view/agencies.dart';
import 'package:legal_assistance_mobile/view/auth/lawyers.dart';
import 'package:legal_assistance_mobile/view/profile.dart';
import 'package:legal_assistance_mobile/view/settings.dart';
import 'package:legal_assistance_mobile/view/chat/chatPage.dart';
import 'package:legal_assistance_mobile/view/auth/signin.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final SignInController _userController = Get.find<SignInController>();

  String get role => _userController.role.value;
  String get username => _userController.name.value;
  String get email => _userController.email.value;
  String get avatar => _userController.avatar.value;

  bool _isLoggingOut = false;

  Future<void> _logout() async {
    // Show confirmation dialog
    final confirmed = await Get.dialog(
      AlertDialog(
        title: Text("confirm_logout".tr),
        content: Text("are_you_sure_logout".tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text("cancel".tr),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text("logout".tr),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoggingOut = true;
    });

    try {
      String token = _userController.token.value;

      final response = await http.post(
        Uri.parse(
          "http://osamanaser2003-21041.portmap.host:21041/api/v1/auth/logout",
        ),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      // print("Logout status code: ${response.statusCode}");
      // print("Logout response body: ${response.body}");

      if (response.statusCode == 200) {
        // Clear user data from controller
        _userController.clearUserData();

        // Show success message
        Get.snackbar(
          "success".tr,
          "logout_success".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to login screen and remove all previous routes
        Get.offAll(() => SignIn());
      } else {
        // Show error message
        Get.snackbar(
          "error".tr,
          "logout_failed".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error during logout: $e");

      // Even if there's an error, clear local data and navigate to login
      _userController.clearUserData();

      Get.snackbar(
        "warning".tr,
        "logout_error".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );

      Get.offAll(() => SignIn());
    } finally {
      setState(() {
        _isLoggingOut = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(avatar),
              onBackgroundImageError: (exception, stackTrace) {
                print('Error loading avatar: $exception');
              },
              child: avatar.isEmpty ? Icon(Icons.person, size: 40) : null,
            ),
            accountName: Text(username),
            accountEmail: Text(email),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Common items for all users
                _buildDrawerItem(
                  icon: Icons.person,
                  title: "profile".tr,
                  onTap: () => Get.to(() => Profile()),
                ),
                _buildDrawerItem(
                  icon: Icons.description,
                  title: "agencies".tr,
                  onTap: () => Get.to(() => AgenciesPage()),
                ),
                // Items for users and lawyers only
                if (role == "user" || role == "lawyer") ...[
                  _buildDrawerItem(
                    icon: Icons.report_problem,
                    title: "issues".tr,
                    onTap: () {
                      Get.snackbar(
                        "info".tr,
                        "coming_soon".tr,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                ],

                _buildDrawerItem(
                  icon: Icons.people,
                  title: "lawyers".tr,
                  onTap: () => Get.to(Lawyers()),
                ),

                // Chat item for users and lawyers only
                if (role == "user" || role == "lawyer") ...[
                  _buildDrawerItem(
                    icon: Icons.chat,
                    title: "chat".tr,
                    onTap: () => Get.to(ChatPage()),
                  ),
                ],

                _buildDrawerItem(
                  icon: Icons.settings,
                  title: "settings".tr,
                  onTap: () => Get.to(Settings()),
                ),

                // Fasih item for users and lawyers only
                if (role == "user" || role == "lawyer") ...[
                  _buildDrawerItem(
                    icon: Icons.gavel,
                    title: "fasih".tr,
                    onTap: () {
                      Get.snackbar(
                        "info".tr,
                        "coming_soon".tr,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),

                  _buildDrawerItem(
                    icon: Icons.thumb_up,
                    title: "recommendation_system".tr,
                    onTap: () {                      
                      Get.snackbar(
                        "info".tr,
                        "coming_soon".tr,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                ],

                Divider(),

                // Logout item
                _isLoggingOut
                    ? ListTile(
                      title: Row(
                        children: [
                          Text("logging_out".tr),
                          SizedBox(width: 10),
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ],
                      ),
                    )
                    : _buildDrawerItem(
                      icon: Icons.logout,
                      title: "logout".tr,
                      onTap: _logout,
                      color: Colors.red,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      onTap: onTap,
    );
  }
}
