// custom_text_field.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final bool isPasswordVisible;
  final Function togglePasswordVisibility;

  CustomTextField({
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.isPasswordVisible = false,
    required this.togglePasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
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
          obscureText: obscureText ? !isPasswordVisible : false,
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
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () => togglePasswordVisibility(),
            )
                : null,
          ),
        ),
      ],
    );
  }
}
