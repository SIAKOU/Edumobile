// ignore_for_file: slash_for_doc_comments

/**
 * schedule_details_screen.dart
 * Affiche le détail d'un créneau de l'emploi du temps (Schedule/Event).
 * À utiliser pour voir/modifier/supprimer un créneau horaire.
 */

// ignore_for_file: dangling_library_doc_comments

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/models/schedule_model.dart';

class ScheduleDetailsScreen extends StatelessWidget {
  //final ScheduleModel schedule;
  final Map<String, String> schedule; // Remplace par ScheduleModel en prod
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ScheduleDetailsScreen({
    Key? key,
    required this.schedule,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Exemple d'attributs, adapte selon ton modèle ScheduleModel
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail du créneau'),
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
                    title: const Text('Supprimer ce créneau'),
                    content: const Text('Confirmez-vous la suppression de ce créneau ?'),
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
                _buildDetailRow(label: 'Jour', value: schedule['day'] ?? '-'),
                _buildDetailRow(label: 'Début', value: schedule['start'] ?? '-'),
                _buildDetailRow(label: 'Fin', value: schedule['end'] ?? '-'),
                _buildDetailRow(label: 'Matière', value: schedule['subject'] ?? '-'),
                _buildDetailRow(label: 'Professeur', value: schedule['teacher'] ?? '-'),
                _buildDetailRow(label: 'Salle', value: schedule['room'] ?? '-'),
                if (schedule['comment'] != null)
                  _buildDetailRow(label: 'Commentaire', value: schedule['comment']!),
                const SizedBox(height: 20),
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