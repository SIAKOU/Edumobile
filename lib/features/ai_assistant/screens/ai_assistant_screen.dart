
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/ai_suggestion_chips.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _startChat({String? initialPrompt, bool forceEmpty = false}) {
    final prompt = initialPrompt ?? _controller.text.trim();
    if (!forceEmpty && prompt.isEmpty) return;
    // Utiliser GoRouter pour la navigation
    context.pushNamed( // ou context.goNamed si vous ne voulez pas de pile de navigation
      'aiChat', // Nom de la route défini dans app_routes.dart
      extra: prompt.isNotEmpty ? {'initialPrompt': prompt} : null,
    );
    _controller.clear();
    _focusNode.unfocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isInputNotEmpty = _controller.text.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistant IA'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Posez vos questions ou choisissez une suggestion pour démarrer une conversation avec l\'assistant IA.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            AiSuggestionChips(
              suggestions: const [
                'Donne-moi un résumé du cours de maths',
                'Quels sont mes devoirs à faire ?',
                'Explique-moi la loi d’Ohm',
              ],
              onSelected: (s) => _startChat(initialPrompt: s),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                        hintText: "Posez une question à l'IA...",
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) _startChat();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    tooltip: "Envoyer à l'IA",
                    onPressed: isInputNotEmpty ? () => _startChat() : null,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Démarrer une discussion'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                // forceEmpty = true => autorise la navigation même si le champ est vide
                onPressed: () => _startChat(forceEmpty: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
