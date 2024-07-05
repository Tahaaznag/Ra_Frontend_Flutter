class SessionRaDto {
  int? sessionId;
  String sessionName;
  DateTime dateDebut;
  DateTime dateFin;
  String? roomCode;

  SessionRaDto({
    this.sessionId,
    required this.sessionName,
    required this.dateDebut,
    required this.dateFin,
    this.roomCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'sessionName': sessionName,
      'dateDebut': dateDebut.toIso8601String(),
      'dateFin': dateFin.toIso8601String(),
      'roomCode': roomCode,
    };
  }

  factory SessionRaDto.fromJson(Map<String, dynamic> json) {
    return SessionRaDto(
      sessionId: json['sessionId'],
      sessionName: json['sessionName'],
      dateDebut: DateTime.parse(json['dateDebut']),
      dateFin: DateTime.parse(json['dateFin']),
      roomCode: json['roomCode'],
    );
  }
}
