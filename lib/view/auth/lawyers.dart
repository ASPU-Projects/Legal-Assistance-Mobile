import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Lawyers extends StatelessWidget {
  const Lawyers({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Lawyers")),
        body: Center(
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "18".tr,
                      suffix: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.search, color: Colors.black),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
