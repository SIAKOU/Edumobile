/// create_announcement_screen.dart
/// Écran pour créer ou éditer une annonce (AnnouncementModel).
/// Peut servir à l'ajout comme à l'édition selon la présence d'un modèle existant.
library;

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/models/announcement_model.dart';
import 'package:intl/intl.dart';
 // Corrige le chemin selon ton projet

class CreateAnnouncementScreen extends StatefulWidget {
  final AnnouncementModel? initialAnnouncement;
  final void Function(AnnouncementModel announcement)? onSave;

  const CreateAnnouncementScreen({
    Key? key,
    this.initialAnnouncement,
    this.onSave,
  }) : super(key: key);

  @override
  State<CreateAnnouncementScreen> createState() => _CreateAnnouncementScreenState();
}

class _CreateAnnouncementScreenState extends State<CreateAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _contentCtrl;
  late TextEditingController _attachmentsCtrl;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initialAnnouncement?.title ?? '');
    _contentCtrl = TextEditingController(text: widget.initialAnnouncement?.content ?? '');
    _attachmentsCtrl = TextEditingController(
      text: widget.initialAnnouncement?.attachments?.join('\n') ?? '',
    );
    _isActive = widget.initialAnnouncement?.isActive ?? true;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    _attachmentsCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final now = DateTime.now();
      final attachments = _attachmentsCtrl.text
          .split('\n')
          .map((url) => url.trim())
          .where((url) => url.isNotEmpty)
          .toList();

      final newAnnouncement = AnnouncementModel(
        id: widget.initialAnnouncement?.id ?? UniqueKey().toString(),
        title: _titleCtrl.text.trim(),
        content: _contentCtrl.text.trim().isEmpty ? null : _contentCtrl.text.trim(),
        authorId: widget.initialAnnouncement?.authorId, // À setter selon le contexte
        classId: widget.initialAnnouncement?.classId,   // À setter selon le contexte
        createdAt: widget.initialAnnouncement?.createdAt ?? now,
        updatedAt: widget.initialAnnouncement != null ? now : null,
        publishedAt: widget.initialAnnouncement?.publishedAt,
        deletedAt: widget.initialAnnouncement?.deletedAt,
        isActive: _isActive,
        attachments: attachments.isNotEmpty ? attachments : null,
      );
      widget.onSave?.call(newAnnouncement);
      Navigator.of(context).pop(newAnnouncement);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialAnnouncement != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier l\'annonce' : 'Nouvelle annonce'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Enregistrer',
            onPressed: _submit,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Titre
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Titre',
                  border: OutlineInputBorder(),
                ),
                maxLength: 80,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Le titre est requis' : null,
              ),
              const SizedBox(height: 18),
              // Contenu
              TextFormField(
                controller: _contentCtrl,
                decoration: const InputDecoration(
                  labelText: 'Contenu',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 6,
              ),
              const SizedBox(height: 18),
              // Pièces jointes (URLs, une par ligne)
              TextFormField(
                controller: _attachmentsCtrl,
                decoration: const InputDecoration(
                  labelText: 'URLs des pièces jointes (une par ligne)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 18),
              // Actif ou non
              SwitchListTile(
                value: _isActive,
                title: const Text('Annonce active'),
                onChanged: (v) => setState(() => _isActive = v),
              ),
              const SizedBox(height: 22),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(isEditing ? 'Mettre à jour' : 'Créer'),
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(46),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}