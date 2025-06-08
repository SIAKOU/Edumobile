import 'dart:convert';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/storage_service.dart';

class AnnouncementRepository {
  final ApiClient apiClient;
  final StorageService storageService;

  AnnouncementRepository({
    required this.apiClient,
    required this.storageService,
  });

  /// Récupère la liste des annonces
  Future<List<Map<String, dynamic>>> getAnnouncements() async {
    try {
      final response = await apiClient.get('/announcements');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return (data as List).cast<Map<String, dynamic>>();
        } else if (data is Map && data['items'] is List) {
          return (data['items'] as List).cast<Map<String, dynamic>>();
        }
      }
    } catch (e) {
      // Tu peux logger l'erreur ici si besoin
    }
    return [];
  }

  /// Récupère les détails d'une annonce par son ID
  Future<Map<String, dynamic>?> getAnnouncementById(String announcementId) async {
    try {
      final response = await apiClient.get('/announcements/$announcementId');
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      // Log ou gestion d'erreur
    }
    return null;
  }

  /// Crée une nouvelle annonce
  Future<bool> createAnnouncement(Map<String, dynamic> announcementData) async {
    try {
      final response = await apiClient.post('/announcements', body: announcementData);
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      // Log ou gestion d'erreur
      return false;
    }
  }

  /// Met à jour une annonce
  Future<bool> updateAnnouncement(String announcementId, Map<String, dynamic> updateData) async {
    try {
      final response = await apiClient.put('/announcements/$announcementId', body: updateData);
      return response.statusCode == 200;
    } catch (e) {
      // Log ou gestion d'erreur
      return false;
    }
  }

  /// Supprime une annonce
  Future<bool> deleteAnnouncement(String announcementId) async {
    try {
      final response = await apiClient.delete('/announcements/$announcementId');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      // Log ou gestion d'erreur
      return false;
    }
  }
}