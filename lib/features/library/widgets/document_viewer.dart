import 'package:flutter/material.dart';

class DocumentViewer extends StatelessWidget {
  final String title;
  final String author;
  final String url; // Lien vers le fichier/document

  const DocumentViewer({
    super.key,
    required this.title,
    required this.author,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Utiliser un vrai PDF viewer ou WebView si url est fourni
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        Text('Auteur : $author', style: Theme.of(context).textTheme.bodyMedium),
        const Divider(height: 24),
        Expanded(
          child: Center(
            child: url.isEmpty
                ? const Text('Aperçu du document indisponible.')
                : const Icon(Icons.picture_as_pdf, size: 100, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}