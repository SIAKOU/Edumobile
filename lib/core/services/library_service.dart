/// library_service.dart
/// Service pour la gestion des fichiers virtuels / bibliothèque numérique.
/// Permet de récupérer, ajouter, mettre à jour ou supprimer des fichiers.
/// Utilise ApiClient pour les appels réseau.
/// À adapter selon la structure de votre backend/API.
library;

import 'dart:convert';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/api/api_endpoints.dart';



class LibraryService {
  final ApiClient apiClient;

  LibraryService({required this.apiClient});

  /// Récupère la liste des fichiers virtuels (avec pagination et/ou filtres)
  Future<List<Map<String, dynamic>>> getAllFiles({
    int? page,
    int? pageSize,
    String? classId,
    String? type,
    String? search,
  }) async {
    final params = <String, dynamic>{};
    if (page != null) params['page'] = page;
    if (pageSize != null) params['pageSize'] = pageSize;
    if (classId != null) params['class_id'] = classId;
    if (type != null) params['type'] = type;
    if (search != null) params['search'] = search;
    final response = await apiClient.get(ApiEndpoints.virtualFiles, params: params);
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

  /// Récupère le détail d'un fichier virtuel par son ID
  Future<Map<String, dynamic>?> getFileById(String id) async {
    final response = await apiClient.get('${ApiEndpoints.virtualFiles}/$id');
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    return null;
  }

  /// Ajoute un nouveau fichier virtuel
  Future<bool> addFile(Map<String, dynamic> fileData) async {
    final response = await apiClient.post(ApiEndpoints.virtualFiles, body: fileData);
    return response.statusCode == 201 || response.statusCode == 200;
  }

  /// Met à jour un fichier existant
  Future<bool> updateFile(String id, Map<String, dynamic> updateData) async {
    final response = await apiClient.put('${ApiEndpoints.virtualFiles}/$id', body: updateData);
    return response.statusCode == 200;
  }

  /// Supprime un fichier (suppression logique ou physique selon l'API)
  Future<bool> deleteFile(String id) async {
    final response = await apiClient.delete('${ApiEndpoints.virtualFiles}/$id');
    return response.statusCode == 200 || response.statusCode == 204;
  }
}