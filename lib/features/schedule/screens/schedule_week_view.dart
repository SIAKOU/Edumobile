/// schedule_week_view.dart
/// Affiche l'emploi du temps de la semaine pour une classe ou un élève sous forme de grille ou de liste groupée par jour.
/// À adapter selon ton modèle Schedule/Event.

// ignore_for_file: dangling_library_doc_comments

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/models/schedule_model.dart';
import 'package:gestion_ecole/features/schedule/screens/schedule_details_screen.dart';

class ScheduleWeekView extends StatelessWidget {
  // final String classId;
  // final String? studentId;
  // final List<ScheduleModel> schedules;

  /// Exemple de créneaux par jour (à remplacer par tes données)
  final Map<String, List<Map<String, String>>> exampleWeekSlots;

  const ScheduleWeekView({
    Key? key,
    //required this.classId,
    // this.studentId,
    // required this.schedules,
    this.exampleWeekSlots = const {
      'Lundi': [
        {
          'start': '08:00',
          'end': '09:30',
          'subject': 'Mathématiques',
          'teacher': 'M. Dupont',
          'room': 'Salle 101',
        },
        {
          'start': '09:45',
          'end': '11:15',
          'subject': 'Français',
          'teacher': 'Mme Martin',
          'room': 'Salle 102',
        },
      ],
      'Mardi': [
        {
          'start': '10:00',
          'end': '11:30',
          'subject': 'Physique',
          'teacher': 'M. Bernard',
          'room': 'Salle 201',
        }
      ],
      // Ajoute d'autres jours...
    },
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Pour un vrai modèle : regroupe les créneaux par jour
    final Map<String, List<ScheduleModel>> slotsByDay = {};

    for (var slot in exampleWeekSlots.entries) {
      final day = slot.key;
      final slots = slot.value;

      slotsByDay[day] = slots.map((data) {
        return ScheduleModel(
          id: '', // Laisser vide ou générer un ID si nécessaire
          startTime: DateTime.parse('2025-12-01T${data['start'] ?? '00:00'}:00'),
          endTime: DateTime.parse('2025-12-01T${data['end'] ?? '00:00'}:00'),
          subject: data['subject'] ?? '',
          teacher: data['teacher'] ?? '',
          room: data['room'] ?? '', 
        );
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emploi du temps - Semaine'),
      ),
      body: exampleWeekSlots.isEmpty
          ? const Center(child: Text('Aucun créneau cette semaine.'))
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              itemCount: exampleWeekSlots.keys.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final day = exampleWeekSlots.keys.elementAt(index);
                final slots = exampleWeekSlots[day]!;
                return Card(
                  elevation: 3,
                  child: ExpansionTile(
                    initiallyExpanded: index == 0,
                    leading: const Icon(Icons.calendar_today),
                    title: Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
                    children: slots.isEmpty
                        ? [
                            const ListTile(
                              title: Text('Aucun cours ce jour.'),
                            )
                          ]
                        : slots.map((slot) {
                            return ListTile(
                              leading: const Icon(Icons.class_),
                              title: Text(slot['subject'] ?? 'Matière'),
                              subtitle: Text(
                                  '${slot['start']} - ${slot['end']}'
                                  '\nProf : ${slot['teacher']}  |  ${slot['room']}'),
                              isThreeLine: true,
                              onTap: () {
                                // Affiche les détails du cours si besoin
                                //afficher ca en pop  sur la meme page 
                                 Navigator.push(
                                   context,
                                   MaterialPageRoute(
                                     builder: (context) => ScheduleDetailsScreen(
                                       schedule: slot,
                                     ),
                                   ),
                                );

                              }, 
                            );
                          }).toList(),
                  ),
                );
              },
            ),
    );
  }
}

