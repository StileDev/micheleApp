class MaterielModel {
  final int id;
  final String nom;

  MaterielModel({required this.id, required this.nom});

  factory MaterielModel.fromJson(Map<String, dynamic> json) {
    return MaterielModel(id: json['id'] ?? 0, nom: json['nom'] ?? '');
  }
}
