/// auth_service.dart
/// Service d'authentification utilisant Supabase
/// Gère le login, logout, session et stockage local
// ignore_for_file: strict_top_level_inference

library;

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestion_ecole/core/models/user_model.dart';

class AuthService {
  static const String _sessionKey = 'supabase_session';
  final SupabaseClient _supabase;

  AuthService() : _supabase = Supabase.instance.client;

  /// Authentification avec email/mot de passe
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      await _persistSession(response.session!);
      return response;
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  /// Inscription avec email/mot de passe
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required UserModel userData,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': userData.fullName,
          'role': userData.role,
          'phone': userData.phone,
          'avatar_url': userData.avatarUrl,
        },
      );
      
      if (response.session != null) {
        await _persistSession(response.session!);
      }
      return response;
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw Exception('Erreur d\'inscription: $e');
    }
  }

  /// Déconnexion
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      await _clearSession();
    } catch (e) {
      throw Exception('Erreur lors de la déconnexion: $e');
    }
  }

  /// Récupère l'utilisateur courant
  User? get currentUser => _supabase.auth.currentUser;

  /// Vérifie si l'utilisateur est connecté
  bool get isLoggedIn => _supabase.auth.currentSession != null;

  /// Rafraîchit la session
  Future<void> refreshSession() async {
    try {
      final response = await _supabase.auth.refreshSession();
      if (response.session != null) {
        await _persistSession(response.session!);
      }
    } on AuthException catch (e) {
      await _clearSession();
      throw AuthException(e.message);
    }
  }

  /// Récupère la session depuis le stockage local
  Future<void> recoverSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionJson = prefs.getString(_sessionKey);
    
    if (sessionJson != null) {
      try {
        final session = Session.fromJson(jsonDecode(sessionJson));
        if (session != null) {
          await _supabase.auth.recoverSession(session.accessToken);
        }
      } catch (_) {
        await _clearSession();
      }
    }
  }

  /// Persiste la session localement
  Future<void> _persistSession(Session session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _sessionKey,
      jsonEncode(session.toJson()),
    );
  }

  /// Supprime la session locale
  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  /// Authentification avec Google
  Future<bool> signInWithGoogle() async {
    try {
      final response = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: kIsWeb ? null : 'io.supabase.flutter://login-callback/',
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
      
      if (response.session != null) {
        await _persistSession(response.session!);
      }
      return response;
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw Exception('Erreur de connexion Google: $e');
    }
  }

  /// Authentification avec GitHub
  Future<bool> signInWithGitHub() async {
    try {
      final response = await _supabase.auth.signInWithOAuth(
        OAuthProvider.github,
        redirectTo: kIsWeb ? null : 'io.supabase.flutter://login-callback/',
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
      
      if (response.session != null) {
        await _persistSession(response.session!);
      }
      return response;
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw Exception('Erreur de connexion GitHub: $e');
    }
  }

  /// Met à jour le profil utilisateur
  Future<void> updateProfile(UserModel userData) async {
    // Assurez-vous que l'ID de l'utilisateur dans userData n'est pas vide.
    // Cet ID doit correspondre à l'auth.uid() de Supabase.
    if (userData.id.isEmpty) {
      debugPrint("AuthService.updateProfile: User ID in userData is empty. Cannot update profile.");
      throw Exception("L'ID utilisateur est manquant pour la mise à jour du profil.");
    }

   
    final Map<String, dynamic> profileData = {
      'id': userData.id, // Essentiel: doit être l'auth.uid()
      'email': userData.email, // Assurez-vous que l'email est inclus
      'full_name': userData.fullName,
      'role': userData.role, // Essentiel pour la logique de l'application
      'phone': userData.phone,
      'address': userData.address, // Si vous avez ce champ
      'avatar_url': userData.avatarUrl,
      // 'created_at' est généralement géré par la BDD (DEFAULT now()) à l'insertion.
      // 'updated_at' peut être géré par la BDD via un trigger ou mis à jour ici.
      'updated_at': DateTime.now().toIso8601String(),
      // Ajoutez d'autres champs de UserModel si nécessaire
    };
    userData.toJson();
    profileData.removeWhere((key, value) => value == null);

    try {
      debugPrint("AuthService.updateProfile: Attempting to upsert profile data: $profileData for table 'users'");
      await _supabase.from('users').upsert(profileData); // Assurez-vous que 'users' est le nom correct de votre table
      debugPrint("AuthService.updateProfile: Profile upserted successfully for user ID: ${userData.id}");
    } on PostgrestException catch (e) {
      debugPrint('AuthService.updateProfile: PostgrestException: ${e.message}, Details: ${e.details}, Hint: ${e.hint}, Code: ${e.code}');
      throw Exception('Erreur de base de données lors de la mise à jour du profil: ${e.message}');
    } catch (e) {
      debugPrint('AuthService.updateProfile: Generic error: $e');
      throw Exception('Erreur inattendue lors de la mise à jour du profil: $e');
    }
  }
}

extension on bool {
  get session => null;
  
}