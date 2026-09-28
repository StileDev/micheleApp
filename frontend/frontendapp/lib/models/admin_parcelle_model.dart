class AdminParcelleModel {
  final int id;
  final String nom;
  final double? superficie;
  final String culture;
  final String proprietaireNom;
  final String proprietaireEmail;

  AdminParcelleModel({
    required this.id,
    required this.nom,
    required this.superficie,
    required this.culture,
    required this.proprietaireNom,
    required this.proprietaireEmail,
  });

  factory AdminParcelleModel.fromJson(Map<String, dynamic> json) {
    return AdminParcelleModel(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      superficie: (json['superficie'] as num?)?.toDouble(),
      culture: json['culture'] ?? '',
      proprietaireNom: json['proprietaire_nom'] ?? '',
      proprietaireEmail: json['proprietaire_email'] ?? '',
    );
  }
}
