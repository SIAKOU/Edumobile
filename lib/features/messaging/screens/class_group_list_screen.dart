/// class_group_list_screen.dart
/// Affiche la liste des groupes de discussion de classes.
/// Permet d'accéder à la conversation de groupe, d'en créer ou de rechercher.
library;

import 'package:flutter/material.dart';
import 'package:gestion_ecole/features/messaging/screens/chat_screen.dart';
import 'package:gestion_ecole/features/messaging/screens/create_group_screen.dart';
import 'package:gestion_ecole/features/messaging/widgets/GroupCard.dart';
import 'package:gestion_ecole/features/messaging/widgets/SearchField.dart';
//<-- à créer si besoin

class ClassGroupListScreen extends StatefulWidget {
  const ClassGroupListScreen({Key? key}) : super(key: key);

  @override
  State<ClassGroupListScreen> createState() => _ClassGroupListScreenState();
}

class _ClassGroupListScreenState extends State<ClassGroupListScreen> {
  final List<Map<String, dynamic>> _groups = [
    {
      'id': 'g1',
      'groupName': 'Terminale S1',
      'lastMessage': 'Rappel: DS de maths lundi à 9h.',
      'lastMessageTime': DateTime(2025, 5, 30, 7, 50),
      'unread': 5,
      'members': 32,
    },
    {
      'id': 'g2',
      'groupName': 'Seconde A',
      'lastMessage': 'Photo de classe demain.',
      'lastMessageTime': DateTime(2025, 5, 29, 12, 15),
      'unread': 0,
      'members': 28,
    },
    {
      'id': 'g3',
      'groupName': '1ère D Parents-Profs',
      'lastMessage': 'Réunion prévue mardi soir.',
      'lastMessageTime': DateTime(2025, 5, 28, 18, 0),
      'unread': 3,
      'members': 54,
    },
  ];

  String _search = '';

  @override
  Widget build(BuildContext context) {
    final filteredGroups = _groups.where((g) {
      if (_search.isEmpty) return true;
      return g['groupName']
          .toString()
          .toLowerCase()
          .contains(_search.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Groupes de classe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.group_add),
            tooltip: 'Créer un groupe',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateGroupScreen()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Utilise un SearchField commun si tu l'as, sinon garde le TextField d'origine
          Padding(
            padding: const EdgeInsets.all(12),
            child: SearchField(
              hintText: 'Rechercher un groupe...',
              onChanged: (val) => setState(() => _search = val),
            ),
          ),
          Expanded(
            child: filteredGroups.isEmpty
                ? const Center(child: Text('Aucun groupe trouvé.'))
                : ListView.separated(
                    itemCount: filteredGroups.length,
                    separatorBuilder: (_, __) => const Divider(height: 0),
                    itemBuilder: (context, index) {
                      final grp = filteredGroups[index];
                      // Utilise ton widget GroupCard si tu en as un !
                      return GroupCard(
                        groupName: grp['groupName'],
                        lastMessage: grp['lastMessage'],
                        lastMessageTime: grp['lastMessageTime'],
                        unreadCount: grp['unread'],
                        memberCount: grp['members'],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                title: grp['groupName'],
                                threadId: grp['id'],
                                recipientId: '', // vide pour un groupe
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}



