import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Notifications locales simples : pas de push, pas d'historique.
/// Une alerte s'affiche quand l'irrigation automatique démarre pendant
/// que l'écran de la parcelle est ouvert.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    try {
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosInit = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const linuxInit = LinuxInitializationSettings(defaultActionName: 'Ouvrir');

      const settings = InitializationSettings(
        android: androidInit,
        iOS: iosInit,
        linux: linuxInit,
      );

      await _plugin.initialize(settings);

      // Android 13+ : permission à demander à l'exécution.
      await _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      _initialized = true;
    } catch (_) {
      // Une notification ne doit jamais empêcher l'app de démarrer.
    }
  }

  Future<void> notifier({required String titre, required String corps}) async {
    if (!_initialized) await init();
    if (!_initialized) return;

    try {
      const androidDetails = AndroidNotificationDetails(
        'irrigation_auto',
        'Irrigation automatique',
        importance: Importance.high,
        priority: Priority.high,
      );
      const iosDetails = DarwinNotificationDetails(presentAlert: true, presentSound: true);
      const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

      await _plugin.show(0, titre, corps, details);
    } catch (_) {
      // Ignoré volontairement, voir init().
    }
  }
}