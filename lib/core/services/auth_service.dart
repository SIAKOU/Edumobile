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
    try {
      await _supabase.from('profiles').upsert({
        'id': currentUser?.id,
        'full_name': userData.fullName,
        'phone': userData.phone,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Erreur de mise à jour du profil: $e');
    }
  }
}

extension on bool {
  get session => null;
  
}