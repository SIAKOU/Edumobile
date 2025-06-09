/// class_repository.dart
/// Dépôt (repository) centralisant la gestion des classes.
/// Sert d'interface entre les services d'API et la couche UI.
/// Gère la récupération, la création, la mise à jour et la suppression des classes.
library;

import 'dart:convert';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/api/api_endpoints.dart';
import 'package:gestion_ecole/core/services/storage_service.dart';

class ClassRepository {
  final ApiClient apiClient;
  final StorageService storageService;

  ClassRepository({
    required this.apiClient,
    required this.storageService,
  });

  /// Récupère la liste des classes
  Future<List<Map<String, dynamic>>> getClasses({required String studentId}) async {
    try {
      final response = await apiClient.get(ApiEndpoints.listClasses);
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

  /// Récupère les détails d'une classe par son ID
  Future<Map<String, dynamic>?> getClassById(String classId) async {
    try {
      final response = await apiClient.get('${ApiEndpoints.classDetail}/$classId');
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      // Log ou gestion d'erreur
    }
    return null;
  }

  /// Crée une nouvelle classe
  Future<bool> createClass(Map<String, dynamic> classData) async {
    try {
      final response = await apiClient.post(ApiEndpoints.listClasses, body: classData);
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      // Log ou gestion d'erreur
      return false;
    }
  }

  /// Met à jour une classe
  Future<bool> updateClass(String classId, Map<String, dynamic> updateData) async {
    try {
      final response = await apiClient.put('${ApiEndpoints.classDetail}/$classId', body: updateData);
      return response.statusCode == 200;
    } catch (e) {
      // Log ou gestion d'erreur
      return false;
    }
  }

  /// Supprime une classe
  Future<bool> deleteClass(String classId) async {
    try {
      final response = await apiClient.delete('${ApiEndpoints.classDetail}/$classId');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      // Log ou gestion d'erreur
      return false;
    }
  }
}