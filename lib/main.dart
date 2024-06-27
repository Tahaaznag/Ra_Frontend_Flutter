import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:remote_assist/Service/web_socket_service.dart';
import 'package:remote_assist/pages/Login.dart';
import 'package:remote_assist/pages/OnboardingScreen.dart';
import 'package:remote_assist/pages/Registration.dart';
import 'package:remote_assist/pages/UserProfilePage.dart';
import 'package:remote_assist/pages/WelcomePage.dart';
import 'package:remote_assist/pages/chat_screen.dart';
import 'package:remote_assist/pages/home.dart';
import 'package:remote_assist/pages/splashpage.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<WebSocketService>(create: (_) => WebSocketService()),
      ],
      child: RaApp(),
    ),
  );
}

class RaApp extends StatelessWidget {
  const RaApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFB21A18),
        hintColor: Color(0xFFD32F2F),
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFFB21A18),
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
            foregroundColor: Color(0xFFB21A18),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFB21A18),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFB21A18),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      routes: {
        "/": (context) => SplashScreen(),
        "/login": (context) => LoginPage(),
        "/home": (context) => HomePage(),
        "/register": (context) => RegisterPage(),
        "/welcome": (context) => WelcomePage(),
        "/bv": (context) => OnboardingScreen(),
        "/chat": (context) => ChatScreen(),
        "/user":(context)=>UserProfilePage()
      },
      initialRoute: "/",
    );
  }
}
