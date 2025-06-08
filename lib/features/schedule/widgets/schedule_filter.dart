/// schedule_filter.dart
/// Widget pour filtrer l'emploi du temps par jour, matière, professeur, etc.
/// À intégrer au-dessus d'une liste ou d'une grille d'emploi du temps.
library;

import 'package:flutter/material.dart';

class ScheduleFilter extends StatelessWidget {
  final List<String> days;
  final List<String> subjects;
  final List<String> teachers;
  final String? selectedDay;
  final String? selectedSubject;
  final String? selectedTeacher;
  final void Function({
    String? day,
    String? subject,
    String? teacher,
  }) onFilterChanged;

  const ScheduleFilter({
    Key? key,
    required this.days,
    required this.subjects,
    required this.teachers,
    this.selectedDay,
    this.selectedSubject,
    this.selectedTeacher,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Wrap(
          spacing: 16,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Jour
            DropdownButton<String>(
              value: selectedDay,
              hint: const Text('Jour'),
              items: [
                const DropdownMenuItem(value: null, child: Text('Tous les jours')),
                ...days.map((d) => DropdownMenuItem(value: d, child: Text(d))),
              ],
              onChanged: (v) => onFilterChanged(
                day: v,
                subject: selectedSubject,
                teacher: selectedTeacher,
              ),
            ),
            // Matière
            DropdownButton<String>(
              value: selectedSubject,
              hint: const Text('Matière'),
              items: [
                const DropdownMenuItem(value: null, child: Text('Toutes les matières')),
                ...subjects.map((s) => DropdownMenuItem(value: s, child: Text(s))),
              ],
              onChanged: (v) => onFilterChanged(
                day: selectedDay,
                subject: v,
                teacher: selectedTeacher,
              ),
            ),
            // Professeur
            DropdownButton<String>(
              value: selectedTeacher,
              hint: const Text('Professeur'),
              items: [
                const DropdownMenuItem(value: null, child: Text('Tous les professeurs')),
                ...teachers.map((t) => DropdownMenuItem(value: t, child: Text(t))),
              ],
              onChanged: (v) => onFilterChanged(
                day: selectedDay,
                subject: selectedSubject,
                teacher: v,
              ),
            ),
          ],
        ),
      ),
    );
  }
}