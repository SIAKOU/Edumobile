/// grade_statistics_screen.dart
/// Affiche des statistiques sur les notes d'une classe, pour une matière et/ou une période.
/// Histogramme, moyenne, médiane, min, max, distribution, etc.

// ignore_for_file: dangling_library_doc_comments

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/models/grade_model.dart';
import 'package:gestion_ecole/core/models/subject_model.dart';
import 'package:gestion_ecole/core/services/grade_service.dart';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class GradeStatisticsScreen extends StatefulWidget {
  final String classId;
  final SubjectModel? subject; // null = toutes matières
  final String? period; // null = toutes périodes

  const GradeStatisticsScreen({
    Key? key,
    required this.classId,
    this.subject,
    this.period,
  }) : super(key: key);

  @override
  State<GradeStatisticsScreen> createState() => _GradeStatisticsScreenState();
}

class _GradeStatisticsScreenState extends State<GradeStatisticsScreen> {
  late final GradeService _gradeService;
  bool _isLoading = false;
  String? _error;
  List<GradeModel> _grades = [];

  @override
  void initState() {
    super.initState();
    final apiClient = Provider.of<ApiClient>(context, listen: false);
    _gradeService = GradeService(apiClient: apiClient);
    _fetchGrades();
  }

  Future<void> _fetchGrades() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      List<GradeModel> allGrades =
          await _gradeService.getGradesForClass(classId: widget.classId);
      if (widget.subject != null) {
        allGrades = allGrades.where((g) =>
            g.subjectId == widget.subject!.id ||
            g.subjectName == widget.subject!.name).toList();
      }
      if (widget.period != null) {
        allGrades = allGrades.where((g) => g.period == widget.period).toList();
      }
      setState(() {
        _grades = allGrades;
      });
    } catch (e) {
      setState(() {
        _error = "Erreur lors du chargement des notes : $e";
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  double? _average(List<double> values) =>
      values.isEmpty ? null : values.reduce((a, b) => a + b) / values.length;

  double? _median(List<double> values) {
    if (values.isEmpty) return null;
    final sorted = List<double>.from(values)..sort();
    final mid = sorted.length ~/ 2;
    if (sorted.length % 2 == 1) {
      return sorted[mid];
    } else {
      return (sorted[mid - 1] + sorted[mid]) / 2.0;
    }
  }

  double? _min(List<double> values) => values.isEmpty ? null : values.reduce(min);

  double? _max(List<double> values) => values.isEmpty ? null : values.reduce(max);

  Map<int, int> _histogram(List<double> values, {int step = 2, int maxValue = 20}) {
    // Regroupe les notes par "tranche" (ex: 0-2, 2-4, ..., 18-20)
    final hist = <int, int>{};
    for (var v in values) {
      int key = ((v ~/ step) * step).clamp(0, maxValue);
      hist[key] = (hist[key] ?? 0) + 1;
    }
    return hist;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final values = _grades.map((g) => g.value).toList();
    final maxValue = _grades.isNotEmpty && _grades.first.maxValue != null
        ? _grades.first.maxValue!.toInt()
        : 20;

    return Scaffold(
      appBar: AppBar(
        title: Text('Statistiques des notes'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchGrades),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : _grades.isEmpty
                  ? const Center(child: Text('Aucune note trouvée pour ce filtre.'))
                  : RefreshIndicator(
                      onRefresh: _fetchGrades,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          if (widget.subject != null)
                            _statRow('Matière', widget.subject!.name),
                          if (widget.period != null)
                            _statRow('Période', widget.period!),
                          _statRow('Nombre de notes', values.length.toString()),
                          _statRow(
                              'Moyenne',
                              _average(values) != null
                                  ? _average(values)!.toStringAsFixed(2)
                                  : '-'),
                          _statRow(
                              'Médiane',
                              _median(values) != null
                                  ? _median(values)!.toStringAsFixed(2)
                                  : '-'),
                          _statRow(
                              'Minimum',
                              _min(values) != null
                                  ? _min(values)!.toStringAsFixed(2)
                                  : '-'),
                          _statRow(
                              'Maximum',
                              _max(values) != null
                                  ? _max(values)!.toStringAsFixed(2)
                                  : '-'),
                          const SizedBox(height: 24),
                          Text("Distribution des notes", style: theme.textTheme.titleMedium),
                          const SizedBox(height: 10),
                          _buildHistogram(values, maxValue: maxValue),
                          const SizedBox(height: 24),
                          // Ajoute d'autres indicateurs/statistiques ici si besoin !
                        ],
                      ),
                    ),
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(width: 130, child: Text("$label :", style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildHistogram(List<double> values, {int maxValue = 20}) {
  final hist = _histogram(values, step: 2, maxValue: maxValue);
  final maxCount = hist.values.isEmpty ? 1 : hist.values.reduce(max);

  final sortedKeys = hist.keys.toList()..sort();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: sortedKeys.map<Widget>((k) {
      final count = hist[k]!;
      return Row(
        children: [
          SizedBox(width: 48, child: Text('$k-${k + 2}')),
          Expanded(
            child: LinearProgressIndicator(
              value: count / maxCount,
              minHeight: 18,
              backgroundColor: Colors.grey.shade200,
              color: Colors.blueAccent,
            ),
          ),
          SizedBox(width: 10),
          Text('$count'),
        ],
      );
    }).toList(),
  );
}
}