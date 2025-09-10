import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:legal_assistance_mobile/controller/usercontroller.dart';

class IssuesController extends GetxController {
  var issues = [].obs;
  var issueDetails = {}.obs;
  var isLoading = true.obs;
  var isDetailLoading = false.obs;
  var errorMessage = ''.obs;
  var detailErrorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadIssues();
  }

  Future<void> loadIssues() async {
    try {
      isLoading(true);
      errorMessage('');

      String token = Get.find<SignInController>().token.value;

      final response = await http.post(
        Uri.parse(
          "http://osamanaser2003-21041.portmap.host:21041/api/v1/web/byUser/issues",
        ),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      // print("Issues Status code: ${response.statusCode}");
      // print("Issues Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == true && data['data'] != null) {
          issues.value = data['data'];
          print("Issues loaded: ${issues.length}");
        } else {
          errorMessage('No issues found');
        }
      } else {
        errorMessage('Failed to load issues: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage('Error: $e');
      print("Error fetching issues: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadIssueDetails(int issueId) async {
    try {
      isDetailLoading(true);
      detailErrorMessage('');

      String token = Get.find<SignInController>().token.value;

      final response = await http.post(
        Uri.parse(
          "http://osamanaser2003-21041.portmap.host:21041/api/v1/web/byUser/issues/$issueId",
        ),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      // print("Issue details status code: ${response.statusCode}");
      // print("Issue details response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == true && data['data'] != null) {
          issueDetails.value = data['data'];
          print("Issue details loaded");
        } else {
          detailErrorMessage('Issue details not found');
        }
      } else {
        detailErrorMessage(
          'Failed to load issue details: ${response.statusCode}',
        );
      }
    } catch (e) {
      detailErrorMessage('Error: $e');
      print("Error fetching issue details: $e");
    } finally {
      isDetailLoading(false);
    }
  }

  Future<void> refreshIssues() async {
    await loadIssues();
  }

  Future<void> refreshIssueDetails(int issueId) async {
    await loadIssueDetails(issueId);
  }
}
