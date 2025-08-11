import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Docsanlysis extends StatefulWidget {
  const Docsanlysis({super.key});

  @override
  State<Docsanlysis> createState() => _DocsanlysisState();
}

class _DocsanlysisState extends State<Docsanlysis> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Document Anlysis"),
          backgroundColor: theme.appBarTheme.backgroundColor,
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(child: Icon(Icons.image)),
            SpeedDialChild(child: Icon(Icons.picture_as_pdf)),
          ],
        ),
      ),
    );
  }
}
