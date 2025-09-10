import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_assistance_mobile/controller/issuescontroller.dart';

class IssueDetailsPage extends StatefulWidget {
  const IssueDetailsPage({super.key});

  @override
  State<IssueDetailsPage> createState() => _IssueDetailsPageState();
}

class _IssueDetailsPageState extends State<IssueDetailsPage> {
  final IssuesController issuesController = Get.find<IssuesController>();
  late int issueId;

  @override
  void initState() {
    super.initState();
    issueId = Get.arguments as int;
    issuesController.loadIssueDetails(issueId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("issue_details".tr),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              await issuesController.refreshIssueDetails(issueId);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (issuesController.isDetailLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (issuesController.detailErrorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(issuesController.detailErrorMessage.value),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await issuesController.refreshIssueDetails(issueId);
                  },
                  child: Text("retry".tr),
                ),
              ],
            ),
          );
        }

        if (issuesController.issueDetails.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Issue details not found".tr),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await issuesController.refreshIssueDetails(issueId);
                  },
                  child: Text("refresh".tr),
                ),
              ],
            ),
          );
        }

        final issue = issuesController.issueDetails;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
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
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(issue['status']),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        issue['status'] ?? 'Unknown',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getIssueTypeColor(
                                          issue['type'],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        issue['type'] ?? 'Unknown',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              _buildSectionTitle("issue_information".tr),
              _buildDetailCard("title".tr, issue['title']),
              _buildDetailCard("description".tr, issue['description']),
              _buildDetailCard("status".tr, issue['status']),
              _buildDetailCard("type".tr, issue['type']),
              _buildDetailCard("priority".tr, issue['priority']),
              _buildDetailCard(
                "created_at".tr,
                _formatDate(issue['created_at']),
              ),
              _buildDetailCard(
                "updated_at".tr,
                _formatDate(issue['updated_at']),
              ),

              SizedBox(height: 24),

              _buildSectionTitle("additional_information".tr),
              _buildDetailCard("category".tr, issue['category']),
              _buildDetailCard("assigned_to".tr, issue['assigned_to']),
              _buildDetailCard("resolution".tr, issue['resolution']),

              SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Add comment functionality
                    },
                    icon: Icon(Icons.comment),
                    label: Text("add_comment".tr),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Share functionality
                    },
                    icon: Icon(Icons.share),
                    label: Text("share".tr),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue[700],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, String? value) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 4),
            Text(value ?? 'Not available', style: TextStyle(fontSize: 16)),
          ],
        ),
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
      return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return dateString;
    }
  }
}
