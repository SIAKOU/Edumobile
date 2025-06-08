/// schedule_screen.dart
/// Affiche l'emploi du temps d'une classe ou d'un élève sous forme de liste ou grille.
/// Adapte selon ton modèle Schedule/Event.

// ignore_for_file: dangling_library_doc_comments, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/models/schedule_model.dart';
import 'package:gestion_ecole/core/providers/schedule_provider.dart';
import 'package:provider/provider.dart';
// Importe ton modèle Schedule/Event ici

class ScheduleScreen extends StatefulWidget {
  final String classId; // Pour filtrer par classe si besoin
  final String? studentId; // Pour emploi du temps spécifique élève

  const ScheduleScreen({Key? key, required this.classId, this.studentId})
      : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final bool _isLoading = false;
  String? _error;
  final List<ScheduleModel> _schedules = []; // Liste des emplois du temps
  // Utilise ton modèle Schedule/Event ici

  @override
  void initState() {
    super.initState();
    // Chargez les emplois du temps dès l'initialisation
    final scheduleProvider =
        Provider.of<ScheduleProvider>(context, listen: false);
    scheduleProvider.loadSchedules(
        classId: widget.classId, studentId: widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleProvider>(
      builder: (context, scheduleProvider, child) {
        // Gestion des différents états
        switch (scheduleProvider.status) {
          case ScheduleStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case ScheduleStatus.error:
            return Center(
              child: Text(
                scheduleProvider.errorMessage ?? "Erreur inconnue",
                style: const TextStyle(color: Colors.red),
              ),
            );
          case ScheduleStatus.loaded:
            return _buildScheduleList(scheduleProvider.schedules);
          default:
            return const Center(child: Text("État inconnu"));
        }
      },
    );
  }

  Widget _buildScheduleList(List<Map<String, dynamic>> schedules) {
    if (schedules.isEmpty) {
      return const Center(child: Text("Aucun emploi du temps disponible"));
    }

    return ListView.builder(
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        final schedule = schedules[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text(schedule['title'] ?? 'Sans titre'),
            subtitle: Text(
              '${schedule['day'] ?? ''} • ${schedule['start'] ?? ''} - ${schedule['end'] ?? ''}',
            ),
            onTap: () {
              // Action quand on clique sur un élément
            },
          ),
        );
      },
    );
  }
}
