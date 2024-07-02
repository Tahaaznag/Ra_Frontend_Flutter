import 'package:flutter/material.dart';

class LoginPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Please log in to view your profile'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            child: Text('Log In'),
          ),
        ],
      ),
    );
  }
}
