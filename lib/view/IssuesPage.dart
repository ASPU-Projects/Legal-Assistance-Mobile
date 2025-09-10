import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_assistance_mobile/controller/issuescontroller.dart';
import 'package:legal_assistance_mobile/view/IssueDetailsPage.dart';

class IssuesPage extends StatefulWidget {
  const IssuesPage({super.key});

  @override
  State<IssuesPage> createState() => _IssuesPageState();
}

class _IssuesPageState extends State<IssuesPage> {
  final issuesController = Get.put(IssuesController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("issues".tr),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async {
                await issuesController.refreshIssues();
              },
            ),
          ],
        ),
        body: Obx(() {
          if (issuesController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (issuesController.errorMessage.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(issuesController.errorMessage.value),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await issuesController.refreshIssues();
                    },
                    child: Text("retry".tr),
                  ),
                ],
              ),
            );
          }

          if (issuesController.issues.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No issues found".tr),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await issuesController.refreshIssues();
                    },
                    child: Text("refresh".tr),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: issuesController.refreshIssues,
            child: ListView.builder(
              itemCount: issuesController.issues.length,
              itemBuilder: (context, index) {
                final issue = issuesController.issues[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  child: InkWell(
                    onTap: () {
                      Get.to(() => IssueDetailsPage(), arguments: issue['id']);
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.description,
                                size: 30,
                                color: _getIssueTypeColor(issue['type']),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      issue['title'] ?? 'No Title',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Status: ${issue['status'] ?? 'Unknown'}",
                                      style: TextStyle(
                                        color: _getStatusColor(issue['status']),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            issue['description'] ?? 'No Description',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Type: ${issue['type'] ?? 'Unknown'}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                "Created: ${_formatDate(issue['created_at'])}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;

    switch (status.toLowerCase()) {
      case 'open':
        return Colors.blue;
      case 'in_progress':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  Color _getIssueTypeColor(String? type) {
    if (type == null) return Colors.grey;

    switch (type.toLowerCase()) {
      case 'legal':
        return Colors.purple;
      case 'financial':
        return Colors.green;
      case 'family':
        return Colors.blue;
      case 'criminal':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown';

    try {
      final date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return dateString;
    }
  }
}
