import 'materiel_model.dart';

class EtatParcelleModel {
  final bool iotConnecte;
  final String irrigationMode; // "auto" ou "manuel"
  final bool irrigationActive;
  final DateTime? irrigationDemarreeA;

  EtatParcelleModel({
    required this.iotConnecte,
    required this.irrigationMode,
    required this.irrigationActive,
    required this.irrigationDemarreeA,
  });

  factory EtatParcelleModel.fromJson(Map<String, dynamic> json) {
    return EtatParcelleModel(
      iotConnecte: json['iot_connecte'] ?? false,
      irrigationMode: json['irrigation_mode'] ?? 'manuel',
      irrigationActive: json['irrigation_active'] ?? false,
      irrigationDemarreeA: json['irrigation_demarree_a'] != null
          ? DateTime.tryParse(json['irrigation_demarree_a'])
          : null,
    );
  }
}

class ParcelleDetailModel {
  final int id;
  final String nom;
  final String deviceKey;
  final EtatParcelleModel etat;
  final double? temperature;
  final double? humiditeAir;
  final double? humiditeSol;
  final DateTime? derniereMesure;
  final List<MaterielModel> materiels;

  ParcelleDetailModel({
    required this.id,
    required this.nom,
    required this.deviceKey,
    required this.etat,
    required this.temperature,
    required this.humiditeAir,
    required this.humiditeSol,
    required this.derniereMesure,
    required this.materiels,
  });

  factory ParcelleDetailModel.fromJson(Map<String, dynamic> json) {
    return ParcelleDetailModel(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      deviceKey: json['device_key'] ?? '',
      etat: EtatParcelleModel.fromJson(json['etat'] ?? {}),
      temperature: (json['temperature'] as num?)?.toDouble(),
      humiditeAir: (json['humidite_air'] as num?)?.toDouble(),
      humiditeSol: (json['humidite_sol'] as num?)?.toDouble(),
      derniereMesure: json['derniere_mesure'] != null ? DateTime.tryParse(json['derniere_mesure']) : null,
      materiels: (json['materiels'] as List<dynamic>? ?? [])
          .map((e) => MaterielModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Fusionne une mesure + un état reçus en temps réel (WebSocket).
  ParcelleDetailModel withTempsReel(Map<String, dynamic> json) {
    return ParcelleDetailModel(
      id: id,
      nom: nom,
      deviceKey: deviceKey,
      etat: json['etat'] != null ? EtatParcelleModel.fromJson(json['etat']) : etat,
      temperature: (json['temperature'] as num?)?.toDouble() ?? temperature,
      humiditeAir: (json['humidite_air'] as num?)?.toDouble() ?? humiditeAir,
      humiditeSol: (json['humidite_sol'] as num?)?.toDouble() ?? humiditeSol,
      derniereMesure: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? derniereMesure
          : derniereMesure,
      materiels: materiels,
    );
  }
}