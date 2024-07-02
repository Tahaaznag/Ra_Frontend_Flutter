import 'package:flutter/material.dart';
import 'package:remote_assist/Dtos/UserRaDto.dart';
import 'package:remote_assist/Service/UserService.dart';
import 'package:remote_assist/widget/EditForm.dart';
import 'package:remote_assist/widget/ProfileContent.dart';
import 'package:remote_assist/widget/loginPrompt.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserRaDto? _user;
  final UserService _userService = UserService();
  bool _isLoading = true;
  bool _isEditing = false;

  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _updateUserProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final updatedUser = UserRaDto(
          userId: _user!.userId,
          nom: _nomController.text,
          prenom: _prenomController.text,
          email: _emailController.text,
          roles: _user!.roles,
        );
        _user = await _userService.updateCurrentUser(updatedUser);
        setState(() {
          _isEditing = false;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      final user = await _userService.getCurrentUser();
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _user == null
          ? LoginPrompt()
          : _isEditing
          ? EditForm(
        formKey: _formKey,
        nomController: _nomController,
        prenomController: _prenomController,
        emailController: _emailController,
        onUpdateProfile: _updateUserProfile,
        onCancel: () {
          setState(() => _isEditing = false);
        },
      )
          : ProfileContent(
        user: _user!,
        onEdit: () {
          setState(() {
            _nomController.text = _user!.nom;
            _prenomController.text = _user!.prenom;
            _emailController.text = _user!.email;
            _isEditing = true;
          });
        },
      ),
    );
  }
}
