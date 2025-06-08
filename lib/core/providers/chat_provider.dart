/// chat_provider.dart
/// Provider (ChangeNotifier) pour gérer l'état de la messagerie (chat) dans l'application.
/// Utilise ChatRepository pour effectuer les opérations backend et expose l'état à la couche UI.
/// Permet de charger les conversations, envoyer/recevoir des messages, etc.
library;

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/repositories/chat_repository.dart';


enum ChatStatus { initial, loading, loaded, error }

class ChatProvider extends ChangeNotifier {
  final ChatRepository chatRepository;

  ChatStatus _status = ChatStatus.initial;
  List<Map<String, dynamic>> _conversations = [];
  List<Map<String, dynamic>> _messages = [];
  Map<String, dynamic>? _selectedConversation;
  String? _errorMessage;

  ChatProvider({required this.chatRepository});

  ChatStatus get status => _status;
  List<Map<String, dynamic>> get conversations => _conversations;
  List<Map<String, dynamic>> get messages => _messages;
  Map<String, dynamic>? get selectedConversation => _selectedConversation;
  String? get errorMessage => _errorMessage;

  /// Charge la liste des conversations pour un utilisateur donné
  Future<void> loadConversations(String userId) async {
    _status = ChatStatus.loading;
    notifyListeners();
    try {
      _conversations = await chatRepository.getConversations(userId);
      _status = ChatStatus.loaded;
    } catch (e) {
      _status = ChatStatus.error;
      _errorMessage = "Erreur lors du chargement des conversations.";
    }
    notifyListeners();
  }

  /// Charge les messages d'une conversation donnée
  Future<void> loadMessages(String conversationId) async {
    _status = ChatStatus.loading;
    notifyListeners();
    try {
      _messages = await chatRepository.getMessages(conversationId);
      _status = ChatStatus.loaded;
    } catch (e) {
      _status = ChatStatus.error;
      _errorMessage = "Erreur lors du chargement des messages.";
    }
    notifyListeners();
  }

  /// Envoie un message dans une conversation
  Future<bool> sendMessage(String conversationId, Map<String, dynamic> messageData) async {
    _status = ChatStatus.loading;
    notifyListeners();
    try {
      final success = await chatRepository.sendMessage(conversationId, messageData);
      if (success) {
        await loadMessages(conversationId);
        _status = ChatStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = ChatStatus.error;
        _errorMessage = "L'envoi du message a échoué.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = ChatStatus.error;
      _errorMessage = "Erreur lors de l'envoi du message.";
      notifyListeners();
      return false;
    }
  }

  /// Sélectionne une conversation et charge ses messages
  Future<void> selectConversation(String conversationId) async {
    _selectedConversation = _conversations.firstWhere(
      (c) => c['id'] == conversationId,
      orElse: () => {},
    );
    await loadMessages(conversationId);
    notifyListeners();
  }
}