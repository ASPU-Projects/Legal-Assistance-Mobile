import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'usercontroller.dart';

class AgencyController extends GetxController {
  var agencies = [].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var selectedStatus = 'pending'.obs;

  // Available status options
  final List<String> statusOptions = [
    'all',
    'pending',
    'approved',
    'rejected',
    'cancelled',
  ];

  void setAgencies(List<dynamic> data) {
    agencies.value = data;
  }

  Future<void> loadAgencies({String status = 'pending'}) async {
    try {
      isLoading(true);
      errorMessage('');

      String token = Get.find<SignInController>().token.value;

      // Build URL with status filter if not 'all'

      final response = await http.get(
        Uri.parse(
          "http://osamanaser2003-21041.portmap.host:21041/api/v1/web/byUser/agencies",
        ),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      // print("Status code: ${response.statusCode}");
      // print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          setAgencies(data['data'] ?? []);
        } else {
          errorMessage('No agencies found');
        }
      } else {
        errorMessage('Failed to load agencies: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage('Error: $e');
      print("Exception: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> refreshAgencies() async {
    await loadAgencies(status: selectedStatus.value);
  }

  void changeStatusFilter(String status) {
    selectedStatus.value = status;
    loadAgencies(status: status);
  }

  Future<void> updateAgencyStatus(int agencyId, String status) async {
    try {
      String token = Get.find<SignInController>().token.value;

      final response = await http.put(
        Uri.parse(
          "http://osamanaser2003-21041.portmap.host:21041/api/v1/web/byUser/agencies/$agencyId",
        ),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({'status': status}),
      );

      if (response.statusCode == 200) {
        final index = agencies.indexWhere((agency) => agency['id'] == agencyId);
        if (index != -1) {
          agencies[index]['status'] = status;
          agencies.refresh();
        }

        Get.snackbar(
          'Success',
          'Agency status updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to update agency status',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error updating agency status: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteAgency(int agencyId) async {
    try {
      String token = Get.find<SignInController>().token.value;

      final response = await http.delete(
        Uri.parse(
          "http://osamanaser2003-21041.portmap.host:21041/api/v1/web/byUser/agencies/$agencyId",
        ),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        // Remove the agency from the list
        agencies.removeWhere((agency) => agency['id'] == agencyId);

        Get.snackbar(
          'Success',
          'Agency deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete agency',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error deleting agency: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
