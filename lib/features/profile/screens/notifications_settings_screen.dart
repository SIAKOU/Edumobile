import 'package:flutter/material.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  bool _notifGeneral = true;
  bool _notifMessages = true;
  bool _notifReminders = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          SwitchListTile(
            value: _notifGeneral,
            title: const Text('Notifications générales'),
            onChanged: (v) => setState(() => _notifGeneral = v),
          ),
          SwitchListTile(
            value: _notifMessages,
            title: const Text('Messages'),
            onChanged: (v) => setState(() => _notifMessages = v),
          ),
          SwitchListTile(
            value: _notifReminders,
            title: const Text('Rappels'),
            onChanged: (v) => setState(() => _notifReminders = v),
          ),
        ],
      ),
    );
  }
}