/// schedule_screen.dart
/// Affiche l'emploi du temps d'une classe ou d'un élève sous forme de liste ou grille.
/// Adapte selon ton modèle Schedule/Event.
library;

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/models/schedule_model.dart';
import 'package:gestion_ecole/core/providers/schedule_provider.dart';
import 'package:provider/provider.dart';
// Importe ton modèle Schedule/Event ici

class ScheduleScreen extends StatefulWidget {
  final String classId; // Pour filtrer par classe si besoin
  final String? studentId; // Pour emploi du temps spécifique élève

  // const ScheduleScreen({Key? key, required this.classId, this.studentId}) : super(key: key);
  const ScheduleScreen({Key? key, required this.classId, this.studentId})
      : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  bool _isLoading = false;
  String? _error;
  List<ScheduleModel> _schedules = [];

  @override
  void initState() {
    super.initState();
    _fetchSchedules();
  }

  Future<void> _fetchSchedules() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      // Si tu utilises un provider, par exemple ScheduleProvider :
      final scheduleProvider = Provider.of<ScheduleProvider>(
        context,
        listen: false,
      );
      _schedules = await scheduleProvider.getSchedulesForClass(
          widget.classId); // Pour filtrer par classe si besoin
      // Si tu veux un emploi du temps spécifique à un élève, adapte la méthode
    } catch (e) {
      setState(() {
        _error = "Erreur lors du chargement de l'emploi du temps : $e";
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Exemples de données factices à remplacer par ton modèle
    final exampleSchedules = [
      {
        'day': 'Lundi',
        'start': '08:00',
        'end': '09:30',
        'subject': 'Mathématiques',
        'teacher': 'M. Dupont',
        'room': 'Salle 101',
      },
      {
        'day': 'Lundi',
        'start': '09:45',
        'end': '11:15',
        'subject': 'Français',
        'teacher': 'Mme Martin',
        'room': 'Salle 102',
      },
      // Ajoute d'autres créneaux...
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emploi du temps'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchSchedules,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child:
                      Text(_error!, style: const TextStyle(color: Colors.red)))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: exampleSchedules.length,
                  separatorBuilder: (_, __) => const Divider(height: 24),
                  itemBuilder: (context, index) {
                    final sched = exampleSchedules[index];
                    return Card(
                      elevation: 2,
                      child: ListTile(
                        leading: const Icon(Icons.schedule),
                        title: Text('${sched['subject']}'),
                        subtitle: Text(
                            '${sched['day']} • ${sched['start']} - ${sched['end']}\n'
                            'Prof : ${sched['teacher']}  |  ${sched['room']}'),
                        isThreeLine: true,
                        // onTap: () {}, // Affiche détail ou modifie
                      ),
                    );
                  },
                ),
    );
  }
}
