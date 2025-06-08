/// terms_and_conditions.dart
/// Écran d'affichage des Conditions Générales d'Utilisation (CGU) et Politique de Confidentialité.
/// Peut être affiché lors de l'inscription ou via un lien dédié dans l'app.
library;

import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conditions d\'utilisation'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
        child: ListView(
          children: [
            Text(
              'Conditions Générales d\'Utilisation',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            const Text(
              "En utilisant cette application, vous acceptez les conditions suivantes :",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 14),
            const Text(
              "1. Utilisation des services\n"
              "• L'application est destinée à un usage personnel et éducatif.\n"
              "• L'utilisateur s'engage à fournir des informations exactes lors de l'inscription.\n"
              "\n"
              "2. Confidentialité et sécurité\n"
              "• Vos données sont sécurisées et ne seront jamais vendues à des tiers.\n"
              "• Nous utilisons des services tiers (Firebase, Google, GitHub) pour l'authentification et le stockage sécurisé.\n"
              "\n"
              "3. Responsabilité\n"
              "• Les administrateurs de l'application ne peuvent être tenus responsables d'une mauvaise utilisation.\n"
              "• L'utilisateur est responsable de la confidentialité de ses identifiants.\n"
              "\n"
              "4. Modification et suppression\n"
              "• Vous pouvez demander la suppression de votre compte à tout moment.\n"
              "• Les conditions peuvent évoluer ; vous serez notifié en cas de changements majeurs.",
              style: TextStyle(fontSize: 15, height: 1.7),
            ),
            const SizedBox(height: 22),
            Text(
              'Politique de Confidentialité',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "L'application collecte uniquement les informations strictement nécessaires à votre identification et à l'utilisation des fonctionnalités proposées.\n"
              "\n"
              "Nous respectons votre vie privée et ne partageons aucune information personnelle sans votre consentement. Pour toute question, contactez-nous à : support@edumobile.com",
              style: TextStyle(fontSize: 15, height: 1.7),
            ),
            const SizedBox(height: 28),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle),
                label: const Text("J'ai lu et j'accepte"),
                onPressed: () {
                  Navigator.of(context).pop(true); // Renvoie true si tu veux vérifier l'acceptation
                },
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Refuser"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}