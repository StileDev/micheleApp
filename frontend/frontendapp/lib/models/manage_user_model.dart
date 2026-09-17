class ManageUserModel {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final bool isActive;

  ManageUserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.isActive,
  });

  factory ManageUserModel.fromJson(Map<String, dynamic> json) {
    return ManageUserModel(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'agriculteur',
      isActive: json['is_active'] ?? true,
    );
  }
}
