/// auth_header.dart
/// Widget d'en-tête commun pour les écrans d'authentification.
/// Affiche un logo, un titre, un sous-titre, et éventuellement une illustration.
library;

import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imageAsset; // Optionnel: pour une illustration ou un logo personnalisé

  const AuthHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (imageAsset != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Image.asset(
              imageAsset!,
              height: 90,
              fit: BoxFit.contain,
            ),
          ),
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}