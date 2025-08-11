import 'package:flutter/material.dart';

class Profilelist extends StatelessWidget {
  const Profilelist({
    super.key,
    required this.title,
    required this.text,
    required this.icon,
  });

  final String title;
  final String text;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(title), subtitle: Text(text), leading: icon);
  }
}
