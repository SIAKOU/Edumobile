/// chat_repository.dart
/// Dépôt (repository) centralisant la gestion de la messagerie (chat).
/// Sert d'interface entre les services d'API et la couche UI.
/// Gère la récupération des conversations, messages, envoi de messages, etc.
library;

import 'dart:convert';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/storage_service.dart';

class ChatRepository {
  final ApiClient apiClient;
  final StorageService storageService;

  ChatRepository({
    required this.apiClient,
    required this.storageService,
  });

  /// Récupère la liste des conversations pour un utilisateur donné
  Future<List<Map<String, dynamic>>> getConversations(String userId) async {
    try {
      final response = await apiClient.get('/chats/conversations', params: {'userId': userId});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return (data as List).cast<Map<String, dynamic>>();
        } else if (data is Map && data['items'] is List) {
          return (data['items'] as List).cast<Map<String, dynamic>>();
        }
      }
    } catch (e) {
      // Log ou gestion d'erreur
    }
    return [];
  }

  /// Récupère la liste des messages pour une conversation donnée
  Future<List<Map<String, dynamic>>> getMessages(String conversationId) async {
    try {
      final response = await apiClient.get('/chats/messages', params: {'conversationId': conversationId});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return (data as List).cast<Map<String, dynamic>>();
        } else if (data is Map && data['items'] is List) {
          return (data['items'] as List).cast<Map<String, dynamic>>();
        }
      }
    } catch (e) {
      // Log ou gestion d'erreur
    }
    return [];
  }

  /// Envoie un message dans une conversation donnée
  Future<bool> sendMessage(String conversationId, Map<String, dynamic> messageData) async {
    try {
      final body = {
        ...messageData,
        'conversationId': conversationId,
      };
      final response = await apiClient.post('/chats/messages', body: body);
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      // Log ou gestion d'erreur
      return false;
    }
  }
}