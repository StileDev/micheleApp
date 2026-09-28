import 'package:flutter/material.dart';
import '../services/historique_service.dart';
import '../models/action_log_model.dart';
import '../models/mesure_model.dart';

class HistoriqueProvider extends ChangeNotifier {
  final HistoriqueService _service = HistoriqueService();

  List<ActionLogModel> actions = [];
  List<MesureModel> mesures = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchHistorique(int parcelleId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _service.fetchHistorique(parcelleId);
    if (result.success) {
      actions = result.actions;
      mesures = result.mesures;
    } else {
      errorMessage = result.error;
    }

    isLoading = false;
    notifyListeners();
  }
}
