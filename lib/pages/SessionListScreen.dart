import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import '../Dtos/SessioRaDto.dart';

class SessionListScreen extends StatelessWidget {
  final List<SessionRaDto> sessions;

  SessionListScreen({required this.sessions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        children: [
          FixedTimeline.tileBuilder(
            builder: TimelineTileBuilder.connected(
              contentsAlign: ContentsAlign.alternating,
              itemCount: sessions.length,
              oppositeContentsBuilder: (context, index) {
                final session = sessions[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${session.dateDebut} - ${session.dateFin}',
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                );
              },
              contentsBuilder: (context, index) {
                final session = sessions[index];
                return Card(
                  color: Colors.red.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      session.sessionName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade900,
                      ),
                    ),
                  ),
                );
              },
              connectorBuilder: (context, index, type) => SolidLineConnector(
                color: Colors.red,
              ),
              indicatorBuilder: (context, index) => DotIndicator(
                color: Colors.red,
                child: Icon(
                  Icons.circle,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
