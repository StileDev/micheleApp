import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final StorageService _storage = StorageService();

  AuthStatus status = AuthStatus.unknown;
  bool isLoading = false;
  String? errorMessage;

  int? userId;
  String? userName;
  String? userEmail;
  String? userPhone;
  String? userRole;

  bool get isAdmin => userRole == 'administrateur';

  Future<void> checkSession() async {
    final loggedIn = await _authService.isLoggedIn();
    if (loggedIn) {
      await _loadFromStorage();
      status = AuthStatus.authenticated;
    } else {
      status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> _loadFromStorage() async {
    userId = await _storage.getUserId();
    userName = await _storage.getUserName();
    userEmail = await _storage.getUserEmail();
    userPhone = await _storage.getUserPhone();
    userRole = await _storage.getUserRole();
  }

  Future<bool> login({required String email, required String password}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _authService.login(email: email, password: password);
    if (result.success) {
      await _loadFromStorage();
      status = AuthStatus.authenticated;
    } else {
      errorMessage = result.error;
    }

    isLoading = false;
    notifyListeners();
    return result.success;
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _authService.register(fullName: fullName, email: email, phone: phone, password: password);
    if (result.success) {
      await _loadFromStorage();
      status = AuthStatus.authenticated;
    } else {
      errorMessage = result.error;
    }

    isLoading = false;
    notifyListeners();
    return result.success;
  }

  Future<void> logout() async {
    await _authService.logout();
    _reset();
    notifyListeners();
  }

  Future<void> forceLogout() async {
    await _storage.clear();
    _reset();
    notifyListeners();
  }

  void _reset() {
    userId = null;
    userName = null;
    userEmail = null;
    userPhone = null;
    userRole = null;
    status = AuthStatus.unauthenticated;
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
