import 'package:flutter/material.dart';
import 'package:remote_assist/Dtos/UserRaDto.dart';
import 'package:remote_assist/Service/UserService.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserRaDto? _user;
  final UserService _userService = UserService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
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
        SnackBar(content: Text('Erreur lors du chargement du profil: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mon Profil')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _user == null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Veuillez vous connecter pour voir votre profil'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Se connecter'),
            ),
          ],
        ),
      )
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nom: ${_user!.nom}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Prénom: ${_user!.prenom}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Email: ${_user!.email}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
