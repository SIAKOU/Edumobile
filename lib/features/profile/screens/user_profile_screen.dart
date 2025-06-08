import 'package:flutter/material.dart';
import '../widgets/profile_header.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Charger les vraies données utilisateur
    final user = {
      'name': 'Jean Dupont',
      'email': 'jean.dupont@email.com',
      'avatarUrl': null,
      'bio': 'Élève en Terminale S',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.pushNamed(context, '/profile/edit'),
            tooltip: 'Modifier',
          ),
        ],
      ),
      body: Column(
        children: [
          ProfileHeader(
            name: user['name']!,
            email: user['email']!,
            avatarUrl: user['avatarUrl'],
            bio: user['bio'],
          ),
          const SizedBox(height: 32),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Sécurité'),
            onTap: () => Navigator.pushNamed(context, '/profile/security'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Paramètres'),
            onTap: () => Navigator.pushNamed(context, '/profile/settings'),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () => Navigator.pushNamed(context, '/profile/notifications'),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('À propos'),
            onTap: () => Navigator.pushNamed(context, '/profile/about'),
          ),
        ],
      ),
    );
  }
}