/// group_info_screen.dart
/// Écran d'informations sur un groupe de discussion scolaire.
/// Affiche le nom du groupe, les membres, et permet éventuellement de quitter le groupe ou de le modifier (si admin).
library;

import 'package:flutter/material.dart';
import 'package:gestion_ecole/features/messaging/widgets/group_member_chip.dart';

class GroupInfoScreen extends StatelessWidget {
  final String groupName;
  final List<Map<String, dynamic>> members;
  final bool isAdmin;
  final VoidCallback? onEditGroup;
  final VoidCallback? onLeaveGroup;

  const GroupInfoScreen({
    Key? key,
    required this.groupName,
    required this.members,
    this.isAdmin = false,
    this.onEditGroup,
    this.onLeaveGroup,
  }) : super(key: key);

  // Pour simuler l'appel, tu peux faire un constructeur named :
  // GroupInfoScreen.mock() : this(groupName: ..., members: [...], isAdmin: ...);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(groupName),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: "Modifier le groupe",
              onPressed: onEditGroup ??
                  () {
                    // Naviguer vers l'écran d'édition du groupe si besoin
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fonction modifier (à implémenter)")));
                  },
            ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: "Quitter le groupe",
            onPressed: onLeaveGroup ??
                () {
                  // Gestion de la sortie du groupe
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Quitter le groupe ?"),
                      content: const Text("Êtes-vous sûr de vouloir quitter ce groupe ?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text("Annuler"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            Navigator.of(context).pop(); // Retour
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Vous avez quitté le groupe.")),
                            );
                          },
                          child: const Text("Quitter"),
                        ),
                      ],
                    ),
                  );
                },
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.group)),
            title: Text(groupName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            subtitle: Text("${members.length} membre${members.length > 1 ? 's' : ''}"),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Membres du groupe",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          Expanded(
            child: members.isEmpty
                ? const Center(child: Text("Aucun membre dans ce groupe"))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    itemCount: members.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final m = members[i];
                      return GroupMemberChip(
                        name: m['name'] ?? '',
                        avatarUrl: m['avatar'],
                        isAdmin: m['isAdmin'] ?? false,
                        // Ajoute des actions si besoin
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}