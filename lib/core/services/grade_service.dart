/// grade_service.dart
/// Service pour la gestion des notes (grades) : récupération, création, mise à jour, suppression.
/// Adapte les endpoints selon ton API backend.
library;

import 'dart:convert';
import 'package:gestion_ecole/core/models/grade_model.dart';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/api/api_endpoints.dart';

class GradeService {
  final ApiClient apiClient;

  GradeService({required this.apiClient});

  /// Récupérer toutes les notes d'un élève pour une classe
  Future<List<GradeModel>> getGradesForStudent({
    required String studentId,
    required String classId,
  }) async {
    final params = {
      'studentId': studentId,
      'classId': classId,
    };
    final response = await apiClient.get(ApiEndpoints.getGrades, params: params);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data.map<GradeModel>((item) => GradeModel.fromJson(item)).toList();
      } else if (data is Map && data['items'] is List) {
        return (data['items'] as List)
            .map<GradeModel>((item) => GradeModel.fromJson(item))
            .toList();
      }
    }
    return [];
  }

  /// Créer une nouvelle note
  Future<GradeModel?> createGrade(GradeModel grade) async {
    final response = await apiClient.post(
      ApiEndpoints.createGrade,
      body: grade.toJson(),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return GradeModel.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  /// Mettre à jour une note
  Future<bool> updateGrade(String gradeId, Map<String, dynamic> updateData) async {
    final response = await apiClient.put('${ApiEndpoints.updateGrade}/$gradeId', body: updateData);
    return response.statusCode == 200;
  }

  /// Supprimer une note
  Future<bool> deleteGrade(String gradeId) async {
    final response = await apiClient.delete('${ApiEndpoints.deleteGrade}/$gradeId');
    return response.statusCode == 200 || response.statusCode == 204;
  }

  /// Récupérer toutes les notes d'une classe (optionnel)
  Future<List<GradeModel>> getGradesForClass({
    required String classId,
  }) async {
    final params = {
      'classId': classId,
    };
    final response = await apiClient.get(ApiEndpoints.getGrades, params: params);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data.map<GradeModel>((item) => GradeModel.fromJson(item)).toList();
      } else if (data is Map && data['items'] is List) {
        return (data['items'] as List)
            .map<GradeModel>((item) => GradeModel.fromJson(item))
            .toList();
      }
    }
    return [];
  }
}