import 'package:flutter/material.dart';

class MyTextFeild extends StatelessWidget {
  const MyTextFeild({
    super.key,
    required this.text,
    required this.obscureText,
    this.validation,
    required this.controller,
    required this.textType,
  });
  final String text;
  final bool obscureText;
  // final Icon Eye;

  final String? Function(String?)? validation;
  final TextInputType textType;

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      decoration: BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextFormField(
          keyboardType: textType,
          controller: controller,
          validator: validation,
          obscureText: obscureText,
          decoration: InputDecoration(hintText: text),
        ),
      ),
    );
  }
}
