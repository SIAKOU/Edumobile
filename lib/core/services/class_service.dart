/// class_service.dart
/// Service pour la gestion des classes (récupération, création, mise à jour, suppression, etc.).
/// Utilise ApiClient pour les appels réseau.
/// Adaptez les méthodes et endpoints selon votre backend/API.
library;

import 'dart:convert';
import 'package:gestion_ecole/core/models/class_model.dart';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/api/api_endpoints.dart';

class ClassService {
  final ApiClient apiClient;

  ClassService({required this.apiClient});

  /// Récupère la liste des classes (avec recherche et pagination optionnelles)
  Future<List<ClassModel>> getClasses({
    String? search,
    int? page,
    int? pageSize,
  }) async {
    final params = <String, dynamic>{};
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (page != null) params['page'] = page;
    if (pageSize != null) params['pageSize'] = pageSize;
    final response = await apiClient.get(ApiEndpoints.listClasses, params: params);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List items;
      if (data is List) {
        items = data;
      } else if (data is Map && data['items'] is List) {
        items = data['items'];
      } else {
        return [];
      }
      return items.map<ClassModel>((json) => ClassModel.fromJson(json)).toList();
    }
    return [];
  }

  /// Récupère le détail d'une classe par son ID
  Future<ClassModel?> getClassById(String id) async {
    final response = await apiClient.get('${ApiEndpoints.classDetail}/$id');
    if (response.statusCode == 200) {
      return ClassModel.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  /// Crée une nouvelle classe
  Future<bool> createClass(ClassModel classModel) async {
    final response = await apiClient.post(
      ApiEndpoints.listClasses,
      body: classModel.toJson(),
    );
    return response.statusCode == 201 || response.statusCode == 200;
  }

  /// Met à jour une classe existante
  Future<bool> updateClass(String id, Map<String, dynamic> updateData) async {
    final response = await apiClient.put('${ApiEndpoints.classDetail}/$id', body: updateData);
    return response.statusCode == 200;
  }

  /// Supprime une classe (suppression logique ou physique selon l'API)
  Future<bool> deleteClass(String id) async {
    final response = await apiClient.delete('${ApiEndpoints.classDetail}/$id');
    return response.statusCode == 200 || response.statusCode == 204;
  }
}