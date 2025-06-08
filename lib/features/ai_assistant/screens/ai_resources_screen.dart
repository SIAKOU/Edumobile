
import 'package:flutter/material.dart';

class AiResourcesScreen extends StatelessWidget {
  const AiResourcesScreen({super.key});

  // Simule une liste de ressources IA (à remplacer par un chargement dynamique si besoin)
  List<Map<String, String>> get resources => const [
        {
          'title': 'Guide de l’assistant IA',
          'description': 'Découvrir comment utiliser l\'assistant.',
        },
        {
          'title': 'Exemples de prompts',
          'description': 'Trouver des exemples de questions utiles.',
        },
        {
          'title': 'FAQ IA',
          'description': 'Questions fréquentes sur l\'assistant IA.',
        },
      ];

  void _onResourceTap(BuildContext context, Map<String, String> resource) {
    // Exemple : Affiche un dialogue d’information (remplace par une navigation si besoin)
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(resource['title'] ?? ''),
        content: Text(resource['description'] ?? ''),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ressources IA')),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: resources.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (_, i) => Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(
              resources[i]['title'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(resources[i]['description'] ?? ''),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _onResourceTap(context, resources[i]),
          ),
        ),
      ),
    );
  }
}
