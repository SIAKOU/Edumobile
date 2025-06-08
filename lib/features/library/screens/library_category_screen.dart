import 'package:flutter/material.dart';

class LibraryCategoryScreen extends StatelessWidget {
  final String category;
  const LibraryCategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // TODO: Charger la vraie liste de documents de la catégorie
    final documents = [
      {'title': 'Cours Maths 1', 'author': 'Mme Dupont'},
      {'title': 'Exercices Maths', 'author': 'Mme Dupont'},
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Catégorie : $category')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: documents.length,
        itemBuilder: (_, i) => ListTile(
          title: Text(documents[i]['title']!),
          subtitle: Text('Auteur : ${documents[i]['author']}'),
          onTap: () => Navigator.pushNamed(context, '/library/document_viewer', arguments: documents[i]),
        ),
      ),
    );
  }
}