import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'usercontroller.dart';

class AgencyController extends GetxController {
  var agencies = [].obs;

  void setAgencies(List<dynamic> data) {
    agencies.value = data;
  }

  Future<void> loadAgencies() async {
    String token = Get.find<SignInController>().token.value;

    try {
      final response = await http.get(
        Uri.parse(
          "http://osamanaser2003-21041.portmap.host:21041/api/v1/web/byUser/agencies?status=pending",
        ),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          setAgencies(data['data']);
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }
}
