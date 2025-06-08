/// grade_item.dart
/// Widget d'affichage résumé d'une note (GradeModel), utilisable dans une liste.
/// Appel d'un callback (onTap) pour afficher le détail ou éditer la note.

// ignore_for_file: dangling_library_doc_comments

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/models/grade_model.dart';
import 'package:intl/intl.dart';

class GradeItem extends StatelessWidget {
  final GradeModel grade;
  final VoidCallback? onTap;

  const GradeItem({
    Key? key,
    required this.grade,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMd('fr_FR');
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.blue[50],
          child: Text(
            (grade.subjectName?.isNotEmpty == true
                    ? grade.subjectName![0]
                    : (grade.subjectId?.isNotEmpty == true
                        ? grade.subjectId![0]
                        : '?'))
                .toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          grade.subjectName ?? grade.subjectId ?? 'Matière inconnue',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Note : ${grade.value.toStringAsFixed(2)}${grade.maxValue != null ? ' / ${grade.maxValue}' : ''}',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            if (grade.type != null)
              Text('Type : ${grade.type!}'),
            if (grade.period != null)
              Text('Période : ${grade.period!}'),
            if (grade.date != null)
              Text('Date : ${dateFormat.format(grade.date)}'),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}