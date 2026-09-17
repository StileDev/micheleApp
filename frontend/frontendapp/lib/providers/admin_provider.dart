import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import '../models/manage_user_model.dart';

class AdminProvider extends ChangeNotifier {
  final AdminService _service = AdminService();

  List<ManageUserModel> users = [];
  bool isLoading = false;
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

  Future<bool> deactivateUser(int id) async {
    final result = await _service.deactivateUser(id);
    if (result.success) {
      users = users.where((u) => u.id != id).toList();
      notifyListeners();
    }
    return result.success;
  }
}
