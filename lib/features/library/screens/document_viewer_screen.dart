import 'package:flutter/material.dart';
import '../widgets/document_viewer.dart';

class DocumentViewerScreen extends StatelessWidget {
  final Map<String, dynamic> document;
  const DocumentViewerScreen({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    // TODO: document['url'] pour le vrai viewer
    return Scaffold(
      appBar: AppBar(title: Text(document['title'] ?? 'Document')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DocumentViewer(
          title: document['title'] ?? '',
          author: document['author'] ?? '',
          url: document['url'] ?? '',
        ),
      ),
    );
  }
}