/// auth_repository.dart
/// Dépôt (repository) centralisant la logique d'authentification.
/// Sert d'interface entre les services (API, stockage local, biométrie) et la couche UI.
/// Gère la connexion, l'inscription, la déconnexion, le rafraîchissement du token, etc.
library;

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/api/api_endpoints.dart';
import 'package:gestion_ecole/core/services/biometric_service.dart';
import 'package:gestion_ecole/core/services/storage_service.dart';

class AuthRepository {
  final ApiClient apiClient;
  final StorageService storageService;
  final BiometricService biometricService;

  AuthRepository({
    required this.apiClient,
    required this.storageService,
    required this.biometricService,
  });

  /// Connexion classique (email/mot de passe)
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.login,
        body: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await storageService.setString('auth_token', data['token']);
        await storageService.setString('user', jsonEncode(data['user']));
        return true;
      }
    } catch (e) {
      debugPrint('Erreur login: $e');
    }
    return false;
  }

  /// Inscription nouvel utilisateur
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.register,
        body: {'name': name, 'email': email, 'password': password},
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      debugPrint('Erreur register: $e');
      return false;
    }
  }

  /// Déconnexion
  Future<void> logout() async {
    await storageService.remove('auth_token');
    await storageService.remove('user');
    // Peut appeler une route API de logout si besoin
  }

  /// Récupère le token stocké localement
  Future<String?> getToken() async {
    return storageService.getString('auth_token');
  }

  /// Récupère l'utilisateur connecté (depuis le stockage local)
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final userStr = storageService.getString('user');
    if (userStr == null) return null;
    return jsonDecode(userStr) as Map<String, dynamic>;
  }

  /// Authentification biométrique (si activée)
  Future<bool> loginWithBiometrics() async {
    final canAuth = await biometricService.isBiometricAvailable();
    if (!canAuth) return false;
    return await biometricService.authenticateWithBiometrics(
      reason: 'Authentifiez-vous pour accéder à votre compte.',
    );
  }

  /// Rafraîchit le token (ex: via un endpoint refresh)
  Future<bool> refreshToken() async {
    final oldToken = await getToken();
    if (oldToken == null) return false;

    try {
      final response = await apiClient.post(
        ApiEndpoints.refreshToken,
        headers: {'Authorization': 'Bearer $oldToken'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await storageService.setString('auth_token', data['token']);
        return true;
      }
    } catch (e) {
      debugPrint('Erreur refreshToken: $e');
    }
    return false;
  }

  /// Indique si un utilisateur est connecté (token présent/valide)
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}