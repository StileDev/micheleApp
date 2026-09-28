class MesureModel {
  final double humiditeSol;
  final double temperature;
  final double humiditeAir;
  final DateTime createdAt;

  MesureModel({
    required this.humiditeSol,
    required this.temperature,
    required this.humiditeAir,
    required this.createdAt,
  });

  factory MesureModel.fromJson(Map<String, dynamic> json) {
    return MesureModel(
      humiditeSol: (json['humidite_sol'] as num?)?.toDouble() ?? 0,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0,
      humiditeAir: (json['humidite_air'] as num?)?.toDouble() ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}