/// schedule_item.dart
/// Widget d'affichage résumé d'un créneau horaire (emploi du temps), utilisable dans une liste.
/// Appel d'un callback (onTap) pour afficher le détail ou éditer le créneau.
/// À adapter selon ton modèle ScheduleModel.
library;

import 'package:flutter/material.dart';

class ScheduleItem extends StatelessWidget {
  /// Exemple d'usage : remplace Map<String, String> par ScheduleModel si dispo
  final Map<String, String> schedule;
  final VoidCallback? onTap;

  const ScheduleItem({
    Key? key,
    required this.schedule,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Attributs à adapter selon ton modèle
    final subject = schedule['subject'] ?? 'Matière';
    final day = schedule['day'] ?? '';
    final start = schedule['start'] ?? '';
    final end = schedule['end'] ?? '';
    final teacher = schedule['teacher'] ?? '';
    final room = schedule['room'] ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.schedule),
        title: Text(subject, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          [
            if (day.isNotEmpty) '$day  •  ',
            if (start.isNotEmpty && end.isNotEmpty) '$start - $end',
            if (teacher.isNotEmpty) '\nProf : $teacher',
            if (room.isNotEmpty) '  |  $room',
          ].join(),
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}