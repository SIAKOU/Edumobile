import 'package:flutter/material.dart';
import 'package:gestion_ecole/features/messaging/widgets/message_status_indicator.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool fromMe;
  final String time;

  const MessageBubble({
    super.key,
    required this.message,
    required this.fromMe,
    required this.time, required status, required MessageStatusIndicator child,
  });

  @override
  Widget build(BuildContext context) {
    final align = fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = fromMe ? Colors.blue.shade100 : Colors.grey.shade200;
    final bg = fromMe ? Colors.blue : Colors.grey.shade400;
    final fg = fromMe ? Colors.white : Colors.black87;

    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: EdgeInsets.only(
            left: fromMe ? 60 : 0,
            right: fromMe ? 0 : 60,
            bottom: 4,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            message,
            style: TextStyle(color: fg, fontSize: 16),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: fromMe ? 60 : 0,
            right: fromMe ? 0 : 60,
          ),
          child: Text(
            time,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ),
      ],
    );
  }
}