import 'package:flutter/material.dart';
import 'package:remote_assist/pages/Login.dart';
import 'package:remote_assist/pages/home.dart';
import 'package:get/get.dart';
import 'package:remote_assist/pages/splashpage.dart';




void main() async{
  runApp(RaApp());

}

class RaApp extends StatelessWidget {
  const RaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => SplashScreen(),
}
    );
    }
}