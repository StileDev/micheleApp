import 'materiel_model.dart';

class EtatParcelleModel {
  final bool iotConnecte;
  final bool irrigationActive;
  final DateTime? irrigationDemarreeA;
  final bool drainageActif;
  final DateTime? drainageDemarreA;

  EtatParcelleModel({
    required this.iotConnecte,
    required this.irrigationActive,
    required this.irrigationDemarreeA,
    required this.drainageActif,
    required this.drainageDemarreA,
  });

  factory EtatParcelleModel.fromJson(Map<String, dynamic> json) {
    return EtatParcelleModel(
      iotConnecte: json['iot_connecte'] ?? false,
      irrigationActive: json['irrigation_active'] ?? false,
      irrigationDemarreeA: json['irrigation_demarree_a'] != null ? DateTime.tryParse(json['irrigation_demarree_a']) : null,
      drainageActif: json['drainage_actif'] ?? false,
      drainageDemarreA: json['drainage_demarre_a'] != null ? DateTime.tryParse(json['drainage_demarre_a']) : null,
    );
  }
}

class ParcelleDetailModel {
  final int id;
  final String nom;
  final EtatParcelleModel etat;
  final double? temperature;
  final double? humiditeAir;
  final double? humiditeSol;
  final double? phSol;
  final DateTime? derniereMesure;
  final List<MaterielModel> materiels;

  ParcelleDetailModel({
    required this.id,
    required this.nom,
    required this.etat,
    required this.temperature,
    required this.humiditeAir,
    required this.humiditeSol,
    required this.phSol,
    required this.derniereMesure,
    required this.materiels,
  });

  factory ParcelleDetailModel.fromJson(Map<String, dynamic> json) {
    return ParcelleDetailModel(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      etat: EtatParcelleModel.fromJson(json['etat'] ?? {}),
      temperature: (json['temperature'] as num?)?.toDouble(),
      humiditeAir: (json['humidite_air'] as num?)?.toDouble(),
      humiditeSol: (json['humidite_sol'] as num?)?.toDouble(),
      phSol: (json['ph_sol'] as num?)?.toDouble(),
      derniereMesure: json['derniere_mesure'] != null ? DateTime.tryParse(json['derniere_mesure']) : null,
      materiels: (json['materiels'] as List<dynamic>? ?? [])
          .map((e) => MaterielModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
