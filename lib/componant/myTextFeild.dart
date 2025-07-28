import 'package:flutter/material.dart';

class MyTextFeild extends StatelessWidget {
  const MyTextFeild({super.key, required this.text, required this.obscureText});
  final String text;
  final bool obscureText;
  // final Icon Eye;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      decoration: BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          obscureText: obscureText,
          decoration: InputDecoration(hintText: text),
        ),
      ),
    );
  }
}
