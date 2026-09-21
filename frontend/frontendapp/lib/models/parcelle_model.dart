class ParcelleModel {
  final int id;
  final String nom;
  final double? superficie;
  final String culture;
  final double? latitude;
  final double? longitude;

  ParcelleModel({
    required this.id,
    required this.nom,
    required this.superficie,
    required this.culture,
    required this.latitude,
    required this.longitude,
  });

  factory ParcelleModel.fromJson(Map<String, dynamic> json) {
    return ParcelleModel(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      superficie: (json['superficie'] as num?)?.toDouble(),
      culture: json['culture'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  String get localisation {
    if (latitude == null || longitude == null) return 'Localisation non renseignée';
    return 'Latitude: ${latitude!.toStringAsFixed(3)}, Longitude: ${longitude!.toStringAsFixed(3)}';
  }
}
