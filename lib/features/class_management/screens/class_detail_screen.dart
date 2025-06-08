// class_detail_screen.dart
// Écran affichant le détail d'une classe, ses informations principales,
// la liste de ses élèves, le(s) professeur(s) responsable(s), et actions contextuelles (édition, suppression, archivage...).

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/models/class_model.dart';
import 'package:gestion_ecole/core/models/user_model.dart';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/class_service.dart';
import 'package:gestion_ecole/core/services/user_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ClassDetailScreen extends StatefulWidget {
  final ClassModel? classModel; // Peut être passé via la navigation
  final String? classId; // Optionnel si navigation par id

  const ClassDetailScreen({Key? key, this.classModel, this.classId}) : super(key: key);

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  late final ClassService _classService;
  late final UserService _userService;
  ClassModel? _classModel;
  List<UserModel> _students = [];
  bool _isLoading = false;
  bool _studentLoading = false;
  String? _error;
  String? _studentError;

  @override
  void initState() {
    super.initState();
    final apiClient = Provider.of<ApiClient>(context, listen: false);
    _classService = ClassService(apiClient: apiClient);
    _userService = UserService(apiClient: apiClient);
    _loadClass();
  }

  Future<void> _loadClass() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      if (widget.classModel != null) {
        _classModel = widget.classModel;
      } else if (widget.classId != null) {
        _classModel = await _classService.getClassById(widget.classId!);
      } else {
        throw Exception('Aucune classe spécifiée');
      }
      if (_classModel != null) {
        await _loadStudents(_classModel!.id);
      }
    } catch (e) {
      setState(() => _error = 'Erreur lors du chargement de la classe : $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _loadStudents(String classId) async {
    setState(() {
      _studentLoading = true;
      _studentError = null;
      _students = [];
    });
    try {
      final all = await _userService.getAllUsers();
      setState(() {
        _students = all.where((u) => u.classId == classId && (u.isStudent)).toList();
      });
    } catch (e) {
      setState(() => _studentError = "Impossible de charger les élèves : $e");
    }
    setState(() {
      _studentLoading = false;
    });
  }

  void _goToEditClass() {
    if (_classModel == null) return;
    context.go('/class-form', extra: _classModel);
  }

  Future<void> _deleteClass() async {
    if (_classModel == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer la classe ?'),
        content: const Text('Cette action est irréversible. Voulez-vous vraiment supprimer cette classe ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Supprimer', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      final ok = await _classService.deleteClass(_classModel!.id);
      if (ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Classe supprimée !')));
        Navigator.of(context).pop();
      } else {
        setState(() => _error = 'Erreur lors de la suppression.');
      }
    } catch (e) {
      setState(() => _error = 'Erreur lors de la suppression : $e');
    }
    setState(() => _isLoading = false);
  }

  Widget _buildStudentsList() {
    if (_studentLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_studentError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(child: Text(_studentError!, style: const TextStyle(color: Colors.red))),
      );
    }
    if (_students.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(child: Text('Aucun élève inscrit dans cette classe.')),
      );
    }
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(top: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _students.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final student = _students[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(
                (student.fullName?.isNotEmpty == true
                        ? student.fullName![0]
                        : (student.username?.isNotEmpty == true
                            ? student.username![0]
                            : '?'))
                    .toUpperCase(),
              ),
            ),
            title: Text(student.displayName),
            subtitle: student.email != null ? Text(student.email!) : null,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail de la classe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: "Éditer",
            onPressed: _classModel == null ? null : _goToEditClass,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: "Supprimer",
            onPressed: _classModel == null ? null : _deleteClass,
            color: Colors.red,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : _classModel == null
                  ? const Center(child: Text('Aucune donnée de classe.'))
                  : RefreshIndicator(
                      onRefresh: _loadClass,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 28,
                                        child: Text(
                                          _classModel!.name.isNotEmpty
                                              ? _classModel!.name[0].toUpperCase()
                                              : '?',
                                          style: const TextStyle(fontSize: 28),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(_classModel!.name, style: theme.textTheme.headlineSmall),
                                            if (_classModel!.level != null)
                                              Text('Niveau : ${_classModel!.level}'),
                                            if (_classModel!.section != null)
                                              Text('Section : ${_classModel!.section}'),
                                            if (_classModel!.code != null)
                                              Text('Code : ${_classModel!.code}'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  if (_classModel!.schoolYear != null)
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today, size: 18),
                                        const SizedBox(width: 8),
                                        Text('Année scolaire : ${_classModel!.schoolYear}'),
                                      ],
                                    ),
                                  if (_classModel!.room != null)
                                    Row(
                                      children: [
                                        const Icon(Icons.meeting_room, size: 18),
                                        const SizedBox(width: 8),
                                        Text('Salle : ${_classModel!.room}'),
                                      ],
                                    ),
                                  if (_classModel!.teacherName != null)
                                    Row(
                                      children: [
                                        const Icon(Icons.person, size: 18),
                                        const SizedBox(width: 8),
                                        Text('Professeur principal : ${_classModel!.teacherName}'),
                                      ],
                                    ),
                                  if (_classModel!.studentCount != null)
                                    Row(
                                      children: [
                                        const Icon(Icons.group, size: 18),
                                        const SizedBox(width: 8),
                                        Text('Effectif : ${_classModel!.studentCount} élèves'),
                                      ],
                                    ),
                                  if (_classModel!.createdAt != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'Créée le : ${_classModel!.createdAt!.toLocal().toString().split(' ')[0]}',
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ),
                                  if (_classModel!.isArchived == true)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.archive, color: Colors.grey),
                                          const SizedBox(width: 8),
                                          Text('Classe archivée', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Élèves inscrits',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          _buildStudentsList(),
                        ],
                      ),
                    ),
    );
  }
}