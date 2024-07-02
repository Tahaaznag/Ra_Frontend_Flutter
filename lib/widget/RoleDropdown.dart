// role_dropdown.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoleDropdown extends StatelessWidget {
  final String? selectedRole;
  final Function(String?) onChanged;

  RoleDropdown({
    required this.selectedRole,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
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
          value: selectedRole,
          items: [
            DropdownMenuItem(value: "EXPERT", child: Text("Expert")),
            DropdownMenuItem(value: "TECHNICIEN", child: Text("Technicien")),
            DropdownMenuItem(value: "GUEST", child: Text("Guest")),
          ],
          onChanged: onChanged,
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
