import 'package:flutter/material.dart';

enum MessageStatus { sent, delivered, read }

class MessageStatusIndicator extends StatelessWidget {
  final MessageStatus status;

  const MessageStatusIndicator({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (status) {
      case MessageStatus.sent:
        icon = Icons.check;
        color = Colors.grey;
        break;
      case MessageStatus.delivered:
        icon = Icons.done_all;
        color = Colors.blueGrey;
        break;
      case MessageStatus.read:
        icon = Icons.done_all;
        color = Colors.blue;
        break;
    }

    return Icon(icon, size: 18, color: color);
  }
}