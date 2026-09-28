class ActionLogModel {
  final int id;
  final String statut; // "demarrage" ou "arret"
  final bool declencheeAutomatiquement;
  final DateTime createdAt;

  ActionLogModel({
    required this.id,
    required this.statut,
    required this.declencheeAutomatiquement,
    required this.createdAt,
  });

  factory ActionLogModel.fromJson(Map<String, dynamic> json) {
    return ActionLogModel(
      id: json['id'] ?? 0,
      statut: json['statut'] ?? '',
      declencheeAutomatiquement: json['declenchee_automatiquement'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  bool get isDemarrage => statut == 'demarrage';
}