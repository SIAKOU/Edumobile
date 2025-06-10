/// chat_screen.dart
/// Écran affichant la conversation (messages) pour un thread direct ou de groupe.
/// Utilise les widgets modulaires du dossier widgets/.
library;

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/messaging_service.dart';
import 'package:gestion_ecole/features/messaging/widgets/message_bubble.dart';
import 'package:gestion_ecole/features/messaging/widgets/chat_input_field.dart';
import 'package:gestion_ecole/features/messaging/widgets/message_status_indicator.dart';

class ChatScreen extends StatefulWidget {
  final String title;
  final String threadId;
  final String recipientId; // Pour les directs, sinon laisse vide ou null
  final MessagingService? messagingService;

  const ChatScreen({
    Key? key,
    required this.title,
    required this.threadId,
    required this.recipientId,
    this.messagingService,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> _messages = [];
  bool _loading = true;
  final ScrollController _scrollController = ScrollController();

  MessagingService get _messagingService =>
      widget.messagingService ??
      MessagingService(
        
        apiClient: ApiClient(baseUrl: 'https://slupfyvmzrmhqxqvpwhy.supabase.co'), // Remplace par ton URL d'API
      );

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    setState(() => _loading = true);
    try {
      final msgs =
          await _messagingService.getMessagesByThreadId(widget.threadId);
      setState(() {
        _messages = msgs;
        _loading = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() => _loading = false);
      // Gère les erreurs si besoin
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final newMsg = {
      'id': tempId,
      'sender': 'Moi',
      'content': text.trim(),
      'time': DateTime.now(),
      'isMe': true,
      'status': 'sending',
    };
    setState(() {
      _messages.add(newMsg);
    });
    _scrollToBottom();

    final sent = await _messagingService.sendMessage(
      widget.threadId,
      text.trim(),
      content: text.trim(),
      recipientId: widget.recipientId,
      extraData: {}, // Ajoute des champs supplémentaires si nécessaire
    );

    setState(() {
      final idx = _messages.indexWhere((m) => m['id'] == tempId);
      if (idx != -1) {
        _messages[idx]['status'] = sent ? 'sent' : 'error';
      }
    });

    // Optionnel : rafraîchit la liste des messages pour récupérer le vrai message du backend
    await _fetchMessages();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: "Infos du groupe ou du contact",
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/messaging/group_info',
                arguments: {
                  'title': widget.title,
                  'threadId': widget.threadId,
                  'recipientId': widget.recipientId,
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                    itemCount: _messages.length,
                    itemBuilder: (ctx, idx) {
                      final message = _messages[_messages.length - 1 - idx];
                      return MessageBubble(
                        key: ValueKey(message['id']),
                        fromMe: message['isMe'] ?? false,
                        message: message['content'] ?? '',
                        time: _formatTime(message['time']),
                        status: message['status'],
                        child: MessageStatusIndicator(status: message['status']),
                      );
                    },
                  ),
          ),
          const Divider(height: 0),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 8, left: 8, right: 8, top: 0),
            child: ChatInputField(
              hintText: "Écrire un message…",
              onSend: _sendMessage,
              onAttach: (file) => {}, // Ajoute la gestion des pièces jointes si besoin
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(dynamic dt) {
    if (dt == null) return '';
    final dateTime = dt is DateTime
        ? dt
        : (dt is String
            ? DateTime.tryParse(dt)
            : null);
    if (dateTime == null) return '';
    final now = DateTime.now();
    if (now.difference(dateTime).inDays == 0) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}';
    }
  }
}