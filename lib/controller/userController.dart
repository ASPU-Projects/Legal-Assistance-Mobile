import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  RxString role = "".obs;
  RxString name = "".obs;
  Future<void> setRole(String newRole) async {
    role.value = newRole;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_role", newRole);
  }

  Future<void> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    role.value = prefs.getString("user_role") ?? "";
  }

  Future<void> setName(String userName) async {
    
  }
}
