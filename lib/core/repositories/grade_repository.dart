/// grade_repository.dart
/// Dépôt (repository) centralisant la gestion des notes (grades).
/// Sert d'interface entre les services d'API et la couche UI.
/// Gère la récupération, la création, la mise à jour et la suppression des notes.
library;

import 'dart:convert';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/storage_service.dart';

class GradeRepository {
  final ApiClient apiClient;
  final StorageService storageService;

  GradeRepository({
    required this.apiClient,
    required this.storageService,
  });

  /// Récupère la liste des notes (optionnellement pour une classe ou un élève spécifique)
  Future<List<Map<String, dynamic>>> getGrades({String? classId, String? studentId}) async {
    try {
      String endpoint = '/grades';
      Map<String, String> params = {};
      if (classId != null) params['classId'] = classId;
      if (studentId != null) params['studentId'] = studentId;

      final response = await apiClient.get(endpoint, params: params.isEmpty ? null : params);
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

  /// Récupère les détails d'une note par son ID
  Future<Map<String, dynamic>?> getGradeById(String gradeId) async {
    try {
      final response = await apiClient.get('/grades/$gradeId');
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      // Log ou gestion d'erreur
    }
    return null;
  }

  /// Crée une nouvelle note
  Future<bool> createGrade(Map<String, dynamic> gradeData) async {
    try {
      final response = await apiClient.post('/grades', body: gradeData);
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      // Log ou gestion d'erreur
      return false;
    }
  }

  /// Met à jour une note
  Future<bool> updateGrade(String gradeId, Map<String, dynamic> updateData) async {
    try {
      final response = await apiClient.put('/grades/$gradeId', body: updateData);
      return response.statusCode == 200;
    } catch (e) {
      // Log ou gestion d'erreur
      return false;
    }
  }

  /// Supprime une note
  Future<bool> deleteGrade(String gradeId) async {
    try {
      final response = await apiClient.delete('/grades/$gradeId');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      // Log ou gestion d'erreur
      return false;
    }
  }
}