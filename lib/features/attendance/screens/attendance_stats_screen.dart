/// attendance_stats_screen.dart
/// Affiche les statistiques de présence d'un élève ou d'une classe.
/// Peut être utilisée pour voir le taux de présence/absence, avec des graphiques ou des listes détaillées.

// ignore_for_file: dangling_library_doc_comments

import 'package:flutter/material.dart';

class AttendanceStatsScreen extends StatelessWidget {
  final String? studentName;
  final List<Map<String, dynamic>>? attendanceRecords;
  // attendanceRecords: Listes de Map, chaque Map : { 'date': DateTime, 'status': 'présent'/'absent'/'retard', 'reason': '...' }

  const AttendanceStatsScreen({
    Key? key,
    this.studentName,
    this.attendanceRecords,
  }) : super(key: key);

  // Exemple de données fictives, à remplacer par une source réelle
  List<Map<String, dynamic>> get _sampleRecords => [
        {'date': DateTime(2025, 5, 27), 'status': 'présent', 'reason': null},
        {'date': DateTime(2025, 5, 28), 'status': 'absent', 'reason': 'Malade'},
        {'date': DateTime(2025, 5, 29), 'status': 'présent', 'reason': null},
        {'date': DateTime(2025, 5, 30), 'status': 'retard', 'reason': 'Transport'},
        {'date': DateTime(2025, 5, 31), 'status': 'absent', 'reason': 'RDV médical'},
        {'date': DateTime(2025, 6, 1), 'status': 'présent', 'reason': null},
      ];

  @override
  Widget build(BuildContext context) {
    final records = attendanceRecords ?? _sampleRecords;
    final total = records.length;
    final presents = records.where((r) => r['status'] == 'présent').length;
    final absents = records.where((r) => r['status'] == 'absent').length;
    final retards = records.where((r) => r['status'] == 'retard').length;
    final presentRate = total == 0 ? 0.0 : presents / total * 100;
    final absentRate = total == 0 ? 0.0 : absents / total * 100;
    final retardsRate = total == 0 ? 0.0 : retards / total * 100;

    return Scaffold(
      appBar: AppBar(
        title: Text(studentName != null
            ? 'Présence : $studentName'
            : 'Statistiques de présence'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Résumé",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _statRow(Icons.check_circle, "Présent", presents, presentRate, Colors.green),
            _statRow(Icons.cancel, "Absent", absents, absentRate, Colors.red),
            _statRow(Icons.access_time, "Retard", retards, retardsRate, Colors.orange),
            const SizedBox(height: 32),
            Text(
              "Historique",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: records.isEmpty
                  ? const Center(child: Text("Aucune donnée de présence."))
                  : ListView.builder(
                      itemCount: records.length,
                      itemBuilder: (_, i) {
                        final r = records[i];
                        return ListTile(
                          leading: Icon(
                            r['status'] == 'présent'
                                ? Icons.check_circle
                                : r['status'] == 'absent'
                                    ? Icons.cancel
                                    : Icons.access_time,
                            color: r['status'] == 'présent'
                                ? Colors.green
                                : r['status'] == 'absent'
                                    ? Colors.red
                                    : Colors.orange,
                          ),
                          title: Text(_formatDate(r['date'])),
                          subtitle: r['reason'] != null
                              ? Text(r['reason'])
                              : null,
                          trailing: Text(
                            r['status'].toString().toUpperCase(),
                            style: TextStyle(
                              color: r['status'] == 'présent'
                                  ? Colors.green
                                  : r['status'] == 'absent'
                                      ? Colors.red
                                      : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statRow(IconData icon, String label, int count, double rate, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
          const Spacer(),
          Text("$count (${rate.toStringAsFixed(1)}%)", style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}