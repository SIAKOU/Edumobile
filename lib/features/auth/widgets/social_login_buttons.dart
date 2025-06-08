/// social_login_buttons.dart
/// Widget réutilisable pour afficher les boutons de connexion sociale (Google, GitHub, etc.).
library;

import 'package:flutter/material.dart';

class SocialLoginButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onGoogle;
  final VoidCallback? onGithub;
  // Ajoute d'autres callbacks/providers ici si tu veux (Apple, Facebook, etc.)

  const SocialLoginButtons({
    super.key,
    this.isLoading = false,
    this.onGoogle,
    this.onGithub,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: Image.asset('assets/icons/google_logo.png', height: 24),
            label: const Text('Continuer avec Google'),
            onPressed: isLoading ? null : onGoogle,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: Image.asset('assets/icons/github_logo.png', height: 24),
            label: const Text('Continuer avec GitHub'),
            onPressed: isLoading ? null : onGithub,
          ),
        ),
        // Ajoute ici d'autres boutons pour Apple, Facebook, etc. si besoin
      ],
    );
  }
}