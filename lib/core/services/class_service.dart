/// class_service.dart
/// Service pour la gestion des classes (récupération, création, mise à jour, suppression, etc.).
/// Utilise ApiClient pour les appels réseau.
/// Adaptez les méthodes et endpoints selon votre backend/API.
/// Adaptez les méthodes et endpoints selon votre backend/API.
library;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/models/class_model.dart';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/api/api_endpoints.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClassService {
  final ApiClient apiClient;

  ClassService({required this.apiClient});

  /// Récupère la liste des classes (avec recherche et pagination optionnelles)
  Future<List<ClassModel>> getClasses({
    String? search, // Le paramètre de recherche est conservé
    int page = 1,   // Page par défaut à 1
    int pageSize = 20, // Taille de page par défaut
  }) async {
    try {
      // Utiliser la méthode from() du client Supabase directement pour plus de flexibilité
      var query = apiClient.Supabase.from('classes').select(); // Assurez-vous que 'classes' est le nom correct

      if (search != null && search.isNotEmpty) {
        // Adaptez 'name' au nom de la colonne sur laquelle vous voulez rechercher
        query = query.textSearch('name', search, type: TextSearchType.plain); 
      }

      // Calculer les limites pour la pagination
      final offset = (page - 1) * pageSize;
      query = query.range(offset, offset + pageSize - 1);

      final responseData = await query; // Exécute la requête
      
      // responseData est déjà une List<Map<String, dynamic>>
      return responseData.map<ClassModel>((json) => ClassModel.fromJson(json)).toList();

    } catch (e) {
      // Loggez l'erreur pour un meilleur débogage
      debugPrint('Erreur dans ClassService.getClasses: $e');
      // Retourner une liste vide ou relancer une exception spécifique à votre application
      return []; 
    }
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