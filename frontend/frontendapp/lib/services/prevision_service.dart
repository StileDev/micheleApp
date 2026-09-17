import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/prevision_data.dart';

class PrevisionResult {
  final bool success;
  final PrevisionData? data;
  final String? error;
  PrevisionResult({required this.success, this.data, this.error});
}

class PrevisionService {
  final ApiClient _client = ApiClient();

  Future<PrevisionResult> fetchPrevision() async {
    try {
      final resp = await _client.dio.get('/irrigation/prevision/');
      return PrevisionResult(success: true, data: PrevisionData.fromJson(resp.data));
    } on DioException catch (e) {
      return PrevisionResult(success: false, error: _extractError(e));
    }
  }

  String _extractError(DioException e) {
    if (e.response?.data is Map && (e.response?.data as Map).containsKey('detail')) {
      return e.response!.data['detail'].toString();
    }
    return "Impossible de charger la prévision. Vérifiez votre connexion.";
  }
}
