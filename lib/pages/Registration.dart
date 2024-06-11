import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remote_assist/Service/AuthService.dart';
import 'package:remote_assist/pages/Login.dart';

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
                    _buildTextField("Nom", _nameController),
                    SizedBox(height: 20),
                    _buildTextField("Prénom", _prenomController),
                    SizedBox(height: 20),
                    _buildTextField("Email", _emailController),
                    SizedBox(height: 20),
                    _buildTextField("Mot de passe", _passwordController, obscureText: true),
                    SizedBox(height: 20),
                    _buildRoleDropdown(),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 30), backgroundColor: Colors.red,
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
                            color: Colors.red,
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

  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controller,
          obscureText: obscureText ? !_isPasswordVisible : false,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer votre $label';
            }
            return null;
          },
          style: TextStyle(fontSize: 20, color: Colors.black),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: obscureText
                ? IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sélectionner un rôle",
          style: GoogleFonts.roboto(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _selectedRole,
          items: [
            DropdownMenuItem(value: "EXPERT", child: Text("Expert")),
            DropdownMenuItem(value: "TECHNICIEN", child: Text("Technicien")),
            DropdownMenuItem(value: "GUEST", child: Text("Guest")),
          ],
          onChanged: (value) {
            setState(() {
              _selectedRole = value;
            });
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) {
            if (value == null) {
              return 'Veuillez sélectionner un rôle';
            }
            return null;
          },
        ),
      ],
    );
  }
}
