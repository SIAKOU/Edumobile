/// direct_message_list_screen.dart
/// Affiche la liste des conversations/messages directs. Peut être adaptée pour une messagerie interne scolaire.

// ignore_for_file: dangling_library_doc_comments

import 'package:flutter/material.dart';
import 'package:gestion_ecole/features/messaging/screens/chat_screen.dart';
import 'package:gestion_ecole/features/messaging/widgets/contact_list_tile.dart';

class DirectMessageListScreen extends StatefulWidget {
  const DirectMessageListScreen({Key? key}) : super(key: key);

  @override
  State<DirectMessageListScreen> createState() => _DirectMessageListScreenState();
}

class _DirectMessageListScreenState extends State<DirectMessageListScreen> {
  // Exemple de conversations fictives (remplace par tes données réelles)
  //final List<Contact> _contacts = []; // Liste des contacts (élèves, enseignants, etc.)
  
  final List<Map<String, dynamic>> _conversations = [
    {
      'id': 'dm1',
      'contactName': 'Mme Martin',
      'lastMessage': 'Merci pour votre retour.',
      'lastMessageTime': DateTime(2025, 5, 30, 10, 20),
      'unread': 2,
    },
    {
      'id': 'dm2',
      'contactName': 'M. Dupont',
      'lastMessage': 'OK, à demain !',
      'lastMessageTime': DateTime(2025, 5, 29, 17, 50),
      'unread': 0,
    },
    {
      'id': 'dm3',
      'contactName': 'Mme Faure',
      'lastMessage': 'Le document est bien reçu.',
      'lastMessageTime': DateTime(2025, 5, 28, 9, 5),
      'unread': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages directs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.create),
            tooltip: 'Nouveau message',
            onPressed: () {
              // Naviguer vers l'écran de création de message (à remplacer par ta logique de navigation)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChatScreen(title: 'Nouveau message', threadId: '', recipientId: '',)),
              );
            },
          )
        ],
      ),
      body: ListView.separated(
        itemCount: _conversations.length,
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemBuilder: (context, index) {
          final conv = _conversations[index];
          // Utilisation de ton widget ContactListTile personnalisé
          return ContactListTile(
            contactName: conv['contactName'],
            lastMessage: conv['lastMessage'],
            lastMessageTime: conv['lastMessageTime'],
            unreadCount: conv['unread'],
            avatarText: conv['contactName'][0].toUpperCase(), // Prend la première lettre du nom pour l'avatar
            // avatarUrl: conv['avatarUrl'], // Si tu as une URL d'avatar, sinon laisse comme ça
            leading: CircleAvatar(
              child: Text(conv['contactName'][0].toUpperCase()),
            // Si tu as une image d'avatar, utilise plutôt `backgroundImage: NetworkImage(conv['avatarUrl'])`
            ),
            // trailing: null, // Pas besoin de trailing ici, on gère l'action dans onTap
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    title: conv['contactName'],
                    threadId: conv['id'],
                    recipientId: conv['id'], // remplace par l'id du destinataire réel
                  ),
                ),
              );
            }, trailing: const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}