import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Acme est réservé aux titres courts (une seule graisse disponible,
/// peu adaptée à un texte long). Le reste de l'interface utilise la
/// police système pour rester lisible et sobre.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle title({double size = 20, Color color = AppColors.text}) {
    return GoogleFonts.acme(fontSize: size, color: color, height: 1.2);
  }

  static const TextStyle heading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.text,
  );

  static const TextStyle bodyMuted = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.muted,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
}
