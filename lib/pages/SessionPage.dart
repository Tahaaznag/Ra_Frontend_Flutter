import 'dart:convert';
import 'package:curved_navigation_bar_with_label/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:remote_assist/pages/Login.dart';

class CreateSessionPage extends StatefulWidget {
  @override
  _CreateSessionPageState createState() => _CreateSessionPageState();
}

class _CreateSessionPageState extends State<CreateSessionPage> {
  final TextEditingController _sessionNameController = TextEditingController();
  final TextEditingController _dateDebutController = TextEditingController();
  final TextEditingController _dateFinController = TextEditingController();

  Future<void> createSession() async {
    final String sessionName = _sessionNameController.text;
    final String dateDebut = _dateDebutController.text;
    final String dateFin = _dateFinController.text;

    final String url = 'http://10.50.100.15:8081/api/session/create'; // Remplacez par l'URL correcte
    print('URL: $url');
    print('Payload: $sessionName, $dateDebut, $dateFin');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'sessionName': sessionName,
          'dateDebut': dateDebut,
          'dateFin': dateFin,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Session créée avec succès!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la création de la session')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la création de la session: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _sessionNameController,
              decoration: InputDecoration(labelText: 'Nom de la Session'),
            ),
            TextField(
              controller: _dateDebutController,
              decoration: InputDecoration(labelText: 'Date de Début (dd-MM-yyyy)'),
              keyboardType: TextInputType.datetime,
            ),
            TextField(
              controller: _dateFinController,
              decoration: InputDecoration(labelText: 'Date de Fin (dd-MM-yyyy)'),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: createSession,
              child: Text('Créer la Session'),
            ),
          ],
        ),
      ),
    );
  }
}
