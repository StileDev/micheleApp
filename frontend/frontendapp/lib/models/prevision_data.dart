class RaisonPrevision {
  final String titre;
  final String detail;

  RaisonPrevision({required this.titre, required this.detail});

  factory RaisonPrevision.fromJson(Map<String, dynamic> json) {
    return RaisonPrevision(
      titre: json['titre'] ?? '',
      detail: json['detail'] ?? '',
    );
  }
}

class PointPrevision {
  final String label;
  final double valeur;

  PointPrevision({required this.label, required this.valeur});

  factory PointPrevision.fromJson(Map<String, dynamic> json) {
    return PointPrevision(
      label: json['label'] ?? '',
      valeur: (json['valeur'] as num?)?.toDouble() ?? 0,
    );
  }
}

class PrevisionData {
  final bool besoinEau;
  final String message;
  final List<RaisonPrevision> raisons;
  final List<PointPrevision> courbe;

  PrevisionData({
    required this.besoinEau,
    required this.message,
    required this.raisons,
    required this.courbe,
  });

  factory PrevisionData.fromJson(Map<String, dynamic> json) {
    return PrevisionData(
      besoinEau: json['besoin_eau'] ?? false,
      message: json['message'] ?? '',
      raisons: (json['raisons'] as List<dynamic>? ?? [])
          .map((e) => RaisonPrevision.fromJson(e as Map<String, dynamic>))
          .toList(),
      courbe: (json['courbe'] as List<dynamic>? ?? [])
          .map((e) => PointPrevision.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
