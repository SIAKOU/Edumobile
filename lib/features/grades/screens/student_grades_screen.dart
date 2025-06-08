/// student_grades_screen.dart
/// Affiche les notes d'un élève dans une classe donnée, avec détails par matière et période.
///
/// Utilisation :
/// Navigator.push(context, MaterialPageRoute(
///   builder: (_) => StudentGradesScreen(studentId: ..., classId: ...),
/// ));
library;

// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/grade_service.dart';
import 'package:gestion_ecole/core/models/grade_model.dart';
import 'package:gestion_ecole/core/models/user_model.dart';
import 'package:gestion_ecole/core/models/subject_model.dart';
import 'package:provider/provider.dart';

class StudentGradesScreen extends StatefulWidget {
  final String studentId;
  final String classId;
  final UserModel? student; // Optionnel : pour l'affichage du nom

  const StudentGradesScreen({
    Key? key,
    required this.studentId,
    required this.classId,
    this.student,
  }) : super(key: key);

  @override
  State<StudentGradesScreen> createState() => _StudentGradesScreenState();
}

class _StudentGradesScreenState extends State<StudentGradesScreen> {
  late GradeService _gradeService;
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
      _grades = [];
    });
    try {
      final grades = await _gradeService.getGradesForStudent(
        studentId: widget.studentId,
        classId: widget.classId,
      );
      setState(() {
        _grades = grades;
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

  Map<String, List<GradeModel>> _groupGradesBySubject(List<GradeModel> grades) {
    final map = <String, List<GradeModel>>{};
    for (final grade in grades) {
      final subject = grade.subjectName ?? grade.subjectId ?? "Autre";
      map.putIfAbsent(subject, () => []).add(grade);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final studentName = widget.student?.displayName ?? widget.studentId;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes de $studentName'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchGrades,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : _grades.isEmpty
                  ? const Center(child: Text('Aucune note trouvée pour cet élève.'))
                  : RefreshIndicator(
                      onRefresh: _fetchGrades,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: _buildGradesBySubject(),
                      ),
                    ),
    );
  }

  List<Widget> _buildGradesBySubject() {
    final grouped = _groupGradesBySubject(_grades);
    final widgets = <Widget>[];
    grouped.forEach((subject, grades) {
      widgets.add(
        Card(
          margin: const EdgeInsets.only(bottom: 18),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                const SizedBox(height: 8),
                ...grades.map((grade) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.grade),
                      title: Text(
                        'Note : ${grade.value.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: grade.period != null
                          ? Text('Période : ${grade.period}')
                          : null,
                      trailing: grade.maxValue != null
                          ? Text('/ ${grade.maxValue}', style: const TextStyle(color: Colors.grey))
                          : null,
                    )),
              ],
            ),
          ),
        ),
      );
    });
    return widgets;
  }
}