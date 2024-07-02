class SessionRaDto {
  final int? sessionId;
  final String sessionName;
  final DateTime dateDebut;
  final DateTime dateFin;
  final int userId;
  final String? roomCode;

  SessionRaDto({
    this.sessionId,
    required this.sessionName,
    required this.dateDebut,
    required this.dateFin,
    required this.userId,
    this.roomCode,
  });

  factory SessionRaDto.fromJson(Map<String, dynamic> json) {
    return SessionRaDto(
      sessionId: json['sessionId'],
      sessionName: json['sessionName'],
      dateDebut: DateTime.parse(json['dateDebut']),
      dateFin: DateTime.parse(json['dateFin']),
      userId: json['userId'],
      roomCode: json['roomCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'sessionName': sessionName,
      'dateDebut': dateDebut.toIso8601String(),
      'dateFin': dateFin.toIso8601String(),
      'userId': userId,
      'roomCode': roomCode,
    };
  }
}