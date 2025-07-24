import 'package:flutter/material.dart';

class MyTextFeild extends StatelessWidget {
  const MyTextFeild({super.key, required this.text, required this.obscureText});
  final String text;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          obscureText: obscureText,
          decoration: InputDecoration(border: InputBorder.none, hintText: text),
        ),
      ),
    );
  }
}
