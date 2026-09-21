import 'package:flutter/material.dart';
import '../services/parcelle_detail_service.dart';
import '../models/parcelle_detail_model.dart';

class ParcelleDetailProvider extends ChangeNotifier {
  final ParcelleDetailService _service = ParcelleDetailService();

  ParcelleDetailModel? data;
  bool isLoading = false;
  bool isActing = false;
  String? errorMessage;

  Future<void> fetchDetail(int parcelleId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _service.fetchDetail(parcelleId);
    if (result.success) {
      data = result.data;
    } else {
      errorMessage = result.error;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> ajouterMateriel(int parcelleId, String nom) async {
    isActing = true;
    notifyListeners();
    final result = await _service.ajouterMateriel(parcelleId, nom);
    if (result.success) {
      await fetchDetail(parcelleId);
    } else {
      errorMessage = result.error;
      isActing = false;
      notifyListeners();
    }
  }

  Future<void> supprimerMateriel(int parcelleId, int materielId) async {
    final result = await _service.supprimerMateriel(parcelleId, materielId);
    if (result.success) {
      await fetchDetail(parcelleId);
    }
  }

  Future<void> toggleIrrigation(int parcelleId) async {
    if (data == null) return;
    isActing = true;
    notifyListeners();

    final result = data!.etat.irrigationActive
        ? await _service.arreterIrrigation(parcelleId)
        : await _service.demarrerIrrigation(parcelleId);

    if (result.success) {
      await fetchDetail(parcelleId);
    } else {
      errorMessage = result.error;
      isActing = false;
      notifyListeners();
    }
  }

  Future<void> toggleDrainage(int parcelleId) async {
    if (data == null) return;
    isActing = true;
    notifyListeners();

    final result = data!.etat.drainageActif
        ? await _service.arreterDrainage(parcelleId)
        : await _service.demarrerDrainage(parcelleId);

    if (result.success) {
      await fetchDetail(parcelleId);
    } else {
      errorMessage = result.error;
      isActing = false;
      notifyListeners();
    }
  }
}
