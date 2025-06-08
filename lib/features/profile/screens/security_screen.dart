import 'package:flutter/material.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Gérer la vraie sécurité (changement mot de passe, 2FA…)
    return Scaffold(
      appBar: AppBar(title: const Text('Sécurité')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Changer le mot de passe'),
            onTap: () {
              // TODO: Aller vers l'écran de changement de mot de passe
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Activer la validation en 2 étapes'),
            onTap: () {
              // TODO: Activer 2FA
            },
          ),
        ],
      ),
    );
  }
}