import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remote_assist/pages/Login.dart';
import 'package:remote_assist/pages/Registration.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white, // Fond blanc
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Image.asset(
              'lib/icons/images/image1.png', // Remplacez par le chemin de votre image
              height: 200,
            ),
            SizedBox(height: 30),
            Text(
              "Bienvenue à BL Remote Assist",
              style: GoogleFonts.dmSerifText(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Texte noir pour un bon contraste avec le fond blanc
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              "Commencez votre assistant à distance",
              style: GoogleFonts.roboto(
                fontSize: 18,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            _buildNavigationButton(
              context,
              "Login",
              Icons.login,
              Colors.white,
              LoginPage(),
            ),
            SizedBox(height: 20),
            _buildNavigationButton(
              context,
              "Register",
              Icons.app_registration,
              Colors.white,
              RegisterPage(),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context, String text, IconData icon, Color color, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Color(0xFFB21A18),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(2, 4),
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            SizedBox(width: 10),
            Text(
              text,
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
