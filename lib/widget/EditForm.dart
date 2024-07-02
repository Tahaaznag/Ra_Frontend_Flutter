import 'package:flutter/material.dart';
import 'package:remote_assist/Dtos/UserRaDto.dart';

class EditForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nomController;
  final TextEditingController prenomController;
  final TextEditingController emailController;
  final VoidCallback onUpdateProfile;
  final VoidCallback onCancel;

  EditForm({
    required this.formKey,
    required this.nomController,
    required this.prenomController,
    required this.emailController,
    required this.onUpdateProfile,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: nomController,
            decoration: InputDecoration(labelText: 'Nom'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: prenomController,
            decoration: InputDecoration(labelText: 'Prénom'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: onUpdateProfile,
            child: Text('Update Profile'),
          ),
          TextButton(
            onPressed: onCancel,
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
