/// messaging_service.dart
/// Service pour la gestion de la messagerie (envoi, récupération de messages, gestion des conversations, etc.)
/// Utilise ApiClient pour les appels réseau. À adapter selon la structure de vos endpoints.
library;

import 'dart:convert';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/api/api_endpoints.dart';



class MessagingService {
  final ApiClient apiClient;

  MessagingService({required this.apiClient});

  /// Récupère la liste des conversations de l'utilisateur (threads)
  Future<List<Map<String, dynamic>>> getMessageThreads() async {
    final response = await apiClient.get(ApiEndpoints.messageThreads);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return (data as List).cast<Map<String, dynamic>>();
      } else if (data is Map && data['items'] is List) {
        return (data['items'] as List).cast<Map<String, dynamic>>();
      }
    }
    return [];
  }

  /// Récupère les messages d'une conversation (thread) par ID
  Future<List<Map<String, dynamic>>> getMessagesByThreadId(String threadId) async {
    final response = await apiClient.get('${ApiEndpoints.messageThreads}/$threadId');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return (data as List).cast<Map<String, dynamic>>();
      } else if (data is Map && data['messages'] is List) {
        return (data['messages'] as List).cast<Map<String, dynamic>>();
      }
    }
    return [];
  }

  /// Envoie un message (nouveau ou dans une conversation existante)
  // ignore: strict_top_level_inference
  Future<bool> sendMessage(threadId, String trim, {
    required String content,
    required String recipientId,
    Map<String, dynamic>? extraData,
  }) async {
    final messageData = {
      'content': content,
      'recipient_id': recipientId,
      if (threadId != null) 'thread_id': threadId,
      if (extraData != null) ...extraData,
    };
    final response = await apiClient.post(ApiEndpoints.sendMessage, body: messageData);
    return response.statusCode == 201 || response.statusCode == 200;
  }


  /// Crée un nouveau groupe de discussion
  Future<bool> createGroup(String groupName, List<String> memberIds) async {
    final groupData = {
      'group_name': groupName,
      'members': memberIds,
    };
    final response = await apiClient.post(ApiEndpoints.createGroup, body: groupData);
    return response.statusCode == 201 || response.statusCode == 200;
  }
}