import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remote_assist/Service/AuthService.dart';
import 'package:remote_assist/pages/Registration.dart';
import 'package:remote_assist/pages/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      final success = await _authService.login(email, password);

      if (success) {Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      } else {
        // Affichez un message d'erreur
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login failed'),
        ));
      }
    }
  }
  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 650,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.red,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10, color: Colors.black, offset: Offset(1, 5))
                    ],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Column(
                    children: [
                      SizedBox(height: 100,),
                      Text("Login", style: GoogleFonts.pacifico(
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                          color: Colors.white
                      )),
                      SizedBox(height: 60,),
                      Align(
                        alignment: Alignment.center,
                        child: Text("Email", style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        )),
                      ),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      Container(
                        height: 5,
                        color: Colors.white,
                      ),
                      SizedBox(height: 60,),
                      Align(
                        alignment: Alignment.center,
                        child: Text("Password", style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        )),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      Container(
                        height: 5,
                        color: Colors.white,
                      ),
                      SizedBox(height: 60,),
                      GestureDetector(
                        onTap: _navigateToRegister,
                        child: Center(
                          child: Text(
                            "Don't have an account?",
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 70,
                width: 70,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40), // Rounded corners
                    ),
                  ),
                  onPressed: _login,
                  child: Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: Colors.white, // Icon color (set to black or another color you prefer)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}