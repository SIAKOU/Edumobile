import 'package:flutter/material.dart';
import '../widgets/attendance_chart.dart';

class AttendanceReportScreen extends StatelessWidget {
  const AttendanceReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Brancher avec les vraies données
    final stats = {
      'present': 18,
      'absent': 2,
      'late': 1,
      'excused': 1,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Rapport de présence')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            AttendanceChart(
              present: stats['present'] ?? 0,
              absent: stats['absent'] ?? 0,
              late: stats['late'] ?? 0,
              excused: stats['excused'] ?? 0,
            ),
            const SizedBox(height: 32),
            Text(
              'Présent : ${stats['present']}  •  Absent : ${stats['absent']}  •  En retard : ${stats['late']}  •  Excusé : ${stats['excused']}',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}