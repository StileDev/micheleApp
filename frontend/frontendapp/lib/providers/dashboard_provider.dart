import 'package:flutter/material.dart';
import '../services/dashboard_service.dart';
import '../models/dashboard_data.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardService _service = DashboardService();

  DashboardData? data;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchDashboard() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _service.fetchDashboard();

    if (result.success) {
      data = result.data;
    } else {
      errorMessage = result.error;
    }

    isLoading = false;
    notifyListeners();
  }
}
