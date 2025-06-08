/// announcements_screen.dart
/// Affiche la liste des annonces pour une classe ou un groupe.
/// Peut être adaptée pour la gestion par les enseignants/admins (CRUD).

// ignore_for_file: dangling_library_doc_comments

import 'package:flutter/material.dart';
import 'package:gestion_ecole/app/config/app_routes.dart';
import 'package:gestion_ecole/core/models/announcement_model.dart';
import 'package:gestion_ecole/features/announcements/screens/announcement_detail_screen.dart';
import 'package:gestion_ecole/core/services/announcement_service.dart';
import 'package:go_router/go_router.dart';

class AnnouncementsScreen extends StatefulWidget {
  final String classId; // Pour filtrer les annonces par classe

  const AnnouncementsScreen({super.key, required this.classId});
  //const AnnouncementsScreen({Key? key}) : super(key: key);

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  bool _isLoading = false;
  String? _error;
  List<AnnouncementModel> _announcements = [];

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
  }

  Future<void> _fetchAnnouncements() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      _announcements =
          await AnnouncementService.instance.getForClass(widget.classId);
      await Future.delayed(const Duration(seconds: 1)); // Simulation chargement
      setState(() {});
    } catch (e) {
      setState(() {
        _error = "Erreur lors du chargement des annonces : $e";
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _goToCreateAnnouncement() {
    context.goNamed(
      AppRouteNames.createAnnouncement,
      extra: {'classId': widget.classId},
    );
  }

  @override
  Widget build(BuildContext context) {
    // Exemple d'annonces fictives
    final exampleAnnouncements = [
      {
        'title': 'Contrôle de mathématiques',
        'content': 'Un contrôle aura lieu le vendredi 7 juin à 10h.',
        'date': '2025-05-28',
        'author': 'M. Dupont',
      },
      {
        'title': 'Sortie scolaire',
        'content':
            'Sortie prévue le mardi 17 juin, pensez à rendre l\'autorisation signée.',
        'date': '2025-05-29',
        'author': 'Mme Martin',
      },
      // ...
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Annonces'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchAnnouncements,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCreateAnnouncement,
        tooltip: 'Nouvelle annonce',
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child:
                      Text(_error!, style: const TextStyle(color: Colors.red)))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: exampleAnnouncements.length,
                  separatorBuilder: (_, __) => const Divider(height: 24),
                  itemBuilder: (context, index) {
                    final ann = exampleAnnouncements[index];
                    return Card(
                      elevation: 2,
                      child: ListTile(
                        leading: const Icon(Icons.announcement),
                        title: Text('${ann['title']}'),
                        subtitle: Text(
                          '${ann['content']}\n'
                          'Le ${ann['date']} — ${ann['author']}',
                        ),
                        isThreeLine: true,
                        onTap: () {
                          // Afficher détail/modifier/supprimer si besoin
                          final announcementModel = AnnouncementModel(
                            title: ann['title'] ?? '',
                            content: ann['content'] ?? '',
                            authorId: '', // ID de l'auteur si disponible
                            classId: widget.classId, // Classe associée
                            createdAt: DateTime.now(),
                            id: '', // Simuler une date de création
                          );
                          context.pushNamed(
                            AppRouteNames.announcementDetail,
                            extra: announcementModel,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Détail de l\'annonce : ${ann['title']}')),
                          );
                          Navigator.pushNamed(context, '/announcement_detail',
                              arguments: announcementModel);
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
