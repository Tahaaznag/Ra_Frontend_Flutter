import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 15), () {
      Navigator.pushReplacementNamed(context, '/bv');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB21A18),
      body: Center(
        child: Image.asset(
          'lib/icons/images/bl.jpg',
          height: 300.0,
          width: 300.0,
        ),
      ),
    );
  }
}
