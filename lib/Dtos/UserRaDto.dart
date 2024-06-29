class UserRaDto {
  final int userId;
  final String nom;
  final String prenom;
  final String email;
  final List<String> roles;

  UserRaDto({
    required this.userId,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.roles,
  });

  factory UserRaDto.fromJson(Map<String, dynamic> json) {
    return UserRaDto(
      userId: json['userId'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      roles: json['roles'] != null ? List<String>.from(json['roles']) : [],
    );
  }
}