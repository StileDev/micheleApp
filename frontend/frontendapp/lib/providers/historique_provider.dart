import 'package:flutter/material.dart';
import '../services/historique_service.dart';
import '../models/action_log_model.dart';

class HistoriqueProvider extends ChangeNotifier {
  final HistoriqueService _service = HistoriqueService();

  List<ActionLogModel> actions = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchHistorique(int parcelleId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _service.fetchHistorique(parcelleId);
    if (result.success) {
      actions = result.actions;
    } else {
      errorMessage = result.error;
    }

    isLoading = false;
    notifyListeners();
  }
}
