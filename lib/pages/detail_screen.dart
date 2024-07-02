import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String label;

  DetailScreen({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: Center(
        child: Text(
          "Information about $label",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}