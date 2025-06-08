/// user_repository.dart
/// Dépôt (repository) centralisant la gestion des utilisateurs.
/// Sert d'interface entre les services d'API et la couche UI.
/// Gère la récupération, la mise à jour, la suppression et la recherche d'utilisateurs.
library;

import 'dart:convert';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/api/api_endpoints.dart';
import 'package:gestion_ecole/core/services/storage_service.dart';
import 'package:flutter/foundation.dart'; // Import pour debugPrint

class UserRepository {
  final ApiClient apiClient;
  final StorageService storageService;

  UserRepository({
    required this.apiClient,
    required this.storageService,
  });

  /// Récupère la liste des utilisateurs (avec pagination et recherche)
  /// Retourne une liste vide en cas d'erreur ou si aucun utilisateur n'est trouvé.
  Future<List<Map<String, dynamic>>> getUsers({
    int? page,
    int? pageSize,
    String? search,
  }) async {
    final params = <String, dynamic>{};
    if (page != null) params['page'] = page.toString(); // Convert int to String for query params
    if (pageSize != null) params['pageSize'] = pageSize.toString(); // Convert int to String for query params
    if (search != null) params['search'] = search;

    try {
      final response = await apiClient.get(ApiEndpoints.users, params: params);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          // Gère le cas où l'API retourne directement une liste
          return (data as List).cast<Map<String, dynamic>>();
        } else if (data is Map && data.containsKey('items') && data['items'] is List) {
          // Gère le cas où l'API retourne un objet avec une clé 'items' contenant la liste (pagination)
          return (data['items'] as List).cast<Map<String, dynamic>>();
        } else {
          // Format de réponse inattendu
          debugPrint('UserRepository: Format de données inattendu pour getUsers: ${response.body}');
          return [];
        }
      } else {
        // Log les codes de statut non réussis
        debugPrint('UserRepository: Échec de la récupération des utilisateurs. Code statut: ${response.statusCode}, Corps: ${response.body}');
        return [];
      }
    } catch (e) {
      // Log les exceptions lors de l'appel API
      debugPrint('UserRepository: Exception lors de la récupération des utilisateurs: $e');
      return [];
    }
  }

  /// Récupère les détails d'un utilisateur par son ID
  /// Retourne null si l'utilisateur n'est pas trouvé ou en cas d'erreur.
  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      final response = await apiClient.get('${ApiEndpoints.users}/$userId');

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 404) {
        // Utilisateur non trouvé
        debugPrint('UserRepository: Utilisateur avec ID $userId non trouvé.');
        return null;
      } else {
        // Log les codes de statut non réussis
        debugPrint('UserRepository: Échec de la récupération de l\'utilisateur $userId. Code statut: ${response.statusCode}, Corps: ${response.body}');
        return null;
      }
    } catch (e) {
      // Log les exceptions lors de l'appel API
      debugPrint('UserRepository: Exception lors de la récupération de l\'utilisateur $userId: $e');
      return null;
    }
  }

  /// Met à jour un utilisateur
  /// Retourne true si la mise à jour est réussie, false sinon.
  Future<bool> updateUser(String userId, Map<String, dynamic> updateData) async {
    try {
      final response = await apiClient.put('${ApiEndpoints.users}/$userId', body: updateData);

      if (response.statusCode == 200) {
        return true;
      } else {
        // Log les codes de statut non réussis
        debugPrint('UserRepository: Échec de la mise à jour de l\'utilisateur $userId. Code statut: ${response.statusCode}, Corps: ${response.body}');
        return false;
      }
    } catch (e) {
      // Log les exceptions lors de l'appel API
      debugPrint('UserRepository: Exception lors de la mise à jour de l\'utilisateur $userId: $e');
      return false;
    }
  }

  /// Supprime un utilisateur
  /// Retourne true si la suppression est réussie, false sinon.
  Future<bool> deleteUser(String userId) async {
    try {
      final response = await apiClient.delete('${ApiEndpoints.users}/$userId');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        // Log les codes de statut non réussis
        debugPrint('UserRepository: Échec de la suppression de l\'utilisateur $userId. Code statut: ${response.statusCode}, Corps: ${response.body}');
        return false;
      }
    } catch (e) {
      // Log les exceptions lors de l'appel API
      debugPrint('UserRepository: Exception lors de la suppression de l\'utilisateur $userId: $e');
      return false;
    }
  }

  /// Crée un nouvel utilisateur (par un admin)
  /// Retourne true si la création est réussie, false sinon.
  Future<bool> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await apiClient.post(ApiEndpoints.users, body: userData);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        // Log les codes de statut non réussis
        debugPrint('UserRepository: Échec de la création de l\'utilisateur. Code statut: ${response.statusCode}, Corps: ${response.body}');
        return false;
      }
    } catch (e) {
      // Log les exceptions lors de l'appel API
      debugPrint('UserRepository: Exception lors de la création de l\'utilisateur: $e');
      return false;
    }
  }

  /// Récupère l'utilisateur actuellement connecté (depuis le stockage local)
  /// Retourne null si aucun utilisateur n'est stocké localement ou si les données sont invalides.
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final userStr = storageService.getString('user');
      if (userStr == null || userStr.isEmpty) {
        debugPrint('UserRepository: Aucun utilisateur trouvé dans le stockage local.');
        return null;
      }
      // Assurez-vous que la chaîne est un JSON valide avant de décoder
      return jsonDecode(userStr) as Map<String, dynamic>;
    } catch (e) {
      // Log les exceptions lors de la lecture ou du décodage
      debugPrint('UserRepository: Exception lors de la récupération de l\'utilisateur local: $e');
      return null;
    }
  }
}
