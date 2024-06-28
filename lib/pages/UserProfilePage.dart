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
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement du profil')),
      );
    }
  }

  Future<void> _updateProfile() async {
    try {
      await _userService.updateUser(_user!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profil mis à jour avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la mise à jour du profil')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Mon Profil')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Mon Profil')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Nom'),
              onChanged: (value) => setState(() => _user!.nom = value),
              controller: TextEditingController(text: _user!.nom),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Prénom'),
              onChanged: (value) => setState(() => _user!.prenom = value),
              controller: TextEditingController(text: _user!.prenom),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (value) => setState(() => _user!.email = value),
              controller: TextEditingController(text: _user!.email),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Mettre à jour le profil'),
            ),
          ],
        ),
      ),
    );
  }
}