import 'package:flutter/material.dart';
import '../widgets/ai_message_bubble.dart';
import '../widgets/ai_loading_indicator.dart';
import '../widgets/ai_suggestion_chips.dart';
import 'package:gestion_ecole/core/services/gemini_service.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final List<Map<String, dynamic>> _messages = [
    {'fromMe': false, 'text': 'Bonjour, comment puis-je t’aider ?'},
  ];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _loading = false;

  // Instancie ton service Gemini (remplace la clé par la tienne si besoin)
  final GeminiService _geminiService = GeminiService(
    apiKey: 'AIzaSyCD4cqiERSXClLHWZX1WdMaQnn3YgeviCw', // Remplace par ta clé réelle
    model: 'gemini-2.0-flash', // ou 'gemini-pro'
    apiUrl: 'https://generativelanguage.googleapis.com/v1beta/models',
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Récupère le prompt initial si passé en argument
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final initialPrompt = args?['initialPrompt'] as String?;
    if (initialPrompt != null && _messages.length == 1) {
      Future.microtask(() => _sendMessage(initialPrompt));
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({'fromMe': true, 'text': text});
      _loading = true;
    });
    _controller.clear();
    _scrollToBottom();

    // Construit l'historique pour Gemini (sauf le message en cours)
    final history = _messages
        .where((m) => m['fromMe'] != null)
        .map<Map<String, String>>((m) => {
              'role': m['fromMe'] ? 'user' : 'model',
              'content': m['text'] ?? '',
            })
        .toList();

    String aiResponse;
    try {
 aiResponse = await _geminiService.sendMessage(text, history: history);
    } catch (e) {
      aiResponse = 'Erreur lors de la communication avec Gemini : $e';
    }

    setState(() {
      _messages.add({'fromMe': false, 'text': aiResponse});
      _loading = false;
    });
    _scrollToBottom();
  }

  void _onSuggestionTap(String suggestion) {
    _sendMessage(suggestion);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat IA')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_loading ? 1 : 0),
              itemBuilder: (_, i) {
                if (_loading && i == _messages.length) {
                  return const AiLoadingIndicator();
                }
                final msg = _messages[i];
                return AiMessageBubble(
                  message: msg['text'],
                  fromMe: msg['fromMe'],
                );
              },
            ),
          ),
          AiSuggestionChips(
            suggestions: const [
              'Explique la photosynthèse',
              'Quels sont mes prochains cours ?',
              'Résumé du chapitre 2 de physique',
            ],
            onSelected: (s) => _onSuggestionTap(s as String),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 5,
                    enabled: !_loading,
                    decoration: const InputDecoration(
                      hintText: 'Écris ta question...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (v) {
                      if (v.trim().isNotEmpty && !_loading) {
                        _sendMessage(v.trim());
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _loading
                      ? null
                      : () {
                          final text = _controller.text.trim();
                          if (text.isNotEmpty) _sendMessage(text);
                        },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
