/// retry_button.dart
/// Bouton réutilisable pour relancer une action en cas d'échec (erreur réseau, chargement, etc.).
/// Affiche un message d'erreur optionnel et un bouton d'action.
/// Peut être utilisé à la place d'un simple [ElevatedButton] pour offrir une UX cohérente.
library;

import 'package:flutter/material.dart';

class RetryButton extends StatelessWidget {
  final VoidCallback onRetry;
  final String? errorMessage;
  final String buttonLabel;
  final IconData icon;
  final Color? color;
  final Color? textColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const RetryButton({
    Key? key,
    required this.onRetry,
    this.errorMessage,
    this.buttonLabel = 'Réessayer',
    this.icon = Icons.refresh,
    this.color,
    this.textColor,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final btnColor = color ?? theme.colorScheme.primary;
    final btnTextColor = textColor ?? Colors.white;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (errorMessage != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              errorMessage!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
        ElevatedButton.icon(
          onPressed: onRetry,
          style: ElevatedButton.styleFrom(
            backgroundColor: btnColor,
            foregroundColor: btnTextColor,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            textStyle: theme.textTheme.labelLarge?.copyWith(color: btnTextColor),
          ),
          icon: Icon(icon, color: btnTextColor),
          label: Text(
            buttonLabel,
            style: TextStyle(
              color: btnTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}