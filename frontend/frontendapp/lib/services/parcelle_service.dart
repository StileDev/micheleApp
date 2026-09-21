import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/parcelle_model.dart';

class ParcelleListResult {
  final bool success;
  final List<ParcelleModel> parcelles;
  final String? error;
  ParcelleListResult({required this.success, this.parcelles = const [], this.error});
}

class ParcelleActionResult {
  final bool success;
  final String? error;
  ParcelleActionResult({required this.success, this.error});
}

class ParcelleService {
  final ApiClient _client = ApiClient();

  Future<ParcelleListResult> fetchParcelles() async {
    try {
      final resp = await _client.dio.get('/irrigation/parcelles/');
      final list = (resp.data as List<dynamic>).map((e) => ParcelleModel.fromJson(e as Map<String, dynamic>)).toList();
      return ParcelleListResult(success: true, parcelles: list);
    } on DioException catch (e) {
      return ParcelleListResult(success: false, error: _extractError(e));
    }
  }

  Future<ParcelleActionResult> creerParcelle({
    required String nom,
    double? superficie,
    String? culture,
    double? latitude,
    double? longitude,
  }) async {
    try {
      await _client.dio.post('/irrigation/parcelles/', data: {
        'nom': nom,
        'superficie': superficie,
        'culture': culture ?? '',
        'latitude': latitude,
        'longitude': longitude,
      });
      return ParcelleActionResult(success: true);
    } on DioException catch (e) {
      return ParcelleActionResult(success: false, error: _extractError(e));
    }
  }

  Future<ParcelleActionResult> supprimerParcelle(int id) async {
    try {
      await _client.dio.delete('/irrigation/parcelles/$id/');
      return ParcelleActionResult(success: true);
    } on DioException catch (e) {
      return ParcelleActionResult(success: false, error: _extractError(e));
    }
  }

  String _extractError(DioException e) {
    if (e.response?.data is Map && (e.response?.data as Map).containsKey('detail')) {
      return e.response!.data['detail'].toString();
    }
    return "Action impossible. Vérifiez votre connexion.";
  }
}
