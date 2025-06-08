import 'package:flutter/material.dart';

class NewMessageScreen extends StatelessWidget {
  const NewMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Récupérer la liste réelle des contacts
    final contacts = [
      {'name': 'Alice'},
      {'name': 'Bob'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau message')),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (_, i) => ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(contacts[i]['name']!),
          onTap: () {
            Navigator.pushNamed(context, '/messaging/chat', arguments: contacts[i]);
          },
        ),
      ),
    );
  }
}