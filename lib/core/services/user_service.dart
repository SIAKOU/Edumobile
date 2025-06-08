/// user_service.dart
/// Service pour la gestion des utilisateurs (création, récupération, mise à jour, etc.).
/// Utilise ApiClient pour les appels réseau.
/// Adaptez selon la structure de vos endpoints et votre modèle UserModel.

library;

import 'dart:convert';
import 'package:gestion_ecole/core/models/user_model.dart';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/api/api_endpoints.dart';

class UserService {
  final ApiClient apiClient;

  UserService({required this.apiClient});

  /// Crée un nouvel utilisateur (inscription)
  Future<UserModel?> createUser(UserModel user) async {
    final response = await apiClient.post(
      ApiEndpoints.createUser,
      body: user.toJson(),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  /// Récupère le profil de l'utilisateur courant (connecté)
  Future<UserModel?> getProfile() async {
    final response = await apiClient.get(ApiEndpoints.userProfile);
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  /// Récupère un utilisateur par son ID
  Future<UserModel?> getUserById(String id) async {
    final response = await apiClient.get('${ApiEndpoints.getUser}/$id');
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  /// Met à jour un utilisateur (par ID)
  Future<bool> updateUser(String id, Map<String, dynamic> updateData) async {
    final response =
        await apiClient.put('${ApiEndpoints.updateUser}/$id', body: updateData);
    return response.statusCode == 200;
  }

  /// Supprime un utilisateur (par ID)
  Future<bool> deleteUser(String id) async {
    final response = await apiClient.delete('${ApiEndpoints.deleteUser}/$id');
    return response.statusCode == 200 || response.statusCode == 204;
  }

  /// Liste tous les utilisateurs (avec pagination optionnelle)
  Future<List<UserModel>> getAllUsers({int? page, int? pageSize}) async {
    final params = <String, dynamic>{};
    if (page != null) params['page'] = page;
    if (pageSize != null) params['pageSize'] = pageSize;
    final response = await apiClient.get(ApiEndpoints.getUser, params: params);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data.map<UserModel>((item) => UserModel.fromJson(item)).toList();
      } else if (data is Map && data['items'] is List) {
        return (data['items'] as List)
            .map<UserModel>((item) => UserModel.fromJson(item))
            .toList();
      }
    }
    return [];
  }

  /// Liste les étudiants (avec filtrage par classe, recherche et pagination)
  Future<List<UserModel>> getStudents({
    String? classId,
    String? search,
    int? page,
    int? pageSize,
  }) async {
    final params = <String, dynamic>{
      'role': 'student',
    };
    if (classId != null && classId.isNotEmpty) params['classId'] = classId;
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (page != null) params['page'] = page;
    if (pageSize != null) params['pageSize'] = pageSize;

    final response = await apiClient.get(ApiEndpoints.getUser, params: params);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data.map<UserModel>((item) => UserModel.fromJson(item)).toList();
      } else if (data is Map && data['items'] is List) {
        return (data['items'] as List)
            .map<UserModel>((item) => UserModel.fromJson(item))
            .toList();
      }
    }
    return [];
  }

  /// Liste les enseignants (avec recherche et pagination)
  Future<List<UserModel>> getTeachers({
    String? search,
    int? page,
    int? pageSize,
    String? subjectId,
  }) async {
    final params = <String, dynamic>{
      'role': 'teacher',
    };
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (page != null) params['page'] = page;
    if (pageSize != null) params['pageSize'] = pageSize;
    if (subjectId != null) params['subjectId'] = subjectId;

    final response = await apiClient.get(ApiEndpoints.getUser, params: params);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data.map<UserModel>((item) => UserModel.fromJson(item)).toList();
      } else if (data is Map && data['items'] is List) {
        return (data['items'] as List)
            .map<UserModel>((item) => UserModel.fromJson(item))
            .toList();
      }
    }
    return [];
  }
}
