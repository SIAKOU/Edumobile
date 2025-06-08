/// dialog_utils.dart
/// Helpers centralisés pour l’affichage de dialogues dans l’application.
/// Facilite la gestion des dialogs personnalisés, confirm, alert, loading, etc.
/// Utilise toujours ces helpers pour garantir la cohérence et la maintenabilité.
library;

import 'package:flutter/material.dart';

class DialogUtils {
  /// Affiche un simple dialog d’information
  static Future<void> showInfoDialog(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onDismissed,
  }) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (onDismissed != null) onDismissed();
            },
            child: Text(buttonText ?? 'OK'),
          ),
        ],
      ),
    );
  }

  /// Affiche un dialog de confirmation (retourne true/false)
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String cancelText = 'Annuler',
    String confirmText = 'Confirmer',
    Color? confirmColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            style: confirmColor != null
                ? ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(confirmColor),
                  )
                : null,
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Affiche une boîte de dialogue personnalisée (Widget)
  static Future<T?> showCustomDialog<T>(
    BuildContext context, {
    required Widget child,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (ctx) => child,
    );
  }

  /// Affiche un dialog de chargement (avec CircularProgressIndicator)
  static Future<void> showLoadingDialog(
    BuildContext context, {
    String? message = 'Chargement...',
    bool barrierDismissible = false,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) => WillPopScope(
        onWillPop: () async => barrierDismissible,
        child: AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Flexible(child: Text(message ?? 'Chargement...')),
            ],
          ),
        ),
      ),
    );
  }

  /// Ferme le dernier dialog ouvert (utile pour loading/alert)
  static void closeDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}