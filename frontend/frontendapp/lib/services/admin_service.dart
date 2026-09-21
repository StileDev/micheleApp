import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/manage_user_model.dart';

class AdminListResult {
  final bool success;
  final List<ManageUserModel> users;
  final String? error;
  AdminListResult({required this.success, this.users = const [], this.error});
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

  Future<AdminActionResult> deactivateUser(int id) async {
    try {
      await _client.dio.delete('/api/admin/users/$id/');
      return AdminActionResult(success: true);
    } on DioException catch (e) {
      return AdminActionResult(success: false, error: _extractError(e));
    }
  }

  String _extractError(DioException e) {
    if (e.response?.data is Map && (e.response?.data as Map).containsKey('detail')) {
      return e.response!.data['detail'].toString();
    }
    return "Action impossible. Vérifiez votre connexion.";
  }
}
