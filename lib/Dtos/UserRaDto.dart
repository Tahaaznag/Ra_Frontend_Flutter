class UserRaDto {
  String? nom;
  String? prenom;
  String? email;
  // Ajoutez d'autres champs selon votre modèle

  UserRaDto({this.nom, this.prenom, this.email});

  factory UserRaDto.fromJson(Map<String, dynamic> json) {
    return UserRaDto(
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      // Initialisez d'autres champs
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'email': email,
      // Ajoutez d'autres champs
    };
  }
}