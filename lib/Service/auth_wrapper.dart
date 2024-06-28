import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remote_assist/Service/AuthService.dart';
import 'package:remote_assist/pages/Login.dart';

class AuthWrapper extends StatelessWidget {
  final Widget child;

  const AuthWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return FutureBuilder<bool>(
      future: authService.isAuthenticated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data == true) {
          return child;
        } else {
          return LoginPage();
        }
      },
    );
  }
}