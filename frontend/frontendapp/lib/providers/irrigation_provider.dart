import 'package:flutter/material.dart';
import '../services/irrigation_service.dart';
import '../models/dashboard_data.dart';

class IrrigationProvider extends ChangeNotifier {
  final IrrigationService _service = IrrigationService();

  EtatIrrigation? etat;
  bool isLoading = false;
  bool isActing = false;
  String? errorMessage;

  Future<void> fetchEtat() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _service.fetchEtat();

    if (result.success) {
      etat = result.etat;
    } else {
      errorMessage = result.error;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> setMode(String mode) async {
    isActing = true;
    notifyListeners();

    final result = await _service.setMode(mode);
    if (result.success) {
      etat = result.etat;
    } else {
      errorMessage = result.error;
    }

    isActing = false;
    notifyListeners();
  }

  Future<void> toggleAuto(bool actif) async {
    isActing = true;
    notifyListeners();

    final result = await _service.toggleAuto(actif);
    if (result.success) {
      etat = result.etat;
    } else {
      errorMessage = result.error;
    }

    isActing = false;
    notifyListeners();
  }

  Future<bool> declencher({required int dureeMinutes}) async {
    isActing = true;
    notifyListeners();

    final result = await _service.declencher(dureeMinutes: dureeMinutes);
    if (result.success) {
      etat = result.etat;
    } else {
      errorMessage = result.error;
    }

    isActing = false;
    notifyListeners();
    return result.success;
  }

  Future<bool> arreter() async {
    isActing = true;
    notifyListeners();

    final result = await _service.arreter();
    if (result.success) {
      etat = result.etat;
    } else {
      errorMessage = result.error;
    }

    isActing = false;
    notifyListeners();
    return result.success;
  }
}
