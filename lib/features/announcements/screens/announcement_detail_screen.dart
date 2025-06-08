/// announcement_detail_screen.dart
/// Affiche le détail d'une annonce (AnnouncementModel), possibilité d'éditer ou supprimer si autorisé.

// ignore_for_file: dangling_library_doc_comments

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/models/announcement_model.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


class AnnouncementDetailScreen extends StatelessWidget {
  final AnnouncementModel announcement;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AnnouncementDetailScreen({
    Key? key,
    required this.announcement,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail de l\'annonce'),
        actions: [
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Modifier',
              onPressed: onEdit,
            ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Supprimer',
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Supprimer cette annonce'),
                    content: const Text('Confirmez-vous la suppression de cette annonce ?'),
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
        padding: const EdgeInsets.all(22.0),
        child: Card(
          elevation: 2,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  announcement.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                if (announcement.content != null)
                  Text(
                    announcement.content!,
                    style: const TextStyle(fontSize: 16),
                  ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  label: 'Créée le',
                  value: dateFormat.format(announcement.createdAt),
                ),
                if (announcement.publishedAt != null)
                  _buildDetailRow(
                    label: 'Publiée le',
                    value: dateFormat.format(announcement.publishedAt!),
                  ),
                if (announcement.updatedAt != null)
                  _buildDetailRow(
                    label: 'Modifiée le',
                    value: dateFormat.format(announcement.updatedAt!),
                  ),
                if (announcement.authorId != null)
                  _buildDetailRow(
                    label: 'Auteur',
                    value: announcement.authorId!, // À remplacer par le nom si dispo
                  ),
                if (announcement.classId != null)
                  _buildDetailRow(
                    label: 'Classe',
                    value: announcement.classId!,
                  ),
                if (announcement.attachments != null && announcement.attachments!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Pièces jointes :', style: TextStyle(fontWeight: FontWeight.w600)),
                        ...announcement.attachments!.map((url) => InkWell(
                              onTap: () {
                                // Ouvre l'URL dans le navigateur ou l'application par défaut
                                launch(url);
                                if (kDebugMode) {
                                  print('Ouvrir l\'URL: $url');
                                } // Remplace par la logique d'ouverture
                                
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Text(
                                  url,
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
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