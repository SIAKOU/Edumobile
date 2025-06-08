/// payment_repository.dart
/// Dépôt (repository) centralisant la gestion des paiements (payment).
/// Sert d'interface entre les services d'API et la couche UI.
/// Gère la récupération, la création, la mise à jour et la suppression des paiements.
library;

import 'dart:convert';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/storage_service.dart';
import 'dart:developer'; // Import pour utiliser log

class PaymentRepository {
  final ApiClient apiClient;
  final StorageService storageService;

  PaymentRepository({required this.apiClient, required this.storageService});

  /// Récupère la liste des paiements (optionnellement pour une classe ou un élève spécifique)
  Future<List<Map<String, dynamic>>> getPayments({String? classId, String? studentId}) async {
    String endpoint = '/payments';
    Map<String, String> params = {};
    if (classId != null) params['classId'] = classId;
    if (studentId != null) params['studentId'] = studentId;

    try {
      final response = await apiClient.get(endpoint, params: params.isEmpty ? null : params);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return (data as List).cast<Map<String, dynamic>>();
        } else if (data is Map && data['items'] is List) {
          return (data['items'] as List).cast<Map<String, dynamic>>();
        } else {
           log('API Error (getPayments): Format de réponse inattendu - Status: ${response.statusCode}, Body: ${response.body}');
           return []; // Retourne une liste vide pour un format inattendu
        }
      } else {
        log('API Error (getPayments): Status: ${response.statusCode}, Body: ${response.body}');
        return []; // Retourne une liste vide en cas de statut non-200
      }
    } catch (e) {
      log('Exception dans getPayments: $e');
      return []; // Retourne une liste vide en cas d'exception
    }
  }

  /// Récupère les détails d'un paiement par son ID
  Future<Map<String, dynamic>?> getPaymentById(String paymentId) async {
    try {
      final response = await apiClient.get('/payments/$paymentId');
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        log('API Error (getPaymentById): Status: ${response.statusCode}, Body: ${response.body}');
        return null; // Retourne null en cas de statut non-200
      }
    } catch (e) {
      log('Exception dans getPaymentById: $e');
      return null; // Retourne null en cas d'exception
    }
  }

  /// Crée un nouveau paiement
  Future<bool> createPayment(Map<String, dynamic> paymentData) async {
    try {
      final response = await apiClient.post('/payments', body: paymentData);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        log('API Error (createPayment): Status: ${response.statusCode}, Body: ${response.body}');
        return false; // Retourne false en cas de statut non-succès
      }
    } catch (e) {
      log('Exception dans createPayment: $e');
      return false; // Retourne false en cas d'exception
    }
  }

  /// Met à jour un paiement
  Future<bool> updatePayment(String paymentId, Map<String, dynamic> updateData) async {
    try {
      final response = await apiClient.put('/payments/$paymentId', body: updateData);
      if (response.statusCode == 200) {
        return true;
      } else {
        log('API Error (updatePayment): Status: ${response.statusCode}, Body: ${response.body}');
        return false; // Retourne false en cas de statut non-200
      }
    } catch (e) {
      log('Exception dans updatePayment: $e');
      return false; // Retourne false en cas d'exception
    }
  }

  /// Supprime un paiement
  Future<bool> deletePayment(String paymentId) async {
    try {
      final response = await apiClient.delete('/payments/$paymentId');
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        log('API Error (deletePayment): Status: ${response.statusCode}, Body: ${response.body}');
        return false; // Retourne false en cas de statut non-succès
      }
    } catch (e) {
      log('Exception dans deletePayment: $e');
      return false; // Retourne false en cas d'exception
    }
  }
}
