import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/dashboard_data.dart';

class IrrigationResult {
  final bool success;
  final EtatIrrigation? etat;
  final String? error;
  IrrigationResult({required this.success, this.etat, this.error});
}

class IrrigationService {
  final ApiClient _client = ApiClient();

  Future<IrrigationResult> fetchEtat() async {
    try {
      final resp = await _client.dio.get('/irrigation/etat/');
      return IrrigationResult(success: true, etat: EtatIrrigation.fromJson(resp.data));
    } on DioException catch (e) {
      return IrrigationResult(success: false, error: _extractError(e));
    }
  }

  Future<IrrigationResult> setMode(String mode) async {
    try {
      final resp = await _client.dio.post('/irrigation/mode/', data: {'mode': mode});
      return IrrigationResult(success: true, etat: EtatIrrigation.fromJson(resp.data));
    } on DioException catch (e) {
      return IrrigationResult(success: false, error: _extractError(e));
    }
  }

  Future<IrrigationResult> toggleAuto(bool actif) async {
    try {
      final resp = await _client.dio.post('/irrigation/auto/toggle/', data: {'actif': actif});
      return IrrigationResult(success: true, etat: EtatIrrigation.fromJson(resp.data));
    } on DioException catch (e) {
      return IrrigationResult(success: false, error: _extractError(e));
    }
  }

  Future<IrrigationResult> declencher({required int dureeMinutes}) async {
    try {
      final resp = await _client.dio.post('/irrigation/declencher/', data: {
        'duree_minutes': dureeMinutes,
      });
      return IrrigationResult(success: true, etat: EtatIrrigation.fromJson(resp.data));
    } on DioException catch (e) {
      return IrrigationResult(success: false, error: _extractError(e));
    }
  }

  Future<IrrigationResult> arreter() async {
    try {
      final resp = await _client.dio.post('/irrigation/arreter/');
      return IrrigationResult(success: true, etat: EtatIrrigation.fromJson(resp.data));
    } on DioException catch (e) {
      return IrrigationResult(success: false, error: _extractError(e));
    }
  }

  String _extractError(DioException e) {
    if (e.response?.data is Map && (e.response?.data as Map).containsKey('detail')) {
      return e.response!.data['detail'].toString();
    }
    return "Action impossible. Vérifiez votre connexion.";
  }
}
