import 'package:flutter/material.dart';
import '../widgets/document_card.dart';

class SearchDocumentsScreen extends StatefulWidget {
  const SearchDocumentsScreen({super.key});

  @override
  State<SearchDocumentsScreen> createState() => _SearchDocumentsScreenState();
}

class _SearchDocumentsScreenState extends State<SearchDocumentsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    // TODO: Brancher la recherche réelle
    final allDocs = [
      {'title': 'Cours Maths 1', 'author': 'Mme Dupont', 'category': 'Maths'},
      {'title': 'Physique - Chapitre 3', 'author': 'Mr Martin', 'category': 'Physique'},
      {'title': 'Histoire générale', 'author': 'Mme Leroy', 'category': 'Histoire'},
    ];
    final results = allDocs
        .where((doc) => _query.isEmpty || doc['title']!.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Rechercher un document')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Recherche',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: results.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DocumentCard(
                  title: results[i]['title']!,
                  author: results[i]['author']!,
                  category: results[i]['category']!,
                  onTap: () => Navigator.pushNamed(context, '/library/document_viewer', arguments: results[i]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}