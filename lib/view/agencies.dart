import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_assistance_mobile/controller/agenciescontroller.dart';
import 'package:legal_assistance_mobile/view/agencyDetailsPage.dart';

class AgenciesPage extends StatefulWidget {
  const AgenciesPage({super.key});

  @override
  State<AgenciesPage> createState() => _AgenciesPageState();
}

class _AgenciesPageState extends State<AgenciesPage> {
  final AgencyController agencyController = Get.put(AgencyController());

  @override
  void initState() {
    super.initState();
    agencyController.loadAgencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("agencies".tr)),
        body: Column(
          children: [
            // Agencies List
            Expanded(
              child: Obx(() {
                if (agencyController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (agencyController.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(agencyController.errorMessage.value),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: agencyController.refreshAgencies,
                          child: Text("retry".tr),
                        ),
                      ],
                    ),
                  );
                }
                if (agencyController.agencies.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No agencies found".tr),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: agencyController.refreshAgencies,
                          child: Text("refresh".tr),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: agencyController.refreshAgencies,
                  child: ListView.builder(
                    itemCount: agencyController.agencies.length,
                    itemBuilder: (context, index) {
                      final agency = agencyController.agencies[index];
                      return AgencyCard(
                        agency: agency,
                        onUpdateStatus: (status) {
                          agencyController.updateAgencyStatus(
                            agency['id'],
                            status,
                          );
                        },
                        onDelete: () {
                          agencyController.deleteAgency(agency['id']);
                        },
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// Agency Card Widget (unchanged)
class AgencyCard extends StatelessWidget {
  final Map<String, dynamic> agency;
  final Function(String) onUpdateStatus;
  final Function() onDelete;

  const AgencyCard({
    super.key,
    required this.agency,
    required this.onUpdateStatus,
    required this.onDelete,
  });

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: InkWell(
        onTap: () {
          // Navigate to agency details
          Get.to(AgencyDetailsPage(), arguments: agency['id']);
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        agency['lawyer_avatar'] != null
                            ? NetworkImage(agency['lawyer_avatar'])
                            : AssetImage('assets/placeholder_avatar.png')
                                as ImageProvider,
                    onBackgroundImageError: (exception, stackTrace) {
                      print('Error loading avatar: $exception');
                    },
                    child:
                        agency['lawyer_avatar'] == null
                            ? Icon(Icons.person, size: 30)
                            : null,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          agency['lawyer_name'] ?? 'Unknown Lawyer',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(agency['status']),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Status: ${agency['status'] ?? 'Unknown'}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
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
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "User: ${agency['user_name'] ?? 'Unknown'}",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'update_status') {
                        _showUpdateStatusDialog(context);
                      } else if (value == 'delete') {
                        _showDeleteConfirmationDialog(context);
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'update_status',
                          child: Text('Update Status'),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUpdateStatusDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String selectedStatus = agency['status'];
        return AlertDialog(
          title: Text('Update Agency Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Current status: ${agency['status']}'),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                items:
                    ['pending', 'approved', 'rejected', 'cancelled']
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status.tr),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  selectedStatus = value!;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onUpdateStatus(selectedStatus);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Agency'),
          content: Text('Are you sure you want to delete this agency?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onDelete();
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
