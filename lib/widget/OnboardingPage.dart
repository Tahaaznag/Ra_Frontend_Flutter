
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final bool lastPage;

  OnboardingPage({
    required this.image,
    required this.title,
    required this.description,
    this.lastPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image),
          SizedBox(height: 32.0),
          Text(
            title,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.0),
          Text(
            description,
            style: TextStyle(fontSize: 16.0, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
