class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String role; // "agriculteur" ou "administrateur"

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
  });

  bool get isAdmin => role == 'administrateur';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'agriculteur',
    );
  }
}
