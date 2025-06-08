/// performance_summary.dart
/// Widget pour afficher un résumé des performances (élèves, classes, enseignants, etc.)
/// Utilisable dans le dashboard admin, prof, ou élève selon les stats à afficher.
library;

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/models/grade_model.dart';

class PerformanceSummary extends StatelessWidget {
  final int? studentCount;
  final int? teacherCount;
  final int? classCount;
  final int? announcementCount;
  final int? activeUsers;
  final int? totalPayments;
  final List<GradeModel>? gradesList;

  const PerformanceSummary({
    Key? key,
    this.studentCount,
    this.teacherCount,
    this.classCount,
    this.announcementCount,
    this.activeUsers,
    this.totalPayments,
    this.gradesList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatItem(
        icon: Icons.group,
        label: 'Élèves',
        value: studentCount?.toString() ?? '0',
        color: Colors.blue,
      ),
      _StatItem(
        icon: Icons.person,
        label: 'Enseignants',
        value: teacherCount?.toString() ?? '0',
        color: Colors.green,
      ),
      _StatItem(
        icon: Icons.class_,
        label: 'Classes',
        value: classCount?.toString() ?? '0',
        color: Colors.deepPurple,
      ),
      _StatItem(
        icon: Icons.campaign,
        label: 'Annonces',
        value: announcementCount?.toString() ?? '0',
        color: Colors.orange,
      ),
      if (activeUsers != null)
        _StatItem(
          icon: Icons.wifi,
          label: 'Actifs',
          value: activeUsers.toString(),
          color: Colors.teal,
        ),
      if (totalPayments != null)
        _StatItem(
          icon: Icons.payment,
          label: 'Paiements',
          value: totalPayments.toString(),
          color: Colors.indigo,
        ),
      if (gradesList != null)
        _StatItem(
          icon: Icons.grade,
          label: 'Notes',
          value: gradesList!.length.toString(),
          color: Colors.amber,
        ),
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: stats
              .map((stat) => Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          backgroundColor: stat.color.withOpacity(0.13),
                          child: Icon(stat.icon, color: stat.color),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          stat.value,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: stat.color,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          stat.label,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class _StatItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}