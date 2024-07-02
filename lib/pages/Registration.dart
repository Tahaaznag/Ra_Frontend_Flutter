// register_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remote_assist/Service/AuthService.dart';
import 'package:remote_assist/pages/Login.dart';
import 'package:remote_assist/widget/CustomTextField.dart';
import 'package:remote_assist/widget/RoleDropdown.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  String? _selectedRole;
  bool _isPasswordVisible = false;

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedRole == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a role.')),
        );
        return;
      }

      final success = await _authService.register(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
        _prenomController.text,
        _selectedRole!,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed. Please try again.')),
        );
      }
    }
  }

  void _navigateToLogin() {
    Navigator.pushNamed(context, '/login');
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
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
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(top: 40),
                child: Center(
                  child: Text(
                    "Bienvenue sur BL Remote Assist",
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      label: "Nom",
                      controller: _nameController,
                      obscureText: false,
                      isPasswordVisible: _isPasswordVisible,
                      togglePasswordVisibility: _togglePasswordVisibility,
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      label: "Prénom",
                      controller: _prenomController,
                      obscureText: false,
                      isPasswordVisible: _isPasswordVisible,
                      togglePasswordVisibility: _togglePasswordVisibility,
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      label: "Email",
                      controller: _emailController,
                      obscureText: false,
                      isPasswordVisible: _isPasswordVisible,
                      togglePasswordVisibility: _togglePasswordVisibility,
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      label: "Mot de passe",
                      controller: _passwordController,
                      obscureText: true,
                      isPasswordVisible: _isPasswordVisible,
                      togglePasswordVisibility: _togglePasswordVisibility,
                    ),
                    SizedBox(height: 20),
                    RoleDropdown(
                      selectedRole: _selectedRole,
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value;
                        });
                      },
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 30), backgroundColor: Color(0xFFB21A18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _register,
                        child: Text(
                          "S'inscrire",
                          style: GoogleFonts.roboto(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        onTap: _navigateToLogin,
                        child: Text(
                          "Vous avez déjà un compte ? Connectez-vous",
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: Color(0xFFB21A18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
