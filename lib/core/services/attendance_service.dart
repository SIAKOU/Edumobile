/// attendance_service.dart
/// Service pour la gestion des présences (récupération, création, mise à jour, suppression, etc.).
/// Utilise ApiClient pour les appels réseau.
/// À adapter selon les besoins et la structure de votre backend/API.
library;

import 'dart:convert';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/api/api_endpoints.dart';



class AttendanceService {
  final ApiClient apiClient;

  AttendanceService({required this.apiClient});

  /// Récupère la liste des présences (avec pagination et/ou filtre de classe, date, etc.)
  Future<List<Map<String, dynamic>>> getAllAttendances({
    int? page,
    int? pageSize,
    String? classId,
    String? date,
  }) async {
    final params = <String, dynamic>{};
    if (page != null) params['page'] = page;
    if (pageSize != null) params['pageSize'] = pageSize;
    if (classId != null) params['class_id'] = classId;
    if (date != null) params['date'] = date;
    final response = await apiClient.get(ApiEndpoints.attendances, params: params);
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

  /// Récupère le détail d'une présence par son ID
  Future<Map<String, dynamic>?> getAttendanceById(String id) async {
    final response = await apiClient.get('${ApiEndpoints.attendances}/$id');
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    return null;
  }

  /// Crée une nouvelle présence
  Future<bool> createAttendance(Map<String, dynamic> attendanceData) async {
    final response = await apiClient.post(ApiEndpoints.attendances, body: attendanceData);
    return response.statusCode == 201 || response.statusCode == 200;
  }

  /// Met à jour une présence existante
  Future<bool> updateAttendance(String id, Map<String, dynamic> updateData) async {
    final response = await apiClient.put('${ApiEndpoints.attendances}/$id', body: updateData);
    return response.statusCode == 200;
  }

  /// Supprime une présence (suppression logique ou physique selon l'API)
  Future<bool> deleteAttendance(String id) async {
    final response = await apiClient.delete('${ApiEndpoints.attendances}/$id');
    return response.statusCode == 200 || response.statusCode == 204;
  }
}