/// create_group_screen.dart
/// Écran de création d'un nouveau groupe de discussion.
/// Permet de nommer le groupe et de sélectionner des membres.

// ignore_for_file: use_build_context_synchronously, dangling_library_doc_comments, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/messaging_service.dart';
import 'package:gestion_ecole/features/messaging/widgets/contact_list_tile.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _groupNameController = TextEditingController();

  // Remplacer cette liste par un provider/service dans une vraie app
  final List<Map<String, dynamic>> _allContacts = [
    {'id': 'u1', 'name': 'Alice Dupuis'},
    {'id': 'u2', 'name': 'Bob Martin'},
    {'id': 'u3', 'name': 'Mme Faure'},
    {'id': 'u4', 'name': 'M. Durand'},
  ];

  final Set<String> _selectedMembers = {};

  bool _creating = false;

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  void _toggleMember(String memberId) {
    setState(() {
      if (_selectedMembers.contains(memberId)) {
        _selectedMembers.remove(memberId);
      } else {
        _selectedMembers.add(memberId);
      }
    });
  }

  Future<void> _createGroup() async {
    if (!_formKey.currentState!.validate() || _selectedMembers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez nommer le groupe et sélectionner au moins un membre.")),
      );
      return;
    }

    setState(() => _creating = true);

    final groupName = _groupNameController.text.trim();
    final members = _selectedMembers.toList();

    try {
      // Appelle le provider/service pour créer le groupe
      final apiClient = ApiClient(baseUrl: ''); // Assurez-vous d'importer la classe ApiClient appropriée
      final messagingService = MessagingService(apiClient: apiClient);
      final bool result = await messagingService.createGroup(groupName, members);

      if (result) {
        // Affiche une confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Groupe "$groupName" créé avec ${members.length} membre(s)')),
        );
        Navigator.pop(context); // Retourne à l'écran précédent
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de la création du groupe.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    } finally {
      setState(() => _creating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un groupe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Créer',
            onPressed: _creating ? null : _createGroup,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _groupNameController,
                decoration: const InputDecoration(
                  labelText: "Nom du groupe",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.group),
                ),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? "Nom requis" : null,
                enabled: !_creating,
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Sélectionner les membres",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _allContacts.isEmpty
                    ? const Center(child: Text("Aucun contact disponible"))
                    : ListView.separated(
                        itemCount: _allContacts.length,
                        separatorBuilder: (_, __) => const Divider(height: 0),
                        itemBuilder: (_, i) {
                          final c = _allContacts[i];
                          final selected = _selectedMembers.contains(c['id']);
                          // Utilise ContactListTile avec Checkbox pour la sélection
                          return ContactListTile(
                            avatarText: _getInitials(c['name']),
                            contactName: c['name'],
                            lastMessage: '',
                            lastMessageTime: DateTime.now().toString(),
                            unreadCount: 0,
                            trailing: Checkbox(
                              value: selected,
                              onChanged: _creating
                                  ? null
                                  : (_) => _toggleMember(c['id']),
                            ),
                            onTap: _creating
                                ? null
                                : () => _toggleMember(c['id']), 
                            leading: CircleAvatar(
                              child: Text(
                                _getInitials(c['name']),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Colors.blueAccent,
                            ),  
                          );
                        },
                      ),
              ),
              if (_creating)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return parts.take(2).map((e) => e[0].toUpperCase()).join();
  }
}