import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInController extends GetxController {
  RxString id = "".obs;
  RxString role = "".obs;
  RxString name = "".obs;
  RxString email = "".obs;
  RxString avatar = "".obs;
  RxString token = "".obs;

  void clearUserData() {
    id.value = '';
    role.value = '';
    name.value = '';
    email.value = '';
    avatar.value = '';
    token.value = '';
  }

  // Role
  Future<void> setRole(String newRole) async {
    role.value = newRole;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_role", newRole);
  }

  Future<void> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    role.value = prefs.getString("user_role") ?? "";
  }

  // Name
  Future<void> setName(String userName) async {
    name.value = userName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_name", userName);
  }

  Future<void> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name.value = prefs.getString("user_name") ?? "";
  }

  // Email
  Future<void> setEmail(String userEmail) async {
    email.value = userEmail;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_email", userEmail);
  }

  Future<void> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email.value = prefs.getString("user_email") ?? "";
  }

  // Avatar
  Future<void> setAvatar(String userAvatar) async {
    avatar.value = userAvatar;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_avatar", userAvatar);
  }

  Future<void> getAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    avatar.value = prefs.getString("user_avatar") ?? "";
  }

  // ID
  Future<void> setId(String userId) async {
    id.value = userId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_id", userId);
  }

  Future<void> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id.value = prefs.getString("user_id") ?? "";
  }

  // Token
  Future<void> setToken(String userToken) async {
    token.value = userToken;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_token", userToken);
  }

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token.value = prefs.getString("user_token") ?? "";
  }
}
