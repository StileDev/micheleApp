import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import '../models/manage_user_model.dart';

class AdminProvider extends ChangeNotifier {
  final AdminService _service = AdminService();

  List<ManageUserModel> users = [];
  bool isLoading = false;
  bool isActing = false;
  String? errorMessage;

  Future<void> fetchUsers({String query = ''}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _service.fetchUsers(query: query);
    if (result.success) {
      users = result.users;
    } else {
      errorMessage = result.error;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> createUser({required String fullName, required String email, required String phone, required String password, required String role}) async {
    isActing = true;
    errorMessage = null;
    notifyListeners();

    final result = await _service.createUser(fullName: fullName, email: email, phone: phone, password: password, role: role);
    if (result.success) {
      await fetchUsers();
    } else {
      errorMessage = result.error;
    }

    isActing = false;
    notifyListeners();
    return result.success;
  }

  Future<bool> updateUser({required int id, required String fullName, required String phone, required String role, required bool isActive}) async {
    isActing = true;
    errorMessage = null;
    notifyListeners();

    final result = await _service.updateUser(id: id, fullName: fullName, phone: phone, role: role, isActive: isActive);
    if (result.success) {
      await fetchUsers();
    } else {
      errorMessage = result.error;
    }

    isActing = false;
    notifyListeners();
    return result.success;
  }

  Future<bool> deleteUser(int id) async {
    final result = await _service.deleteUser(id);
    if (result.success) {
      users = users.where((u) => u.id != id).toList();
      notifyListeners();
    }
    return result.success;
  }
}
