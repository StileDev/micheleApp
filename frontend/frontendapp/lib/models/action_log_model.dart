class ActionLogModel {
  final int id;
  final String typeAction; // "irrigation" ou "drainage"
  final String statut; // "demarrage" ou "arret"
  final DateTime createdAt;

  ActionLogModel({
    required this.id,
    required this.typeAction,
    required this.statut,
    required this.createdAt,
  });

  factory ActionLogModel.fromJson(Map<String, dynamic> json) {
    return ActionLogModel(
      id: json['id'] ?? 0,
      typeAction: json['type_action'] ?? '',
      statut: json['statut'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  bool get isIrrigation => typeAction == 'irrigation';
  bool get isDemarrage => statut == 'demarrage';
}
