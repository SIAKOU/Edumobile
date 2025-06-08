/// grade_detail_screen.dart
/// Affiche le détail d'une note (GradeModel) pour un élève, avec options de modification/suppression si besoin.

// ignore_for_file: dangling_library_doc_comments

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/models/grade_model.dart';
import 'package:intl/intl.dart';

class GradeDetailScreen extends StatelessWidget {
  final GradeModel grade;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const GradeDetailScreen({
    Key? key,
    required this.grade,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMMd('fr_FR');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail de la note'),
        actions: [
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: "Modifier",
              onPressed: onEdit,
            ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: "Supprimer",
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Supprimer la note'),
                    content: const Text('Confirmez-vous la suppression de cette note ?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                if (confirm == true && onDelete != null) {
                  onDelete!();
                }
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 2,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                  label: 'Matière',
                  value: grade.subjectName ?? grade.subjectId ?? 'Non renseignée',
                ),
                _buildDetailRow(
                  label: 'Valeur',
                  value: grade.value.toStringAsFixed(2) +
                      (grade.maxValue != null ? ' / ${grade.maxValue}' : ''),
                ),
                if (grade.type != null)
                  _buildDetailRow(label: 'Type', value: grade.type!),
                if (grade.period != null)
                  _buildDetailRow(label: 'Période', value: grade.period!),
                if (grade.comment != null)
                  _buildDetailRow(label: 'Commentaire', value: grade.comment!),
                _buildDetailRow(
                  label: 'Date',
                  value: dateFormat.format(grade.date),
                ),
                if (grade.teacherId != null)
                  _buildDetailRow(label: 'Professeur', value: grade.teacherId!),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: Container()),
                    if (onEdit != null)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text("Modifier"),
                        onPressed: onEdit,
                      ),
                    const SizedBox(width: 12),
                    if (onDelete != null)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                        label: const Text("Supprimer"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[50],
                          foregroundColor: Colors.red,
                        ),
                        onPressed: onDelete,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label :',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}