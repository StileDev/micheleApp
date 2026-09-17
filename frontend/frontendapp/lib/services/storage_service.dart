import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';
  static const _nameKey = 'user_name';
  static const _emailKey = 'user_email';
  static const _phoneKey = 'user_phone';
  static const _roleKey = 'user_role';
  static const _idKey = 'user_id';

  Future<void> saveSession({
    required String access,
    required String refresh,
    required int id,
    required String fullName,
    required String email,
    required String phone,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessKey, access);
    await prefs.setString(_refreshKey, refresh);
    await prefs.setInt(_idKey, id);
    await prefs.setString(_nameKey, fullName);
    await prefs.setString(_emailKey, email);
    await prefs.setString(_phoneKey, phone);
    await prefs.setString(_roleKey, role);
  }

  /// Sauvegarde les deux tokens après un rafraîchissement (Django renvoie
  /// un nouveau refresh token à chaque rotation).
  Future<void> saveTokens({required String access, required String refresh}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessKey, access);
    await prefs.setString(_refreshKey, refresh);
  }

  Future<String?> getAccessToken() async =>
      (await SharedPreferences.getInstance()).getString(_accessKey);

  Future<String?> getRefreshToken() async =>
      (await SharedPreferences.getInstance()).getString(_refreshKey);

  Future<int?> getUserId() async =>
      (await SharedPreferences.getInstance()).getInt(_idKey);

  Future<String?> getUserName() async =>
      (await SharedPreferences.getInstance()).getString(_nameKey);

  Future<String?> getUserEmail() async =>
      (await SharedPreferences.getInstance()).getString(_emailKey);

  Future<String?> getUserPhone() async =>
      (await SharedPreferences.getInstance()).getString(_phoneKey);

  Future<String?> getUserRole() async =>
      (await SharedPreferences.getInstance()).getString(_roleKey);

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessKey);
    await prefs.remove(_refreshKey);
    await prefs.remove(_idKey);
    await prefs.remove(_nameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_phoneKey);
    await prefs.remove(_roleKey);
  }
}
