import 'package:flutter/material.dart';
import 'package:remote_assist/Dtos/SessioRaDto.dart';
import 'package:remote_assist/Service/SessionService.dart';

class SessionManagementScreen extends StatefulWidget {
  @override
  _SessionManagementScreenState createState() => _SessionManagementScreenState();
}

class _SessionManagementScreenState extends State<SessionManagementScreen> {
  final SessionService sessionService = SessionService();
  final TextEditingController sessionNameController = TextEditingController();
  final TextEditingController roomCodeController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  Future<void> createNewSession() async {
    if (sessionNameController.text.isEmpty || startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    final newSession = SessionRaDto(
      sessionName: sessionNameController.text,
      dateDebut: startDate!,
      dateFin: endDate!,
    );

    try {
      final createdSession = await sessionService.createSession(newSession);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Session créée avec succès : ${createdSession.roomCode}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la création de la session : $e')),
      );
    }
  }

  Future<void> joinExistingSession() async {
    if (roomCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer un code de salle')),
      );
      return;
    }

    try {
      final joinedSession = await sessionService.joinSession(roomCodeController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Session rejointe avec succès : ${joinedSession.sessionName}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la tentative de rejoindre la session : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Créer une nouvelle session', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: sessionNameController,
              decoration: InputDecoration(labelText: 'Nom de la session'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (picked != null) setState(() => startDate = picked);
              },
              child: Text('Choisir la date de début'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (picked != null) setState(() => endDate = picked);
              },
              child: Text('Choisir la date de fin'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: createNewSession,
              child: Text('Créer la session'),
            ),
            SizedBox(height: 40),
            Text('Rejoindre une session existante', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: roomCodeController,
              decoration: InputDecoration(labelText: 'Code de la salle'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: joinExistingSession,
              child: Text('Rejoindre la session'),
            ),
          ],
        ),
      ),
    );
  }
}
