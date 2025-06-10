/// schedule_repository.dart
/// Dépôt (repository) centralisant la gestion des emplois du temps (schedules).
/// Sert d'interface entre les services d'API et la couche UI.
/// Gère la récupération, la création, la mise à jour et la suppression des emplois du temps.
library;

import 'dart:convert';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/storage_service.dart'; // Keep StorageService import
import 'package:flutter/foundation.dart'; // Import for debugPrint

class ScheduleRepository {
  final ApiClient apiClient;
  final StorageService storageService; // Keep StorageService field

  // Keep StorageService in the constructor
  ScheduleRepository({required this.apiClient, required this.storageService});

  /// Récupère la liste des emplois du temps (optionnellement pour une classe ou un élève spécifique)
  Future<List<Map<String, dynamic>>> getSchedules(
      {String? classId, String? studentId}) async {
    String endpoint = '/schedules';
    Map<String, String> params = {};
    if (classId != null) params['classId'] = classId;
    if (studentId != null) params['studentId'] = studentId;

    try {
      final response =
          await apiClient.get(endpoint, params: params.isEmpty ? null : params);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return (data as List).cast<Map<String, dynamic>>();
        } else if (data is Map && data['items'] is List) {
          // Handles potential pagination structure
          return (data['items'] as List).cast<Map<String, dynamic>>();
        }
        // Handle unexpected data format
        debugPrint(
            'ScheduleRepository: Unexpected data format for getSchedules: ${response.body}');
        return [];
      } else {
        // Log non-success status code
        debugPrint(
            'ScheduleRepository: Failed to get schedules. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      // Log any exceptions during the API call
      debugPrint('ScheduleRepository: Exception during getSchedules: $e');
    }
    return [];
  }

  /// Récupère les détails d'un emploi du temps par son ID
  Future<Map<String, dynamic>?> getScheduleById(String scheduleId) async {
    try {
      final response = await apiClient.get('/schedules/$scheduleId');
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        debugPrint(
            'ScheduleRepository: Failed to get schedule by ID $scheduleId. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      debugPrint(
          'ScheduleRepository: Exception during getScheduleById $scheduleId: $e');
    }
    return null;
  }

  /// Crée un nouvel emploi du temps
  Future<bool> createSchedule(Map<String, dynamic> scheduleData) async {
    try {
      final response = await apiClient.post('/schedules', body: scheduleData);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        debugPrint(
            'ScheduleRepository: Failed to create schedule. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      debugPrint('ScheduleRepository: Exception during createSchedule: $e');
    }
    return false;
  }

  /// Met à jour un emploi du temps
  Future<bool> updateSchedule(
      String scheduleId, Map<String, dynamic> updateData) async {
    try {
      final response =
          await apiClient.put('/schedules/$scheduleId', body: updateData);
      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint(
            'ScheduleRepository: Failed to update schedule $scheduleId. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      debugPrint(
          'ScheduleRepository: Exception during updateSchedule $scheduleId: $e');
    }
    return false;
  }

  /// Supprime un emploi du temps
  Future<bool> deleteSchedule(String scheduleId) async {
    try {
      final response = await apiClient.delete('/schedules/$scheduleId');
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        debugPrint(
            'ScheduleRepository: Failed to delete schedule $scheduleId. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      debugPrint(
          'ScheduleRepository: Exception during deleteSchedule $scheduleId: $e');
    }
    return false;
  }

  //methode de getUpcomingEvents(studentId: studentId);
  Future<List<Map<String, dynamic>>> getUpcomingEvents(String studentId,
      {String? classId}) async {
    String endpoint = '/upcoming_events';
    Map<String, String> params = {'studentId': studentId};

    try {
      final response = await apiClient.get(endpoint, params: params);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return (data as List).cast<Map<String, dynamic>>();
        } else if (data is Map && data['items'] is List) {
          return (data['items'] as List).cast<Map<String, dynamic>>();
        }
        // Handle unexpected data format
        debugPrint(
            'ScheduleRepository: format non attendu pour getUpcomingEvents: ${response.body}');
        return [];
      } else {
        // Log non-success status code
        debugPrint(
            'ScheduleRepository: echec de getUpcomingEvents. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      debugPrint('ScheduleRepository: Exception during getUpcomingEvents: $e');
    }
    return [];
  }
}
