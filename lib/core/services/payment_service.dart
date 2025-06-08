/// payment_service.dart
/// Service pour la gestion des paiements (récupération, création, mise à jour, suppression, etc.).
/// Utilise ApiClient pour les appels réseau.
/// À adapter selon la structure et les besoins de votre backend/API.
library;

import 'dart:convert';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/api/api_endpoints.dart';


class PaymentService {
  final ApiClient apiClient;

  PaymentService({required this.apiClient});

  /// Récupère la liste des paiements (avec pagination et/ou filtres)
  Future<List<Map<String, dynamic>>> getAllPayments({
    int? page,
    int? pageSize,
    String? userId,
    String? classId,
    String? status,
  }) async {
    final params = <String, dynamic>{};
    if (page != null) params['page'] = page;
    if (pageSize != null) params['pageSize'] = pageSize;
    if (userId != null) params['user_id'] = userId;
    if (classId != null) params['class_id'] = classId;
    if (status != null) params['status'] = status;
    final response = await apiClient.get(ApiEndpoints.payments, params: params);
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

  /// Récupère le détail d'un paiement par son ID
  Future<Map<String, dynamic>?> getPaymentById(String id) async {
    final response = await apiClient.get('${ApiEndpoints.payments}/$id');
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    return null;
  }

  /// Crée un nouveau paiement
  Future<bool> createPayment(Map<String, dynamic> paymentData) async {
    final response = await apiClient.post(ApiEndpoints.payments, body: paymentData);
    return response.statusCode == 201 || response.statusCode == 200;
  }

  /// Met à jour un paiement existant
  Future<bool> updatePayment(String id, Map<String, dynamic> updateData) async {
    final response = await apiClient.put('${ApiEndpoints.payments}/$id', body: updateData);
    return response.statusCode == 200;
  }

  /// Supprime un paiement (suppression logique ou physique selon l'API)
  Future<bool> deletePayment(String id) async {
    final response = await apiClient.delete('${ApiEndpoints.payments}/$id');
    return response.statusCode == 200 || response.statusCode == 204;
  }
}