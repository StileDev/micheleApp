import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/parcelle_detail_model.dart';

class ParcelleDetailResult {
  final bool success;
  final ParcelleDetailModel? data;
  final String? error;
  ParcelleDetailResult({required this.success, this.data, this.error});
}

class SimpleActionResult {
  final bool success;
  final String? error;
  SimpleActionResult({required this.success, this.error});
}

class ParcelleDetailService {
  final ApiClient _client = ApiClient();

  Future<ParcelleDetailResult> fetchDetail(int parcelleId) async {
    try {
      final resp = await _client.dio.get('/irrigation/parcelles/$parcelleId/detail/');
      return ParcelleDetailResult(success: true, data: ParcelleDetailModel.fromJson(resp.data));
    } on DioException catch (e) {
      return ParcelleDetailResult(success: false, error: _extractError(e));
    }
  }

  Future<SimpleActionResult> ajouterMateriel(int parcelleId, String nom) async {
    try {
      await _client.dio.post('/irrigation/parcelles/$parcelleId/materiels/', data: {'nom': nom});
      return SimpleActionResult(success: true);
    } on DioException catch (e) {
      return SimpleActionResult(success: false, error: _extractError(e));
    }
  }

  Future<SimpleActionResult> supprimerMateriel(int parcelleId, int materielId) async {
    try {
      await _client.dio.delete('/irrigation/parcelles/$parcelleId/materiels/$materielId/');
      return SimpleActionResult(success: true);
    } on DioException catch (e) {
      return SimpleActionResult(success: false, error: _extractError(e));
    }
  }

  Future<SimpleActionResult> demarrerIrrigation(int parcelleId) => _post('/irrigation/parcelles/$parcelleId/irrigation/demarrer/');
  Future<SimpleActionResult> arreterIrrigation(int parcelleId) => _post('/irrigation/parcelles/$parcelleId/irrigation/arreter/');
  Future<SimpleActionResult> demarrerDrainage(int parcelleId) => _post('/irrigation/parcelles/$parcelleId/drainage/demarrer/');
  Future<SimpleActionResult> arreterDrainage(int parcelleId) => _post('/irrigation/parcelles/$parcelleId/drainage/arreter/');

  Future<SimpleActionResult> _post(String path) async {
    try {
      await _client.dio.post(path);
      return SimpleActionResult(success: true);
    } on DioException catch (e) {
      return SimpleActionResult(success: false, error: _extractError(e));
    }
  }

  String _extractError(DioException e) {
    if (e.response?.data is Map && (e.response?.data as Map).containsKey('detail')) {
      return e.response!.data['detail'].toString();
    }
    return "Action impossible. Vérifiez votre connexion.";
  }
}
