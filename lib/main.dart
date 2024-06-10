import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_assist/pages/Login.dart';
import 'package:remote_assist/pages/Registration.dart';
import 'package:remote_assist/pages/WelcomePage.dart';
import 'package:remote_assist/pages/home.dart';
import 'package:remote_assist/pages/splashpage.dart';

void main() async {
  runApp(RaApp());
}

class RaApp extends StatelessWidget {
  const RaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => SplashScreen(), // Show splash screen first
        "/login": (context) => LoginPage(),
        "/home": (context) => HomePage(),
        "/register": (context) => RegisterPage(),
        "/welcome": (context) => WelcomePage(),

      },
      initialRoute: "/",
    );
  }
}
