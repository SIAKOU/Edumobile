import 'package:flutter/material.dart';

class UpcomingEvents extends StatelessWidget {
  const UpcomingEvents({super.key, required List eventsList});

  @override
  Widget build(BuildContext context) {
    // TODO: Récupérer la vraie liste d’évènements.
    final events = [
      {'title': 'Contrôle de maths', 'date': '2025-06-02'},
      {'title': 'Sortie scolaire', 'date': '2025-06-10'},
      {'title': 'Réunion parents-profs', 'date': '2025-06-13'},
    ];

    if (events.isEmpty) {
      return const Text('Aucun évènement à venir.');
    }

    return Column(
      children: [
        for (final e in events)
          ListTile(
            leading: const Icon(Icons.event),
            title: Text(e['title']!),
            subtitle: Text(e['date']!),
          ),
      ],
    );
  }
}