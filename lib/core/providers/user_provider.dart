/// user_provider.dart
/// Provider (ChangeNotifier) pour gérer l'état des utilisateurs dans l'application.
/// Utilise UserRepository pour effectuer les opérations backend et expose l'état à la couche UI.
/// Permet de charger la liste des utilisateurs, les détails, mettre à jour, supprimer, etc.
library;

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/repositories/user_repository.dart';


enum UserStatus { initial, loading, loaded, error }

class UserProvider extends ChangeNotifier {
  final UserRepository userRepository;

  UserStatus _status = UserStatus.initial;
  List<Map<String, dynamic>> _users = [];
  Map<String, dynamic>? _selectedUser;
  String? _errorMessage;

  UserProvider({required this.userRepository});

  UserStatus get status => _status;
  List<Map<String, dynamic>> get users => _users;
  Map<String, dynamic>? get selectedUser => _selectedUser;
  String? get errorMessage => _errorMessage;

  /// Charge la liste des utilisateurs
  Future<void> loadUsers({int? page, int? pageSize, String? search}) async {
    _status = UserStatus.loading;
    notifyListeners();
    try {
      _users = await userRepository.getUsers(page: page, pageSize: pageSize, search: search);
      _status = UserStatus.loaded;
    } catch (e) {
      _status = UserStatus.error;
      _errorMessage = "Erreur lors du chargement des utilisateurs.";
    }
    notifyListeners();
  }

  /// Charge les détails d'un utilisateur
  Future<void> loadUserById(String userId) async {
    _status = UserStatus.loading;
    notifyListeners();
    try {
      _selectedUser = await userRepository.getUserById(userId);
      _status = UserStatus.loaded;
    } catch (e) {
      _status = UserStatus.error;
      _errorMessage = "Erreur lors du chargement de l'utilisateur.";
    }
    notifyListeners();
  }

  /// Met à jour un utilisateur
  Future<bool> updateUser(String userId, Map<String, dynamic> updateData) async {
    _status = UserStatus.loading;
    notifyListeners();
    try {
      final success = await userRepository.updateUser(userId, updateData);
      if (success) {
        await loadUserById(userId);
        await loadUsers();
        _status = UserStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = UserStatus.error;
        _errorMessage = "La mise à jour a échoué.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = UserStatus.error;
      _errorMessage = "Erreur lors de la mise à jour de l'utilisateur.";
      notifyListeners();
      return false;
    }
  }

  /// Supprime un utilisateur
  Future<bool> deleteUser(String userId) async {
    _status = UserStatus.loading;
    notifyListeners();
    try {
      final success = await userRepository.deleteUser(userId);
      if (success) {
        await loadUsers();
        _status = UserStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = UserStatus.error;
        _errorMessage = "La suppression a échoué.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = UserStatus.error;
      _errorMessage = "Erreur lors de la suppression de l'utilisateur.";
      notifyListeners();
      return false;
    }
  }

  /// Crée un nouvel utilisateur
  Future<bool> createUser(Map<String, dynamic> userData) async {
    _status = UserStatus.loading;
    notifyListeners();
    try {
      final success = await userRepository.createUser(userData);
      if (success) {
        await loadUsers();
        _status = UserStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = UserStatus.error;
        _errorMessage = "La création a échoué.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = UserStatus.error;
      _errorMessage = "Erreur lors de la création de l'utilisateur.";
      notifyListeners();
      return false;
    }
  }

  /// Récupère l'utilisateur actuellement connecté (depuis le storage)
  Future<Map<String, dynamic>?> getCurrentUser() async {
    return await userRepository.getCurrentUser();
  }
}