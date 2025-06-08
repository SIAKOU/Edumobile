import 'package:flutter/material.dart';

class AiSuggestionChips extends StatelessWidget {
  final List<String> suggestions;
  final void Function(String)? onSuggestionTap;

  const AiSuggestionChips({
    super.key,
    required this.suggestions,
    this.onSuggestionTap, required void Function(dynamic s) onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: suggestions.map((s) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ActionChip(
              label: Text(s),
              onPressed: onSuggestionTap != null ? () => onSuggestionTap!(s) : null,
              backgroundColor: Colors.blue.shade50,
              labelStyle: const TextStyle(color: Colors.black87),
            ),
          );
        }).toList(),
      ),
    );
  }
}