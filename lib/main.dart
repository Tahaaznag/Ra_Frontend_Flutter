import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_assist/pages/Login.dart';
import 'package:remote_assist/pages/OnboardingScreen.dart';
import 'package:remote_assist/pages/Registration.dart';
import 'package:remote_assist/pages/WelcomePage.dart';
import 'package:remote_assist/pages/home.dart';
import 'package:remote_assist/pages/splashpage.dart';

void main() async {
  runApp(RaApp());
}

class RaApp extends StatelessWidget {
  const RaApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFB21A18), // Red primary color
        hintColor: Color(0xFFD32F2F), // Red accent color
        scaffoldBackgroundColor: Colors.white, // White background
        textTheme: TextTheme(),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFFB21A18), // Button color
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Color(0xFFD32F2F),
            textStyle: TextStyle(fontSize: 16.0),
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Color(0xFFB21A18), // Button text color
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFB21A18), // FloatingActionButton color
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFB21A18), // AppBar color
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),

      routes: {
        "/": (context) => SplashScreen(),
        "/login": (context) => LoginPage(),
        "/home": (context) => HomePage(),
        "/register": (context) => RegisterPage(),
        "/welcome": (context) => WelcomePage(),
        "/bv": (context) => OnboardingScreen(),
      },
      initialRoute: "/",
    );
  }
}
