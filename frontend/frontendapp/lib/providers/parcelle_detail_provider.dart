import 'package:flutter/material.dart';
import '../services/parcelle_detail_service.dart';
import '../services/realtime_service.dart';
import '../services/notification_service.dart';
import '../models/parcelle_detail_model.dart';

class ParcelleDetailProvider extends ChangeNotifier {
  final ParcelleDetailService _service = ParcelleDetailService();
  final RealtimeService _realtime = RealtimeService();
  final NotificationService _notifications = NotificationService();

  ParcelleDetailModel? data;
  bool isLoading = false;
  bool isActing = false;
  String? errorMessage;

  // Renseignés par l'écran avant l'ouverture du WebSocket.
  bool notificationsEnabled = true;
  String notificationTitle = '';
  String notificationBody = '';

  /// À appeler à l'ouverture de l'écran, pour ne pas afficher un instant
  /// les données de la parcelle consultée précédemment.
  void clear() {
    data = null;
    errorMessage = null;
    isLoading = true;
  }

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

  /// Ouvre le WebSocket et détecte la transition "l'irrigation automatique
  /// vient de démarrer" pour déclencher une notification locale.
  void connectRealtime(int parcelleId) {
    _realtime.disconnect();
    _realtime.connect(parcelleId, (json) {
      if (data == null) return;

      final etaitActive = data!.etat.irrigationActive;
      final etaitAuto = data!.etat.irrigationMode == 'auto';

      data = data!.withTempsReel(json);
      notifyListeners();

      final estMaintenantActive = data!.etat.irrigationActive;
      final estMaintenantAuto = data!.etat.irrigationMode == 'auto';

      final vientDeDemarrerAutomatiquement =
          estMaintenantAuto && estMaintenantActive && !(etaitActive && etaitAuto);

      if (vientDeDemarrerAutomatiquement && notificationsEnabled) {
        _notifications.notifier(titre: notificationTitle, corps: notificationBody);
      }
    });
  }

  void disconnectRealtime() {
    _realtime.disconnect();
  }

  /// isActing est TOUJOURS remis à false à la fin, succès ou échec.
  Future<void> _runAction(int parcelleId, Future<SimpleActionResult> Function() action) async {
    isActing = true;
    errorMessage = null;
    notifyListeners();

    final result = await action();

    if (result.success) {
      await fetchDetail(parcelleId);
    } else {
      errorMessage = result.error;
    }

    isActing = false;
    notifyListeners();
  }

  Future<void> ajouterMateriel(int parcelleId, String nom) =>
      _runAction(parcelleId, () => _service.ajouterMateriel(parcelleId, nom));

  Future<void> supprimerMateriel(int parcelleId, int materielId) async {
    final result = await _service.supprimerMateriel(parcelleId, materielId);
    if (result.success) {
      await fetchDetail(parcelleId);
    }
  }

  Future<void> setIrrigationMode(int parcelleId, String mode) =>
      _runAction(parcelleId, () => _service.setIrrigationMode(parcelleId, mode));

  Future<void> toggleIrrigationManuel(int parcelleId) {
    if (data == null) return Future.value();
    final action = data!.etat.irrigationActive
        ? () => _service.arreterIrrigation(parcelleId)
        : () => _service.demarrerIrrigation(parcelleId);
    return _runAction(parcelleId, action);
  }

  @override
  void dispose() {
    _realtime.disconnect();
    super.dispose();
  }
}