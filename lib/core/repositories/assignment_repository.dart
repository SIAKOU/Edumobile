/// assignment_repository.dart
/// Dépôt (repository) centralisant la gestion des devoirs (assignments).
/// Sert d'interface entre les services d'API et la couche UI.
/// Gère la récupération, la création, la mise à jour et la suppression des devoirs.
// ignore_for_file: avoid_returning_null_for_void

library;

import 'dart:convert';
import 'package:flutter/foundation.dart'; // Import pour debugPrint
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/api/api_endpoints.dart'; // Assurez-vous que ApiEndpoints contient le chemin pour les devoirs
import 'package:gestion_ecole/core/services/storage_service.dart'; // Inclus pour la cohérence, même si non utilisé ici

import '../models/assignment_model.dart'; // Assurez-vous que AssignmentModel a une factory fromJson

class AssignmentRepository {
  final ApiClient apiClient;
  final StorageService storageService; // Inclus pour la cohérence

  AssignmentRepository({
    required this.apiClient,
    required this.storageService, // Inclus pour la cohérence
  });

  /// Récupère la liste des devoirs avec des options de filtrage.
  /// Retourne une liste vide en cas d'erreur ou si aucun devoir n'est trouvé.
  Future<List> getAssignments({
    String? classId,
    String? teacherId,
    String? studentId,
    bool? toReview, // Filtre pour les devoirs à corriger
    int? page,
    int? pageSize,
  }) async {
    final params = <String, dynamic>{};
    if (classId != null) params['classId'] = classId;
    if (teacherId != null) params['teacherId'] = teacherId;
    if (studentId != null) params['studentId'] = studentId;
    if (toReview != null) params['toReview'] = toReview.toString(); // Convertir bool en String
    if (page != null) params['page'] = page.toString();
    if (pageSize != null) params['pageSize'] = pageSize.toString();

    try {
      final response = await apiClient.get(ApiEndpoints.assignments, params: params);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Map<String, dynamic>> assignmentDataList = [];

        if (data is List) {
          // Gère le cas où l'API retourne directement une liste
          assignmentDataList = (data as List).cast<Map<String, dynamic>>();
        } else if (data is Map && data.containsKey('items') && data['items'] is List) {
          // Gère le cas où l'API retourne un objet avec une clé 'items' contenant la liste (pagination)
          assignmentDataList = (data['items'] as List).cast<Map<String, dynamic>>();
        } else {
          // Format de réponse inattendu
          debugPrint('AssignmentRepository: Format de données inattendu pour getAssignments: ${response.body}');
          return [];
        }

        // Mapper la liste de Map en liste de AssignmentModel
        return assignmentDataList.map((data) => AssignmentModel.fromJson(data)).toList();

      } else {
        // Log les codes de statut non réussis
        debugPrint('AssignmentRepository: Échec de la récupération des devoirs. Code statut: ${response.statusCode}, Corps: ${response.body}');
        return [];
      }
    } catch (e, st) {
      // Log les exceptions lors de l'appel API
      debugPrint('AssignmentRepository: Exception lors de la récupération des devoirs: $e');
      debugPrint('Stack: $st');
      return [];
    }
  }

  /// Récupère un devoir spécifique par son ID.
  /// Retourne null si le devoir n'est pas trouvé ou en cas d'erreur.
  Future<AssignmentModel?>ntById(String assignmentId) async {
    try {
      final response = await apiClient.get('${ApiEndpoints.assignments}/$assignmentId');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          return AssignmentModel.fromJson(data as Map<String, dynamic>); // Mapper en AssignmentModel
        } else {  
           debugPrint('AssignmentRepository: Format de données inattendu pour getAssignmentById $assignmentId: ${response.body}');
           return null;
        }
      } else if (response.statusCode == 404) {
        // Devoir non trouvé
        debugPrint('AssignmentRepository: Devoir avec ID $assignmentId non trouvé.');
        return null;
      } else {
        // Log les codes de statut non réussis
        debugPrint('AssignmentRepository: Échec de la récupération du devoir $assignmentId. Code statut: ${response.statusCode}, Corps: ${response.body}');
        return null;
      }
    } catch (e, st) {
      // Log les exceptions lors de l'appel API
      debugPrint('AssignmentRepository: Exception lors de la récupération du devoir $assignmentId: $e');
      debugPrint('Stack: $st');
      return null;
    }
  }

  /// Crée un nouveau devoir.
  /// Retourne true si la création est réussie (statut 201 ou 200), false sinon.
  Future<bool> createAssignment(Map<String, dynamic> assignmentData) async {
    try {
      final response = await apiClient.post(ApiEndpoints.assignments, body: assignmentData);

      if (response.statusCode == 201 || response.statusCode == 200) {
        debugPrint('AssignmentRepository: Devoir créé avec succès.');
        return true;
      } else {
        // Log les codes de statut non réussis
        debugPrint('AssignmentRepository: Échec de la création du devoir. Code statut: ${response.statusCode}, Corps: ${response.body}');
        return false;
      }
    } catch (e, st) {
      // Log les exceptions lors de l'appel API
      debugPrint('AssignmentRepository: Exception lors de la création du devoir: $e');
      debugPrint('Stack: $st');
      return false;
    }
  }

  /// Met à jour un devoir existant.
  /// Retourne true si la mise à jour est réussie (statut 200), false sinon.
  Future<bool> updateAssignment(String assignmentId, Map<String, dynamic> updateData) async {
    try {
      final response = await apiClient.put('${ApiEndpoints.assignments}/$assignmentId', body: updateData);

      if (response.statusCode == 200) {
        debugPrint('AssignmentRepository: Devoir $assignmentId mis à jour avec succès.');
        return true;
      } else {
        // Log les codes de statut non réussis
        debugPrint('AssignmentRepository: Échec de la mise à jour du devoir $assignmentId. Code statut: ${response.statusCode}, Corps: ${response.body}');
        return false;
      }
    } catch (e, st) {
      // Log les exceptions lors de l'appel API
      debugPrint('AssignmentRepository: Exception lors de la mise à jour du devoir $assignmentId: $e');
      debugPrint('Stack: $st');
      return false;
    }
  }

  /// Supprime un devoir.
  /// Retourne true si la suppression est réussie (statut 200 ou 204), false sinon.
  Future<bool> deleteAssignment(String assignmentId) async {
    try {
      final response = await apiClient.delete('${ApiEndpoints.assignments}/$assignmentId');

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint('AssignmentRepository: Devoir $assignmentId supprimé avec succès.');
        return true;
      } else {
        // Log les codes de statut non réussis
        debugPrint('AssignmentRepository: Échec de la suppression du devoir $assignmentId. Code statut: ${response.statusCode}, Corps: ${response.body}');
        return false;
      }
    } catch (e, st) {
      // Log les exceptions lors de l'appel API
      debugPrint('AssignmentRepository: Exception lors de la suppression du devoir $assignmentId: $e');
      debugPrint('Stack: $st');
      return false;
    }
  }

  /// Récupère la liste des devoirs qui nécessitent une correction.
  /// Peut être filtré par enseignant.
  /// Retourne une liste vide en cas d'erreur ou si aucun devoir n'est à corriger.
  Future<Future<List>> getAssignmentsToReview({String? teacherId}) async {
     // Utilise la méthode getAssignments avec le filtre toReview: true
     return getAssignments(teacherId: teacherId, toReview: true);
  }

  // Ajoutez d'autres méthodes spécifiques aux devoirs si nécessaire (ex: soumettre un devoir, noter un devoir)
}
