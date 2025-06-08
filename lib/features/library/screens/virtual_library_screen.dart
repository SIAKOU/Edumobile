import 'package:flutter/material.dart';
import '../widgets/document_card.dart';
import '../widgets/category_filter.dart';

class VirtualLibraryScreen extends StatefulWidget {
  const VirtualLibraryScreen({super.key});

  @override
  State<VirtualLibraryScreen> createState() => _VirtualLibraryScreenState();
}

class _VirtualLibraryScreenState extends State<VirtualLibraryScreen> {
  String _selectedCategory = 'Tous';

  @override
  Widget build(BuildContext context) {
    // TODO: Brancher avec provider/bloc pour la vraie data
    final documents = [
      {'title': 'Cours Maths 1', 'author': 'Mme Dupont', 'category': 'Maths'},
      {'title': 'Physique - Chapitre 3', 'author': 'Mr Martin', 'category': 'Physique'},
      {'title': 'Histoire générale', 'author': 'Mme Leroy', 'category': 'Histoire'},
    ].where((doc) => _selectedCategory == 'Tous' || doc['category'] == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Bibliothèque virtuelle')),
      body: Column(
        children: [
          CategoryFilter(
            selected: _selectedCategory,
            onChanged: (v) => setState(() => _selectedCategory = v),
            categories: const ['Tous', 'Maths', 'Physique', 'Histoire'],
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: documents.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DocumentCard(
                  title: documents[i]['title']!,
                  author: documents[i]['author']!,
                  category: documents[i]['category']!,
                  onTap: () => Navigator.pushNamed(context, '/library/document_viewer', arguments: documents[i]),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/library/upload'),
        tooltip: 'Ajouter un document',
        child: const Icon(Icons.upload_file),
      ),
    );
  }
}