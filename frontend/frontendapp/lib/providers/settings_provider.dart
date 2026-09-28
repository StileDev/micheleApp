import 'package:flutter/material.dart';
import '../services/storage_service.dart';

const String tempUnitCelsius = 'celsius';
const String tempUnitKelvin = 'kelvin';

const String langFr = 'fr';
const String langEn = 'en';

/// Préférences purement locales à l'appareil (SharedPreferences),
/// jamais envoyées ni lues depuis le serveur.
class SettingsProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();

  String language = langFr;
  String tempUnit = tempUnitCelsius;
  bool notificationsEnabled = true;

  Future<void> load() async {
    language = await _storage.getLanguage() ?? langFr;
    tempUnit = await _storage.getTempUnit() ?? tempUnitCelsius;
    notificationsEnabled = await _storage.getNotificationsEnabled() ?? true;
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    language = code;
    await _storage.setLanguage(code);
    notifyListeners();
  }

  Future<void> setTempUnit(String unit) async {
    tempUnit = unit;
    await _storage.setTempUnit(unit);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    notificationsEnabled = value;
    await _storage.setNotificationsEnabled(value);
    notifyListeners();
  }

  /// Le backend fournit toujours des degrés Celsius. Cette méthode
  /// convertit uniquement pour l'affichage, selon le choix de l'utilisateur.
  double convertTemp(double celsius) {
    if (tempUnit == tempUnitKelvin) return celsius + 273.15;
    return celsius;
  }

  String get tempSuffix => tempUnit == tempUnitKelvin ? 'K' : '°C';
}