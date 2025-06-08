import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Brancher avec la vraie gestion de langue
    return DropdownButton<String>(
      value: 'Français',
      underline: Container(),
      items: const [
        DropdownMenuItem(value: 'Français', child: Text('🇫🇷 Français')),
        DropdownMenuItem(value: 'Anglais', child: Text('🇬🇧 Anglais')),
      ],
      onChanged: (v) {
        // TODO: Changer la langue de l'app
      },
    );
  }
}