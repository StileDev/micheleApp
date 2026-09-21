import 'package:flutter/material.dart';
import '../services/parcelle_service.dart';
import '../models/parcelle_model.dart';

class ParcelleListProvider extends ChangeNotifier {
  final ParcelleService _service = ParcelleService();

  List<ParcelleModel> parcelles = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchParcelles() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _service.fetchParcelles();
    if (result.success) {
      parcelles = result.parcelles;
    } else {
      errorMessage = result.error;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> creerParcelle({required String nom, double? superficie, String? culture, double? latitude, double? longitude}) async {
    final result = await _service.creerParcelle(nom: nom, superficie: superficie, culture: culture, latitude: latitude, longitude: longitude);
    if (result.success) {
      await fetchParcelles();
    } else {
      errorMessage = result.error;
      notifyListeners();
    }
    return result.success;
  }

  Future<bool> supprimerParcelle(int id) async {
    final result = await _service.supprimerParcelle(id);
    if (result.success) {
      parcelles = parcelles.where((p) => p.id != id).toList();
      notifyListeners();
    }
    return result.success;
  }
}
