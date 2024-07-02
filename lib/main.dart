import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:remote_assist/Service/AuthService.dart';
import 'package:remote_assist/Service/auth_wrapper.dart';
import 'package:remote_assist/Service/web_socket_service.dart';
import 'package:remote_assist/icons/util/ThemeNotifier.dart';
import 'package:remote_assist/pages/Login.dart';
import 'package:remote_assist/pages/OnboardingScreen.dart';
import 'package:remote_assist/pages/Registration.dart';
import 'package:remote_assist/pages/UserProfilePage.dart';
import 'package:remote_assist/pages/VideoCallScreen.dart';
import 'package:remote_assist/pages/WelcomePage.dart';
import 'package:remote_assist/pages/chat_screen.dart';
import 'package:remote_assist/pages/home.dart';
import 'package:remote_assist/pages/session_screen.dart';
import 'package:remote_assist/pages/splashpage.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<WebSocketService>(create: (_) => WebSocketService()),
        Provider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier()),
      ],
      child: RaApp(),
    ),
  );
}

class RaApp extends StatelessWidget {
  const RaApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Color(0xFFB21A18),
            hintColor: Color(0xFFB21A18),
            scaffoldBackgroundColor: Colors.white,
            textTheme: TextTheme(
              displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            buttonTheme: ButtonThemeData(
              buttonColor: Color(0xFFB21A18),
              textTheme: ButtonTextTheme.primary,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFFB21A18),
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
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: Color(0xFFB21A18),
              unselectedItemColor: Colors.grey,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: Color(0xFFB21A18),
            hintColor: Color(0xFFB21A18),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: Color(0xFFB21A18),
              unselectedItemColor: Colors.grey,
            ),
          ),
          themeMode: themeNotifier.currentTheme,
          routes: {
            "/": (context) => SplashScreen(),
            "/login": (context) => LoginPage(),
            "/home": (context) => AuthWrapper(child: HomePage()),
            "/register": (context) => RegisterPage(),
            "/welcome": (context) => AuthWrapper(child: WelcomePage()),
            "/bv": (context) => OnboardingScreen(),
            "/chat": (context) => AuthWrapper(child: ChatScreen()),
            "/user": (context) => AuthWrapper(child: ProfileScreen()),
            "/vd": (context) => AuthWrapper(child: VideoConferenceScreen()),
            "/ss": (context) => AuthWrapper(child: SessionManagementScreen()),


          },
          initialRoute: "/",
        );
      },
    );
  }
}