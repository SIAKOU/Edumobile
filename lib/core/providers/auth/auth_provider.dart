/// auth_provider.dart
/// Provider (ChangeNotifier) pour gérer l'état d'authentification dans l'application.
/// Utilise AuthRepository pour effectuer les opérations backend et expose l'état à la couche UI.
/// Fournit les méthodes de connexion, inscription, déconnexion, etc., et notifie les listeners de tout changement.
library;

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/repositories/auth_repository.dart';


enum AuthStatus { unknown, authenticated, unauthenticated, loading }

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthStatus _status = AuthStatus.unknown;
  String? _errorMessage;

  AuthProvider({required this.authRepository});

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;

  /// Initialisation (ex: vérifier si un utilisateur est déjà connecté)
  Future<void> initialize() async {
    _status = AuthStatus.loading;
    notifyListeners();
    final isLogged = await authRepository.isLoggedIn();
    _status = isLogged ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    notifyListeners();
  }

  /// Connexion email/mot de passe
  Future<bool> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
    final success = await authRepository.login(email: email, password: password);
    if (success) {
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } else {
      _status = AuthStatus.unauthenticated;
      _errorMessage = "Échec de la connexion. Veuillez vérifier vos identifiants.";
      notifyListeners();
      return false;
    }
  }

  /// Inscription
  Future<bool> register(String name, String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
    final success = await authRepository.register(name: name, email: email, password: password);
    if (success) {
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } else {
      _status = AuthStatus.unauthenticated;
      _errorMessage = "Échec de l'inscription. Veuillez réessayer.";
      notifyListeners();
      return false;
    }
  }

  /// Déconnexion
  Future<void> logout() async {
    _status = AuthStatus.loading;
    notifyListeners();
    await authRepository.logout();
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  /// Connexion biométrique
  Future<bool> loginWithBiometrics() async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
    final success = await authRepository.loginWithBiometrics();
    if (success) {
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } else {
      _status = AuthStatus.unauthenticated;
      _errorMessage = "Authentification biométrique échouée ou non disponible.";
      notifyListeners();
      return false;
    }
  }

  /// Rafraîchir le token (ex: pour session persistante)
  Future<bool> refreshToken() async {
    final result = await authRepository.refreshToken();
    if (!result) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
    return result;
  }
}