/// snackbar_utils.dart
/// Helpers centralisés pour afficher des Snackbars dans l'application.
/// Utilisez toujours ces helpers pour garantir une cohérence d’affichage et faciliter la maintenance.
library;

import 'package:flutter/material.dart';

class SnackbarUtils {
  /// Affiche un simple snackbar avec un [message]
  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    Color? backgroundColor,
    SnackBarAction? action,
  }) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: duration,
      backgroundColor: backgroundColor,
      action: action,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Affiche un snackbar de succès (vert)
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    show(
      context,
      message: message,
      duration: duration,
      backgroundColor: Colors.green.shade600,
    );
  }

  /// Affiche un snackbar d’erreur (rouge)
  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      duration: duration,
      backgroundColor: Colors.red.shade700,
    );
  }

  /// Affiche un snackbar d’information (bleu)
  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    show(
      context,
      message: message,
      duration: duration,
      backgroundColor: Colors.blue.shade600,
    );
  }

  /// Ferme le snackbar courant (si besoin)
  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}