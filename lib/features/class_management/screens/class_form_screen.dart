/// class_form_screen.dart
/// Écran pour la création et l'édition d'une classe.
/// Gère la validation, l'envoi du formulaire, et l'affichage des erreurs ou succès.
library;

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/models/class_model.dart';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/class_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ClassFormScreen extends StatefulWidget {
  final ClassModel? classModel; // null = création, sinon édition

  const ClassFormScreen({Key? key, this.classModel}) : super(key: key);

  @override
  State<ClassFormScreen> createState() => _ClassFormScreenState();
}

class _ClassFormScreenState extends State<ClassFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final ClassService _classService;

  // Champs du formulaire
  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _levelController;
  late TextEditingController _sectionController;
  late TextEditingController _schoolYearController;
  late TextEditingController _roomController;

  bool _isArchived = false;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final apiClient = Provider.of<ApiClient>(context, listen: false);
    _classService = ClassService(apiClient: apiClient);

    final c = widget.classModel;
    _nameController = TextEditingController(text: c?.name ?? '');
    _codeController = TextEditingController(text: c?.code ?? '');
    _levelController = TextEditingController(text: c?.level ?? '');
    _sectionController = TextEditingController(text: c?.section ?? '');
    _schoolYearController = TextEditingController(text: c?.schoolYear ?? '');
    _roomController = TextEditingController(text: c?.room ?? '');
    _isArchived = c?.isArchived ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _levelController.dispose();
    _sectionController.dispose();
    _schoolYearController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = ClassModel(
        id: widget.classModel?.id ?? '', // Peut être ignoré à la création
        name: _nameController.text.trim(),
        code: _codeController.text.trim().isNotEmpty ? _codeController.text.trim() : null,
        level: _levelController.text.trim().isNotEmpty ? _levelController.text.trim() : null,
        section: _sectionController.text.trim().isNotEmpty ? _sectionController.text.trim() : null,
        schoolYear: _schoolYearController.text.trim().isNotEmpty ? _schoolYearController.text.trim() : null,
        room: _roomController.text.trim().isNotEmpty ? _roomController.text.trim() : null,
        isArchived: _isArchived,
      );

      bool ok;
      if (widget.classModel == null) {
        ok = await _classService.createClass(data);
      } else {
        ok = await _classService.updateClass(widget.classModel!.id, data.toJson());
      }

      if (ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.classModel == null
                ? 'Classe créée avec succès !'
                : 'Classe modifiée avec succès !'),
          ),
        );
        Navigator.of(context).pop(true);
      } else {
        setState(() => _error = "Une erreur est survenue. Vérifiez vos données.");
      }
    } catch (e) {
      setState(() => _error = "Erreur lors de l'enregistrement : $e");
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.classModel != null;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Modifier la classe' : 'Créer une classe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(_error!, style: const TextStyle(color: Colors.red)),
                ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom de la classe *',
                  prefixIcon: Icon(Icons.class_),
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val != null && val.trim().isEmpty ? 'Le nom est obligatoire' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Code',
                  prefixIcon: Icon(Icons.code),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _levelController,
                decoration: const InputDecoration(
                  labelText: 'Niveau',
                  prefixIcon: Icon(Icons.school),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _sectionController,
                decoration: const InputDecoration(
                  labelText: 'Section',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _schoolYearController,
                decoration: const InputDecoration(
                  labelText: 'Année scolaire',
                  prefixIcon: Icon(Icons.date_range),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _roomController,
                decoration: const InputDecoration(
                  labelText: 'Salle',
                  prefixIcon: Icon(Icons.room),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Classe archivée'),
                value: _isArchived,
                onChanged: (val) => setState(() => _isArchived = val),
                secondary: const Icon(Icons.archive),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Icon(isEdit ? Icons.save : Icons.add),
                label: Text(isEdit ? 'Enregistrer les modifications' : 'Créer la classe'),
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}