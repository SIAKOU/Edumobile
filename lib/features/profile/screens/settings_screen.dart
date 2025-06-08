import 'package:flutter/material.dart';
import '../widgets/setting_item.dart';
import '../widgets/language_selector.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SettingItem(
            icon: Icons.language,
            title: 'Langue',
            trailing: const LanguageSelector(),
          ),
          const Divider(),
          SettingItem(
            icon: Icons.lock,
            title: 'Sécurité',
            onTap: () => Navigator.pushNamed(context, '/profile/security'),
          ),
          SettingItem(
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () => Navigator.pushNamed(context, '/profile/notifications'),
          ),
          SettingItem(
            icon: Icons.info,
            title: 'À propos',
            onTap: () => Navigator.pushNamed(context, '/profile/about'),
          ),
        ],
      ),
    );
  }
}