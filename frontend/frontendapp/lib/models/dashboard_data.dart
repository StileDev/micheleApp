class EtatIrrigation {
  final bool actif;
  final String mode; // "auto" ou "manuel"
  final DateTime? demarreA;
  final int? dureeMinutes;

  EtatIrrigation({
    required this.actif,
    required this.mode,
    this.demarreA,
    this.dureeMinutes,
  });

  factory EtatIrrigation.fromJson(Map<String, dynamic> json) {
    return EtatIrrigation(
      actif: json['actif'] ?? false,
      mode: json['mode'] ?? 'auto',
      demarreA: json['demarre_a'] != null ? DateTime.tryParse(json['demarre_a']) : null,
      dureeMinutes: json['duree_minutes'],
    );
  }
}

class DashboardData {
  final String parcelleNom;
  final double? humiditeSol;
  final double? temperature;
  final double? humiditeAir;
  final double? phSol;
  final DateTime? derniereMesure;
  final EtatIrrigation etatIrrigation;

  DashboardData({
    required this.parcelleNom,
    required this.humiditeSol,
    required this.temperature,
    required this.humiditeAir,
    required this.phSol,
    required this.derniereMesure,
    required this.etatIrrigation,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      parcelleNom: json['parcelle_nom'] ?? '',
      humiditeSol: (json['humidite_sol'] as num?)?.toDouble(),
      temperature: (json['temperature'] as num?)?.toDouble(),
      humiditeAir: (json['humidite_air'] as num?)?.toDouble(),
      phSol: (json['ph_sol'] as num?)?.toDouble(),
      derniereMesure: json['derniere_mesure'] != null ? DateTime.tryParse(json['derniere_mesure']) : null,
      etatIrrigation: EtatIrrigation.fromJson(json['etat_irrigation'] ?? {}),
    );
  }
}
