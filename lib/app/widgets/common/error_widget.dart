/// error_widget.dart
/// Widget réutilisable pour afficher un message d’erreur dans l’application.
/// Permet d’afficher un message, une icône et éventuellement une action de relance/retry.
/// Utilisez ce widget pour garantir une présentation cohérente des erreurs.
library;

import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final String? details;
  final IconData icon;
  final VoidCallback? onRetry;
  final String retryLabel;
  final Color? iconColor;
  final double iconSize;
  final EdgeInsetsGeometry padding;

  const CustomErrorWidget({
    Key? key,
    required this.message,
    this.details,
    this.icon = Icons.error_outline,
    this.onRetry,
    this.retryLabel = "Réessayer",
    this.iconColor,
    this.iconSize = 48,
    this.padding = const EdgeInsets.all(24),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconColorEff = iconColor ?? Theme.of(context).colorScheme.error;

    return Padding(
      padding: padding,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColorEff, size: iconSize),
            SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 18,
                color: iconColorEff,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (details != null && details!.isNotEmpty) ...[
              SizedBox(height: 8),
              Text(
                details!,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              SizedBox(height: 18),
              ElevatedButton.icon(
                icon: Icon(Icons.refresh, size: 18),
                label: Text(retryLabel),
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: iconColorEff,
                  foregroundColor: Colors.white,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}