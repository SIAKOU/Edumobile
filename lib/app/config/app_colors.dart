import 'package:flutter/material.dart';

/// Palette de couleurs centralisée pour toute l'application.
/// Utilisez toujours ces constantes, jamais de couleurs "magiques" dans le code !
/// Pour une cohérence et une maintenance facilitée.

class AppColors {
  // --- Light Theme Colors ---
  static const Color primary = Color(0xFF2E3192); // Bleu éducatif
  static const Color secondary = Color(0xFF6C63FF); // Violet moderne
  static const Color accent = Color(0xFFFFB300); // Jaune accent
  static const Color background = Color(0xFFF5F6FA); // Fond très clair
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFEB5757);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFF2E3192);
  static const Color onBackground = Color(0xFF222B45);
  static const Color onSurface = Color(0xFF222B45);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color inputFill = Color(0xFFF1F3F6);

  static const Color grey = Color(0xFFBDBDBD);
  static const Color greyLight = Color(0xFFF0F0F0);

  // --- Dark Theme Colors ---
  static const Color primaryDark = Color(0xFF23255A);
  static const Color secondaryDark = Color(0xFF6C63FF);
  static const Color accentDark = Color(0xFFFFB300);
  static const Color backgroundDark = Color(0xFF181A20);
  static const Color surfaceDark = Color(0xFF23262B);
  static const Color errorDark = Color(0xFFFF5A5F);
  static const Color onPrimaryDark = Color(0xFFF5F6FA);
  static const Color onSecondaryDark = Color(0xFFF5F6FA);
  static const Color onBackgroundDark = Color(0xFFF6F6F7);
  static const Color onSurfaceDark = Color(0xFFF6F6F7);
  static const Color onErrorDark = Color(0xFF181A20);
  static const Color inputFillDark = Color(0xFF23262B);

  static const Color greyDark = Color(0xFF44474F);

  // --- Accent/Status ---
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA000);
  static const Color info = Color(0xFF1976D2);

  // --- Dégradés (Material 3) ---
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2E3192), Color(0xFF6C63FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- Custom (si besoin) ---
  // static const Color customAccent = Color(0xFF....);
}