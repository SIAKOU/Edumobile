/// announcement_editor.dart
/// Widget réutilisable pour créer ou éditer une annonce (AnnouncementModel) dans un formulaire.
/// Peut être utilisé dans une bottom sheet, un dialog, ou un écran dédié.
library;

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/models/announcement_model.dart';
// Corrige ce chemin selon ton projet

class AnnouncementEditor extends StatefulWidget {
  final AnnouncementModel? initialAnnouncement;
  final void Function(AnnouncementModel announcement) onSave;

  const AnnouncementEditor({
    Key? key,
    this.initialAnnouncement,
    required this.onSave,
  }) : super(key: key);

  @override
  State<AnnouncementEditor> createState() => _AnnouncementEditorState();
}

class _AnnouncementEditorState extends State<AnnouncementEditor> {
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

      final announcement = AnnouncementModel(
        id: widget.initialAnnouncement?.id ?? UniqueKey().toString(),
        title: _titleCtrl.text.trim(),
        content: _contentCtrl.text.trim().isEmpty ? null : _contentCtrl.text.trim(),
        authorId: widget.initialAnnouncement?.authorId, // Peut être défini par le parent
        classId: widget.initialAnnouncement?.classId,
        createdAt: widget.initialAnnouncement?.createdAt ?? now,
        updatedAt: widget.initialAnnouncement != null ? now : null,
        publishedAt: widget.initialAnnouncement?.publishedAt,
        deletedAt: widget.initialAnnouncement?.deletedAt,
        isActive: _isActive,
        attachments: attachments.isNotEmpty ? attachments : null,
      );
      widget.onSave(announcement);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialAnnouncement != null;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          const SizedBox(height: 14),
          // Contenu
          TextFormField(
            controller: _contentCtrl,
            decoration: const InputDecoration(
              labelText: 'Contenu',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 14),
          // Pièces jointes (URLs, une par ligne)
          TextFormField(
            controller: _attachmentsCtrl,
            decoration: const InputDecoration(
              labelText: 'URLs des pièces jointes (une par ligne)',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          // Actif ou non
          SwitchListTile(
            value: _isActive,
            title: const Text('Annonce active'),
            onChanged: (v) => setState(() => _isActive = v),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: Icon(isEditing ? Icons.edit : Icons.add),
            label: Text(isEditing ? 'Mettre à jour' : 'Créer'),
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(45),
            ),
          ),
        ],
      ),
    );
  }
}