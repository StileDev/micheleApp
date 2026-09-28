import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MaterielVisual {
  final IconData icon;
  final Color color;
  final Color background;

  const MaterielVisual({required this.icon, required this.color, required this.background});
}

/// Les matériels sont ajoutés en texte libre par l'agriculteur (ex:
/// "Capteur Humidité", "ESP32", "Capteur PIR"...). On associe une icône
/// et une couleur selon des mots-clés reconnus dans le nom, pour retrouver
/// la variété visuelle des captures de référence (chaque type de capteur
/// a sa propre couleur/icône), sans dépendre d'un catalogue figé.
MaterielVisual materielVisual(String nom) {
  final n = nom.toLowerCase();

  if (n.contains('humid')) {
    return const MaterielVisual(icon: Icons.water_drop, color: AppColors.greenDark, background: AppColors.greenSoft);
  }
  if (n.contains('temp')) {
    return const MaterielVisual(icon: Icons.thermostat, color: AppColors.danger, background: AppColors.dangerSoft);
  }
  if (n.contains('pir') || n.contains('mouvement') || n.contains('présence') || n.contains('presence')) {
    return const MaterielVisual(icon: Icons.directions_walk, color: AppColors.warning, background: AppColors.warningSoft);
  }
  if (n.contains('esp') || n.contains('processeur') || n.contains('carte') || n.contains('microcontrôleur') || n.contains('microcontroleur')) {
    return const MaterielVisual(icon: Icons.memory, color: AppColors.blueDark, background: AppColors.blueSoft);
  }
  if (n.contains('ph')) {
    return const MaterielVisual(icon: Icons.science_outlined, color: AppColors.warning, background: AppColors.warningSoft);
  }
  if (n.contains('lumière') || n.contains('lumiere') || n.contains('luminosité') || n.contains('luminosite')) {
    return const MaterielVisual(icon: Icons.wb_sunny_outlined, color: AppColors.warning, background: AppColors.warningSoft);
  }
  if (n.contains('pompe')) {
    return const MaterielVisual(icon: Icons.water, color: AppColors.blueDark, background: AppColors.blueSoft);
  }
  if (n.contains('wifi') || n.contains('réseau') || n.contains('reseau')) {
    return const MaterielVisual(icon: Icons.wifi, color: AppColors.blueDark, background: AppColors.blueSoft);
  }

  return const MaterielVisual(icon: Icons.sensors, color: AppColors.blueDark, background: AppColors.blueSoft);
}
