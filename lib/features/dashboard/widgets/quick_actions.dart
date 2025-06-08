/// quick_actions.dart
/// Widget pour les raccourcis du dashboard administrateur (ex : bibliothèque, assistant IA, paiements…)
library;

import 'package:flutter/material.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback? onFilesTap;
  final VoidCallback? onAiAssistantTap;
  final VoidCallback? onPaymentsTap;
  final VoidCallback? onAttendanceTap;
  final VoidCallback? onScheduleTap;
  final VoidCallback? onChatTap; // Action supplémentaire éventuelle (optionnel)

  const QuickActions({
    Key? key,
    this.onFilesTap,
    this.onAiAssistantTap,
    this.onPaymentsTap,
    this.onAttendanceTap,
    this.onScheduleTap,
    this.onChatTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ajoute ici plus d'actions si besoin (ex: chat, settings...)
    final List<_QuickActionItem> actions = [
      _QuickActionItem(
        icon: Icons.folder,
        label: 'Bibliothèque',
        onTap: onFilesTap,
        color: Colors.blueAccent,
      ),
      _QuickActionItem(
        icon: Icons.assistant,
        label: 'Assistant IA',
        onTap: onAiAssistantTap,
        color: Colors.deepPurple,
      ),
      _QuickActionItem(
        icon: Icons.payment,
        label: 'Paiements',
        onTap: onPaymentsTap,
        color: Colors.green,
      ),
      _QuickActionItem(
        icon: Icons.check_circle,
        label: 'Présence',
        onTap: onAttendanceTap,
        color: Colors.orange,
      ),
      _QuickActionItem(
        icon: Icons.schedule,
        label: 'Emploi du temps',
        onTap: onScheduleTap,
        color: Colors.teal,
      ),
      if (onChatTap != null)
        _QuickActionItem(
          icon: Icons.chat,
          label: 'Chat',
          onTap: onChatTap,
          color: Colors.indigo,
        ),
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.8),
      margin: EdgeInsets.zero,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: actions
              .map(
                (a) => Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: a.onTap,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundColor: a.color.withOpacity(0.13),
                            child: Icon(a.icon, color: a.color),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            a.label,
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _QuickActionItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color color;

  _QuickActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });
}