import 'package:dio/dio.dart';
import 'api_client.dart';
import 'storage_service.dart';

class AuthResult {
  final bool success;
  final String? error;
  AuthResult({required this.success, this.error});
}

class AuthService {
  final ApiClient _client = ApiClient();
  final StorageService _storage = StorageService();

  Future<AuthResult> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final resp = await _client.dio.post('/api/auth/register/', data: {
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'password': password,
      });
      final user = resp.data['user'] as Map<String, dynamic>;
      await _storage.saveSession(
        access: resp.data['access'],
        refresh: resp.data['refresh'],
        id: user['id'] ?? 0,
        fullName: user['full_name'] ?? '',
        email: user['email'] ?? '',
        phone: user['phone'] ?? '',
        role: user['role'] ?? 'agriculteur',
      );
      return AuthResult(success: true);
    } on DioException catch (e) {
      return AuthResult(success: false, error: _extractError(e));
    }
  }

  Future<AuthResult> login({required String email, required String password}) async {
    try {
      final resp = await _client.dio.post('/api/auth/login/', data: {'email': email, 'password': password});
      final user = resp.data['user'] as Map<String, dynamic>?;

      if (user != null) {
        await _storage.saveSession(
          access: resp.data['access'],
          refresh: resp.data['refresh'],
          id: user['id'] ?? 0,
          fullName: user['full_name'] ?? '',
          email: user['email'] ?? '',
          phone: user['phone'] ?? '',
          role: user['role'] ?? 'agriculteur',
        );
      } else {
        // Compatibilité si /login/ ne renvoie pas encore l'utilisateur.
        final me = await _client.dio.get('/api/auth/me/', options: Options(headers: {'Authorization': 'Bearer ${resp.data['access']}'}));
        await _storage.saveSession(
          access: resp.data['access'],
          refresh: resp.data['refresh'],
          id: me.data['id'] ?? 0,
          fullName: me.data['full_name'] ?? '',
          email: me.data['email'] ?? '',
          phone: me.data['phone'] ?? '',
          role: me.data['role'] ?? 'agriculteur',
        );
      }
      return AuthResult(success: true);
    } on DioException catch (e) {
      return AuthResult(success: false, error: _extractError(e));
    }
  }

  Future<void> logout() async {
    final refresh = await _storage.getRefreshToken();
    try {
      if (refresh != null) {
        await _client.dio.post('/api/auth/logout/', data: {'refresh': refresh});
      }
    } catch (_) {}
    await _storage.clear();
  }

  Future<bool> isLoggedIn() async => (await _storage.getAccessToken()) != null;

  String _extractError(DioException e) {
    if (e.response?.data is Map && (e.response?.data as Map).isNotEmpty) {
      final data = e.response!.data as Map;
      final firstKey = data.keys.first;
      final val = data[firstKey];
      return val is List ? val.first.toString() : val.toString();
    }
    return "Une erreur est survenue. Vérifiez votre connexion.";
  }
}
