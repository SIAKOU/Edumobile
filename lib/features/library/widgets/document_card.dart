import 'package:flutter/material.dart';

class DocumentCard extends StatelessWidget {
  final String title;
  final String author;
  final String category;
  final VoidCallback? onTap;

  const DocumentCard({
    super.key,
    required this.title,
    required this.author,
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.picture_as_pdf),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Auteur : $author\nCatégorie : $category'),
        onTap: onTap,
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}