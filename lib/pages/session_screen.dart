import 'package:flutter/material.dart';
import 'package:remote_assist/Dtos/SessioRaDto.dart';
import 'package:remote_assist/Service/SessionService.dart';
import 'VideoCallScreen.dart';
import 'chat_screen.dart';

class SessionManagementScreen extends StatefulWidget {
  @override
  _SessionManagementScreenState createState() => _SessionManagementScreenState();
}

class _SessionManagementScreenState extends State<SessionManagementScreen> {
  final SessionService sessionService = SessionService();
  final TextEditingController sessionNameController = TextEditingController();
  final TextEditingController roomCodeController = TextEditingController();

  DateTime? startDate;
  TimeOfDay? startTime;
  DateTime? endDate;
  TimeOfDay? endTime;

  Future<void> createNewSession() async {
    if (sessionNameController.text.isEmpty || startDate == null || startTime == null || endDate == null || endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    final startDateTime = DateTime(
      startDate!.year,
      startDate!.month,
      startDate!.day,
      startTime!.hour,
      startTime!.minute,
    );
    final endDateTime = DateTime(
      endDate!.year,
      endDate!.month,
      endDate!.day,
      endTime!.hour,
      endTime!.minute,
    );

    final newSession = SessionRaDto(
      sessionName: sessionNameController.text,
      dateDebut: startDateTime,
      dateFin: endDateTime,
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
      if (joinedSession != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideoScreen(roomCode: roomCodeController.text)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la tentative de rejoindre la session : $e')),
      );
    }
  }



  Future<void> pickStartDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          startDate = date;
          startTime = time;
        });
      }
    }
  }

  Future<void> pickEndDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          endDate = date;
          endTime = time;
        });
      }
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
              onPressed: () => pickStartDateTime(context),
              child: Text('Choisir la date et l\'heure de début'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => pickEndDateTime(context),
              child: Text('Choisir la date et l\'heure de fin'),
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
