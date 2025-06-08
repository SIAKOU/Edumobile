import 'package:flutter/material.dart';

class AiMessageBubble extends StatelessWidget {
  final String message;
  final bool fromMe;

  const AiMessageBubble({
    super.key,
    required this.message,
    required this.fromMe,
  });

  @override
  Widget build(BuildContext context) {
    final align = fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bgColor = fromMe ? Colors.blue : Colors.grey.shade200;
    final fgColor = fromMe ? Colors.white : Colors.black87;

    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: EdgeInsets.only(
            left: fromMe ? 60 : 0,
            right: fromMe ? 0 : 60,
            bottom: 8,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            message,
            style: TextStyle(color: fgColor, fontSize: 16),
          ),
        ),
      ],
    );
  }
}