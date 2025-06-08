import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralisation des styles de texte.
/// Utilisez ces styles pour garantir la cohérence typographique dans toute l'application.
/// N'utilisez pas directement TextStyle dans les widgets, mais passez toujours par AppTextStyles.
/// Styles adaptatifs pour le light/dark mode et accessibilité.

class AppTextStyles {
  // --- DISPLAY / HEADLINES ---

  static TextStyle displayLarge(BuildContext context) => TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
        fontSize: 32,
        color: _onBackground(context),
        height: 1.2,
      );

  static TextStyle headlineLarge(BuildContext context) => TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: 24,
        color: _onBackground(context),
        height: 1.2,
      );

  static TextStyle headlineMedium(BuildContext context) => TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        fontSize: 20,
        color: _onBackground(context),
        height: 1.2,
      );

  // --- TITRES ---

  static TextStyle titleLarge(BuildContext context) => TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: _onSurface(context),
        height: 1.2,
      );

  static TextStyle titleMedium(BuildContext context) => TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: _onSurface(context),
        height: 1.2,
      );

  // --- CORPS DE TEXTE ---

  static TextStyle bodyLarge(BuildContext context) => TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        color: _onSurface(context),
        height: 1.4,
      );

  static TextStyle bodyMedium(BuildContext context) => TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,
        color: _onSurface(context),
        height: 1.4,
      );

  static TextStyle bodySmall(BuildContext context) => TextStyle(
        fontFamily: 'Roboto',
        fontSize: 12,
        color: _onSurface(context).withOpacity(0.8),
        height: 1.4,
      );

  // --- LABELS / BUTTONS ---

  static TextStyle labelLarge(BuildContext context) => TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: 13,
        color: _primary(context),
        letterSpacing: 0.2,
      );

  static TextStyle labelMedium(BuildContext context) => TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: _onSurface(context),
        letterSpacing: 0.2,
      );

  static TextStyle labelSmall(BuildContext context) => TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        fontSize: 11,
        color: _onSurface(context).withOpacity(0.7),
        letterSpacing: 0.1,
      );

  // --- CHAMPS DE FORMULAIRE ---

  static TextStyle inputLabel(BuildContext context) => TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: _primary(context),
      );

  static TextStyle inputHint(BuildContext context) => TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        fontSize: 13,
        color: _onSurface(context).withOpacity(0.5),
      );

  // --- ÉTATS / STATUS ---

  static TextStyle success(BuildContext context) => TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: AppColors.success,
      );

  static TextStyle warning(BuildContext context) => TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: AppColors.warning,
      );

  static TextStyle error(BuildContext context) => TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: AppColors.error,
      );

  static TextStyle info(BuildContext context) => TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: AppColors.info,
      );

  // --- UTILITY PRIVATE METHODS ---

  static Color _onBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? AppColors.onBackgroundDark
          : AppColors.onBackground;

  static Color _onSurface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? AppColors.onSurfaceDark
          : AppColors.onSurface;

  static Color _primary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? AppColors.primaryDark
          : AppColors.primary;
}