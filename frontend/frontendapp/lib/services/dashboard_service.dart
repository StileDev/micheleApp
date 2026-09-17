import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/dashboard_data.dart';

class DashboardResult {
  final bool success;
  final DashboardData? data;
  final String? error;
  DashboardResult({required this.success, this.data, this.error});
}

class DashboardService {
  final ApiClient _client = ApiClient();

  Future<DashboardResult> fetchDashboard() async {
    try {
      final resp = await _client.dio.get('/irrigation/dashboard/');
      return DashboardResult(success: true, data: DashboardData.fromJson(resp.data));
    } on DioException catch (e) {
      return DashboardResult(success: false, error: _extractError(e));
    }
  }

  String _extractError(DioException e) {
    if (e.response?.data is Map && (e.response?.data as Map).containsKey('detail')) {
      return e.response!.data['detail'].toString();
    }
    return "Impossible de charger les données. Vérifiez votre connexion.";
  }
}
