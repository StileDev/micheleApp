import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/manage_user_model.dart';
import '../models/admin_parcelle_model.dart';

class AdminListResult {
  final bool success;
  final List<ManageUserModel> users;
  final String? error;
  AdminListResult({required this.success, this.users = const [], this.error});
}

class AdminParcelleListResult {
  final bool success;
  final List<AdminParcelleModel> parcelles;
  final String? error;
  AdminParcelleListResult({required this.success, this.parcelles = const [], this.error});
}

class AdminActionResult {
  final bool success;
  final String? error;
  AdminActionResult({required this.success, this.error});
}

class AdminService {
  final ApiClient _client = ApiClient();

  Future<AdminListResult> fetchUsers({String query = ''}) async {
    try {
      final resp = await _client.dio.get('/api/admin/users/', queryParameters: query.isNotEmpty ? {'search': query} : null);
      final list = (resp.data as List<dynamic>).map((e) => ManageUserModel.fromJson(e as Map<String, dynamic>)).toList();
      return AdminListResult(success: true, users: list);
    } on DioException catch (e) {
      return AdminListResult(success: false, error: _extractError(e));
    }
  }

  Future<AdminActionResult> createUser({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    try {
      await _client.dio.post('/api/admin/users/', data: {
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'password': password,
        'role': role,
      });
      return AdminActionResult(success: true);
    } on DioException catch (e) {
      return AdminActionResult(success: false, error: _extractError(e));
    }
  }

  Future<AdminActionResult> updateUser({
    required int id,
    required String fullName,
    required String phone,
    required String role,
    required bool isActive,
  }) async {
    try {
      await _client.dio.patch('/api/admin/users/$id/', data: {
        'full_name': fullName,
        'phone': phone,
        'role': role,
        'is_active': isActive,
      });
      return AdminActionResult(success: true);
    } on DioException catch (e) {
      return AdminActionResult(success: false, error: _extractError(e));
    }
  }

  Future<AdminActionResult> deleteUser(int id) async {
    try {
      await _client.dio.delete('/api/admin/users/$id/');
      return AdminActionResult(success: true);
    } on DioException catch (e) {
      return AdminActionResult(success: false, error: _extractError(e));
    }
  }

  Future<AdminParcelleListResult> fetchParcelles({String query = ''}) async {
    try {
      final resp = await _client.dio.get('/api/admin/parcelles/', queryParameters: query.isNotEmpty ? {'search': query} : null);
      final list = (resp.data as List<dynamic>).map((e) => AdminParcelleModel.fromJson(e as Map<String, dynamic>)).toList();
      return AdminParcelleListResult(success: true, parcelles: list);
    } on DioException catch (e) {
      return AdminParcelleListResult(success: false, error: _extractError(e));
    }
  }

  Future<AdminActionResult> deleteParcelle(int id) async {
    try {
      await _client.dio.delete('/api/admin/parcelles/$id/');
      return AdminActionResult(success: true);
    } on DioException catch (e) {
      return AdminActionResult(success: false, error: _extractError(e));
    }
  }

  String _extractError(DioException e) {
    if (e.response?.data is Map && (e.response?.data as Map).isNotEmpty) {
      final data = e.response!.data as Map;
      if (data.containsKey('detail')) return data['detail'].toString();
      final firstKey = data.keys.first;
      final val = data[firstKey];
      return val is List ? val.first.toString() : val.toString();
    }
    return "Action impossible. Vérifiez votre connexion.";
  }
}
