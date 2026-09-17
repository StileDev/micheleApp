import 'package:flutter/material.dart';

/// Palette de couleurs de l'application, basée sur trois teintes
/// principales : vert (végétal, croissance), bleu (eau, capteurs)
/// et blanc (fond, lisibilité). Aucune couleur n'est utilisée en
/// dégradé : chaque surface reste unie.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFFF5F9F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFEFF5F2);

  static const Color line = Color(0xFFE1E9E5);
  static const Color lineStrong = Color(0xFFCBD9D2);

  static const Color green = Color(0xFF2E9E4F);
  static const Color greenDark = Color(0xFF1E7A3C);
  static const Color greenSoft = Color(0xFFE2F4E6);

  static const Color blue = Color(0xFF2D7DD2);
  static const Color blueDark = Color(0xFF1F5FA8);
  static const Color blueSoft = Color(0xFFE3EEFB);

  static const Color text = Color(0xFF1C2B26);
  static const Color textSecondary = Color(0xFF54655F);
  static const Color muted = Color(0xFF8A9A93);

  static const Color danger = Color(0xFFC24B3F);
  static const Color dangerSoft = Color(0xFFF6E4E1);
  static const Color warning = Color(0xFFC98A2E);
  static const Color warningSoft = Color(0xFFF6ECDD);
}
