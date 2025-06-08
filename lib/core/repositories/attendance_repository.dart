/// attendance_repository.dart
/// Dépôt (repository) centralisant la gestion des présences (attendance).
/// Sert d'interface entre les services d'API et la couche UI.
/// Gère la récupération, la création, la mise à jour et la suppression des présences.

// ignore_for_file: dangling_library_doc_comments

import 'dart:convert';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/storage_service.dart';

class AttendanceRepository {
  final ApiClient apiClient;
  final StorageService storageService;

  AttendanceRepository({
    required this.apiClient,
    required this.storageService,
  });

  /// Récupère la liste des présences (optionnellement pour une classe ou un élève spécifique)
  Future<List<Map<String, dynamic>>> getAttendances({String? classId, String? studentId}) async {
    try {
      String endpoint = '/attendances';
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

  /// Récupère les détails d'une présence par son ID
  Future<Map<String, dynamic>?> getAttendanceById(String attendanceId) async {
    try {
      final response = await apiClient.get('/attendances/$attendanceId');
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      // Log ou gestion d'erreur
    }
    return null;
  }

  /// Crée une nouvelle présence
  Future<bool> createAttendance(Map<String, dynamic> attendanceData) async {
    try {
      final response = await apiClient.post('/attendances', body: attendanceData);
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      // Log ou gestion d'erreur
      return false;
    }
  }

  /// Met à jour une présence
  Future<bool> updateAttendance(String attendanceId, Map<String, dynamic> updateData) async {
    try {
      final response = await apiClient.put('/attendances/$attendanceId', body: updateData);
      return response.statusCode == 200;
    } catch (e) {
      // Log ou gestion d'erreur
      return false;
    }
  }

  /// Supprime une présence
  Future<bool> deleteAttendance(String attendanceId) async {
    try {
      final response = await apiClient.delete('/attendances/$attendanceId');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      // Log ou gestion d'erreur
      return false;
    }
  }
}