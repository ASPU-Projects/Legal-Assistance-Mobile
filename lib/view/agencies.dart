import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_assistance_mobile/controller/agenciescontroller.dart';

class AgenciesPage extends StatefulWidget {
  const AgenciesPage({super.key});

  @override
  State<AgenciesPage> createState() => _AgenciesPageState();
}

class _AgenciesPageState extends State<AgenciesPage> {
  final agencyController = Get.put(AgencyController());

  @override
  void initState() {
    super.initState();
    agencyController.loadAgencies(); // Call from controller
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("agencies".tr)),
        body: Obx(() {
          if (agencyController.agencies.isEmpty) {
            return Center(child: Text("No agencies found"));
          }

          return ListView.builder(
            itemCount: agencyController.agencies.length,
            itemBuilder: (context, index) {
              final agency = agencyController.agencies[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(agency['lawyer_avatar'] ?? ''),
                ),
                title: Text(agency['lawyer_name'] ?? ''),
                subtitle: Text("Status: ${agency['status']}"),
                trailing: Text("User: ${agency['user_name']}"),
              );
            },
          );
        }),
      ),
    );
  }
}
