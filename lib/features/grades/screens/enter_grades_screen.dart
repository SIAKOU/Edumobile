/// enter_grades_screen.dart
/// Permet à un enseignant de saisir ou modifier les notes des élèves d'une classe pour une matière et une période donnée.

// ignore_for_file: dangling_library_doc_comments

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/models/user_model.dart';
import 'package:gestion_ecole/core/models/subject_model.dart';
import 'package:gestion_ecole/core/models/grade_model.dart';
import 'package:gestion_ecole/core/services/grade_service.dart';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:provider/provider.dart';

class EnterGradesScreen extends StatefulWidget {
  final String classId;
  final SubjectModel subject;
  final String period; // Ex: "Trimestre 1", "Semestre 2", etc.
  final List<UserModel> students; // Liste des élèves concernés

  const EnterGradesScreen({
    Key? key,
    required this.classId,
    required this.subject,
    required this.period,
    required this.students,
  }) : super(key: key);

  @override
  State<EnterGradesScreen> createState() => _EnterGradesScreenState();
}

class _EnterGradesScreenState extends State<EnterGradesScreen> {
  late final GradeService _gradeService;
  final Map<String, TextEditingController> _controllers = {}; // studentId -> controller
  final Map<String, GradeModel?> _existingGrades = {}; // studentId -> grade existant
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final apiClient = Provider.of<ApiClient>(context, listen: false);
    _gradeService = GradeService(apiClient: apiClient);
    _fetchExistingGrades();
  }

  Future<void> _fetchExistingGrades() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      // Optionnel : adapte getGradesForClass pour filtrer par matière/période si besoin
      final classGrades = await _gradeService.getGradesForClass(classId: widget.classId);
      for (var student in widget.students) {
        final grade = classGrades.firstWhere(
          (g) =>
              g.studentId == student.id &&
              (g.subjectId == widget.subject.id || g.subjectName == widget.subject.name) &&
              g.period == widget.period,
        );
        _existingGrades[student.id] = grade;
        _controllers[student.id] = TextEditingController(
            text: grade != null ? grade.value.toString() : '');
      }
    } catch (e) {
      _error = "Erreur lors du chargement des notes : $e";
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveAllGrades() async {
    setState(() {
      _isSaving = true;
      _error = null;
    });
    try {
      for (var student in widget.students) {
        final ctrl = _controllers[student.id];
        if (ctrl == null) continue;
        final text = ctrl.text.trim();
        if (text.isEmpty) continue;
        final value = double.tryParse(text);
        if (value == null) continue;

        final existing = _existingGrades[student.id];
        if (existing != null) {
          // Update
          await _gradeService.updateGrade(existing.id, {
            'value': value,
            'period': widget.period,
            'subjectId': widget.subject.id,
            'subjectName': widget.subject.name,
          });
        } else {
          // Create
          await _gradeService.createGrade(
            GradeModel(
              id: UniqueKey().toString(),
              studentId: student.id,
              classId: widget.classId,
              subjectId: widget.subject.id,
              subjectName: widget.subject.name,
              value: value,
              maxValue: 20, // Par défaut, à adapter si besoin
              date: DateTime.now(),
              type: null,
              period: widget.period,
              teacherId: null, // À compléter si besoin
              comment: null,
            ),
          );
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Notes enregistrées avec succès !'),
        ));
      }
    } catch (e) {
      setState(() {
        _error = "Erreur lors de l'enregistrement : $e";
      });
    }
    setState(() {
      _isSaving = false;
    });
  }

  @override
  void dispose() {
    for (var ctrl in _controllers.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Saisie des notes - ${widget.subject.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: "Enregistrer toutes les notes",
            onPressed: _isSaving ? null : _saveAllGrades,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      child: Text(
                        'Période : ${widget.period}',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.students.length,
                        itemBuilder: (context, index) {
                          final student = widget.students[index];
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                (student.displayName.isNotEmpty == true
                                        ? student.displayName[0]
                                        : (student.username?.isNotEmpty == true
                                            ? student.username![0]
                                            : '?'))
                                    .toUpperCase(),
                              ),
                            ),
                            title: Text(student.displayName ),
                            subtitle: student.email != null
                                ? Text(student.email!)
                                : null,
                            trailing: SizedBox(
                              width: 80,
                              child: TextField(
                                controller: _controllers[student.id],
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                decoration: const InputDecoration(
                                  labelText: 'Note',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                ),
                                enabled: !_isSaving,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (_isSaving)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                  ],
                ),
      floatingActionButton: _isSaving
          ? null
          : FloatingActionButton.extended(
              icon: const Icon(Icons.save),
              label: const Text('Enregistrer'),
              onPressed: _saveAllGrades,
            ),
    );
  }
}