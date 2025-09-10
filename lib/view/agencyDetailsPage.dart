import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AgencyDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final agency = Get.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text("agency_details".tr),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        agency['lawyer_avatar'] != null
                            ? NetworkImage(agency['lawyer_avatar'])
                            : AssetImage('assets/default_avatar.png')
                                as ImageProvider,
                    child:
                        agency['lawyer_avatar'] == null
                            ? Icon(Icons.person, size: 60)
                            : null,
                  ),
                  SizedBox(height: 16),
                  Text(
                    agency['lawyer_name'] ?? 'Unknown Lawyer',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(agency['status']),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      agency['status'] ?? 'Unknown',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            _buildSectionTitle("agency_information".tr),
            _buildDetailCard(
              "sequential_number".tr,
              agency['sequential_number'],
            ),
            _buildDetailCard("record_number".tr, agency['record_number']),
            _buildDetailCard("type".tr, agency['type']),
            _buildDetailCard("place_of_issue".tr, agency['place_of_issue']),
            _buildDetailCard("status".tr, agency['status']),
            _buildDetailCard("is_active".tr, agency['is_active']),
            _buildDetailCard("is_isolated".tr, agency['is_isolated']),
            _buildDetailCard("is_archived".tr, agency['is_archived']),
            _buildDetailCard("updated_at".tr, agency['updated_at']),

            SizedBox(height: 24),
            _buildSectionTitle("people_involved".tr),
            _buildPersonCard(
              "user".tr,
              agency['user_name'],
              agency['user_avatar'],
            ),
            _buildPersonCard(
              "lawyer".tr,
              agency['lawyer_name'],
              agency['lawyer_avatar'],
            ),
            _buildPersonCard(
              "representative".tr,
              agency['representative_name'],
              null,
            ),

            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    if (agency['pdf_path'] != null) {
                      print("Opening PDF: ${agency['pdf_path']}");
                      // You can use a package like flutter_pdf_view to display the PDF
                    }
                  },
                  icon: Icon(Icons.picture_as_pdf),
                  label: Text("view_pdf".tr),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Share functionality
                  },
                  icon: Icon(Icons.share),
                  label: Text("share".tr),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
        child: Row(
          children: [
            SizedBox(
              width: 120,
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Expanded(
              child: Text(
                value ?? 'Not available',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonCard(String role, String? name, String? avatar) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage:
                  avatar != null
                      ? NetworkImage(avatar)
                      : AssetImage('assets/default_avatar.png')
                          as ImageProvider,
              child: avatar == null ? Icon(Icons.person, size: 24) : null,
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                Text(
                  name ?? 'Unknown',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;

    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
