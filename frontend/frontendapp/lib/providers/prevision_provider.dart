import 'package:flutter/material.dart';
import '../services/prevision_service.dart';
import '../models/prevision_data.dart';

class PrevisionProvider extends ChangeNotifier {
  final PrevisionService _service = PrevisionService();

  PrevisionData? data;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchPrevision() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _service.fetchPrevision();

    if (result.success) {
      data = result.data;
    } else {
      errorMessage = result.error;
    }

    isLoading = false;
    notifyListeners();
  }
}
