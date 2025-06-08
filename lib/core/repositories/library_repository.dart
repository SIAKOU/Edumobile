/// library_repository.dart
/// Dépôt (repository) centralisant la gestion de la bibliothèque (library).
/// Sert d'interface entre les services d'API et la couche UI.
/// Gère la récupération, l'ajout, la mise à jour et la suppression des livres.

// ignore_for_file: dangling_library_doc_comments

import 'dart:convert';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/storage_service.dart';

class LibraryRepository {
  final ApiClient apiClient;
  final StorageService storageService;

  LibraryRepository({
    required this.apiClient,
    required this.storageService,
  });

  /// Récupère la liste des livres (optionnellement par catégorie ou auteur)
  Future<List<Map<String, dynamic>>> getBooks({String? categoryId, String? authorId}) async {
    try {
      String endpoint = '/library/books';
      Map<String, String> params = {};
      if (categoryId != null) params['categoryId'] = categoryId;
      if (authorId != null) params['authorId'] = authorId;

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

  /// Récupère les détails d'un livre par son ID
  Future<Map<String, dynamic>?> getBookById(String bookId) async {
    try {
      final response = await apiClient.get('/library/books/$bookId');
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      // Log ou gestion d'erreur
    }
    return null;
  }

  /// Ajoute un nouveau livre
  Future<bool> createBook(Map<String, dynamic> bookData) async {
    try {
      final response = await apiClient.post('/library/books', body: bookData);
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      // Log ou gestion d'erreur
      return false;
    }
  }

  /// Met à jour un livre
  Future<bool> updateBook(String bookId, Map<String, dynamic> updateData) async {
    try {
      final response = await apiClient.put('/library/books/$bookId', body: updateData);
      return response.statusCode == 200;
    } catch (e) {
      // Log ou gestion d'erreur
      return false;
    }
  }

  /// Supprime un livre
  Future<bool> deleteBook(String bookId) async {
    try {
      final response = await apiClient.delete('/library/books/$bookId');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      // Log ou gestion d'erreur
      return false;
    }
  }
}