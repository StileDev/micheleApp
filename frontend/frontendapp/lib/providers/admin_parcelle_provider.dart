import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import '../models/admin_parcelle_model.dart';

class AdminParcelleProvider extends ChangeNotifier {
  final AdminService _service = AdminService();

  List<AdminParcelleModel> parcelles = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchParcelles({String query = ''}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _service.fetchParcelles(query: query);
    if (result.success) {
      parcelles = result.parcelles;
    } else {
      errorMessage = result.error;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> deleteParcelle(int id) async {
    final result = await _service.deleteParcelle(id);
    if (result.success) {
      parcelles = parcelles.where((p) => p.id != id).toList();
      notifyListeners();
    }
    return result.success;
  }
}
