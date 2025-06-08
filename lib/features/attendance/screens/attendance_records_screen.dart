import 'package:flutter/material.dart';
import '../widgets/attendance_card.dart';

class AttendanceRecordsScreen extends StatelessWidget {
  const AttendanceRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Brancher avec la vraie liste de présences
    final records = [
      {'date': '2025-05-20', 'status': 'Présent', 'note': ''},
      {'date': '2025-05-21', 'status': 'Absent', 'note': 'Malade'},
      {'date': '2025-05-22', 'status': 'Présent', 'note': ''},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Historique des présences')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: records.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => AttendanceCard(
          date: records[i]['date']!,
          status: records[i]['status']!,
          note: records[i]['note']!,
        ),
      ),
    );
  }
}