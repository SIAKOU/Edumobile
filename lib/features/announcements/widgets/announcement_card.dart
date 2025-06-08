/// announcement_card.dart
/// Widget d'affichage résumé d'une annonce (AnnouncementModel), à utiliser dans une liste.
/// Personnalise l'affichage ou les actions selon tes besoins.
library;

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/models/announcement_model.dart';
import 'package:intl/intl.dart';
 // Corrige ce chemin selon ton projet

class AnnouncementCard extends StatelessWidget {
  final AnnouncementModel announcement;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AnnouncementCard({
    Key? key,
    required this.announcement,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.announcement, color: Colors.blue),
        title: Text(announcement.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (announcement.content != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  announcement.content!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            Row(
              children: [
                if (announcement.classId != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Chip(
                      label: Text('Classe: ${announcement.classId!}'),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                Text(
                  dateFormat.format(announcement.createdAt),
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
        trailing: _buildActions(context),
        isThreeLine: true,
      ),
    );
  }

  Widget? _buildActions(BuildContext context) {
    if (onEdit == null && onDelete == null) return null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onEdit != null)
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black87, size: 20),
            tooltip: 'Modifier',
            onPressed: onEdit,
          ),
        if (onDelete != null)
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
            tooltip: 'Supprimer',
            onPressed: onDelete,
          ),
      ],
    );
  }
}