/// grade_chart.dart
/// Widget d'affichage graphique simple (barre ou ligne) des notes d'une liste d'élèves ou d'une matière.
/// Nécessite le package charts_flutter ou fl_chart.
///
/// Dépendance recommandée :
///   fl_chart: ^0.55.2

// ignore_for_file: dangling_library_doc_comments

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/models/grade_model.dart';
import 'package:fl_chart/fl_chart.dart';

class GradeChart extends StatelessWidget {
  final List<GradeModel> grades;
  final String? title;
  final double? maxValue; // ex: 20

  const GradeChart({
    Key? key,
    required this.grades,
    this.title,
    this.maxValue = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (grades.isEmpty) {
      return const Center(child: Text('Aucune note à afficher.'));
    }

    // Classement par valeur croissante pour la lisibilité
    final sorted = List<GradeModel>.from(grades)..sort((a, b) => a.value.compareTo(b.value));

    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  title!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            SizedBox(
              height: 240,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceBetween,
                  maxY: maxValue,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: ((maxValue ?? 20) / 4),
                        getTitlesWidget: (value, meta) => Text('${value.toInt()}'),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= sorted.length) return const SizedBox.shrink();
                          // Affiche les initiales de l'élève ou le rang
                          return Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text('${idx + 1}'),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(sorted.length, (i) {
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: sorted[i].value,
                          color: Colors.blueAccent,
                          width: 18,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                      showingTooltipIndicators: [0],
                    );
                  }),
                  gridData: FlGridData(show: true),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Affichage de la légende
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.square, color: Colors.blueAccent, size: 16),
                const SizedBox(width: 6),
                Text('Note obtenue'),
                if (maxValue != null) ...[
                  const SizedBox(width: 18),
                  Text('Barre max: ${maxValue?.toInt()}'),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}