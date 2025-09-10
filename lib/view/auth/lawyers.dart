import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:legal_assistance_mobile/controller/usercontroller.dart';
import 'dart:convert';
import 'package:legal_assistance_mobile/view/user/hire.dart';

class Lawyers extends StatefulWidget {
  const Lawyers({super.key});

  @override
  State<Lawyers> createState() => _LawyersState();
}

class _LawyersState extends State<Lawyers> {
  // State variables
  bool _isLoading = true;
  List<dynamic> _lawyers = [];
  String? _error;
  String lawyer_id = "";

  // Controllers
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchLawyers(); // Load data when page opens
  }

  // Fetch one lawyer
  Future<void> searchForLawyer(String name) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    String token = Get.find<SignInController>().token.value;
    try {
      final response = await http.get(
        Uri.parse(
          "http://osamanaser2003-21041.portmap.host:21041/api/v1/web/byUser/lawyers/?name=$name",
        ),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      // print("Status code: ${response.statusCode}");
      // print("Response body: ${response.body}");

      final data = jsonDecode(response.body);

      print(lawyer_id);
      if (response.statusCode == 200) {
        setState(() {
          _lawyers = data['data'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = "Failed_to_load_lawyer".tr;
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

  // fetch all lawyers
  Future<void> fetchLawyers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    String token = Get.find<SignInController>().token.value;
    try {
      // Replace with your actual lawyers endpoint
      final response = await http.get(
        Uri.parse(
          "http://osamanaser2003-21041.portmap.host:21041/api/v1/web/byUser/lawyers",
        ),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Status code: ${response.statusCode}");
      // print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _lawyers =
              data['data'] ?? []; // Adjust based on your API response structure
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = "Failed to load lawyers. Status: ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Error: $e";
        _isLoading = false;
      });
      print("Error fetching lawyers: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("lawyers".tr)),
        body: Column(
          children: [
            // Search bar
            Card(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "search".tr,
                    suffixIcon: IconButton(
                      onPressed: () {
                        searchForLawyer(_searchController.text);

                        // Implement search functionality
                        print("Searching for: ${_searchController.text}");
                      },
                      icon: Icon(Icons.search, color: Colors.black),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            // Lawyers list
            Expanded(child: _buildLawyersList()),
          ],
        ),
      ),
    );
  }

  Widget _buildLawyersList() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: TextStyle(color: Colors.red)),
            SizedBox(height: 20),
            ElevatedButton(onPressed: fetchLawyers, child: Text("retry".tr)),
          ],
        ),
      );
    }

    if (_lawyers.isEmpty) {
      return Center(child: Text("Nolawyersfound".tr));
    }

    return RefreshIndicator(
      onRefresh: fetchLawyers,
      child: ListView.builder(
        itemCount: _lawyers.length,
        itemBuilder: (context, index) {
          final lawyer = _lawyers[index];
          return Card(
            child: ListTile(
              title: Text(lawyer['name'] ?? ""),
              leading: CircleAvatar(
                backgroundImage:
                    lawyer['avatar'] != null
                        ? NetworkImage(lawyer['avatar'])
                        : null,
                child: lawyer['avatar'] == null ? Icon(Icons.person) : null,
              ),
              subtitle: Text(lawyer['phone'] ?? ""),
              onTap: () {
                Get.to(HireLawyer(lawyer_id: lawyer['id'].toString()));
              },
            ),
          );
        },
      ),
    );
  }
}
