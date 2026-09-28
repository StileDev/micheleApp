import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/action_log_model.dart';
import '../models/mesure_model.dart';

class HistoriqueResult {
  final bool success;
  final List<ActionLogModel> actions;
  final List<MesureModel> mesures;
  final String? error;
  HistoriqueResult({required this.success, this.actions = const [], this.mesures = const [], this.error});
}

class HistoriqueService {
  final ApiClient _client = ApiClient();

  Future<HistoriqueResult> fetchHistorique(int parcelleId) async {
    try {
      final resp = await _client.dio.get('/irrigation/parcelles/$parcelleId/historique/');
      final actions = (resp.data['actions'] as List<dynamic>).map((e) => ActionLogModel.fromJson(e as Map<String, dynamic>)).toList();
      final mesures = (resp.data['mesures'] as List<dynamic>).map((e) => MesureModel.fromJson(e as Map<String, dynamic>)).toList();
      return HistoriqueResult(success: true, actions: actions, mesures: mesures);
    } on DioException catch (e) {
      return HistoriqueResult(success: false, error: _extractError(e));
    }
  }

  String _extractError(DioException e) {
    if (e.response?.data is Map && (e.response?.data as Map).containsKey('detail')) {
      return e.response!.data['detail'].toString();
    }
    return "Impossible de charger l'historique.";
  }
}
