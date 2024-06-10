
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remote_assist/pages/Login.dart';
import 'package:remote_assist/pages/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Bienvenu dans Bl Remote Assist",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),

      ),
    );
  }
}
