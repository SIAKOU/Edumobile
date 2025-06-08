/// class_provider.dart
/// Provider (ChangeNotifier) pour gérer l'état des classes dans l'application.
/// Utilise ClassRepository (à adapter selon votre structure) pour les opérations backend.
/// Permet de charger la liste des classes, les détails, la création, la mise à jour, la suppression, etc.
library;

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/repositories/class_repository.dart';


enum ClassStatus { initial, loading, loaded, error }

class ClassProvider extends ChangeNotifier {
  final ClassRepository classRepository;

  ClassStatus _status = ClassStatus.initial;
  List<Map<String, dynamic>> _classes = [];
  Map<String, dynamic>? _selectedClass;
  String? _errorMessage;

  ClassProvider({required this.classRepository});

  ClassStatus get status => _status;
  List<Map<String, dynamic>> get classes => _classes;
  Map<String, dynamic>? get selectedClass => _selectedClass;
  String? get errorMessage => _errorMessage;

  /// Charge la liste des classes
  Future<void> loadClasses() async {
    _status = ClassStatus.loading;
    notifyListeners();
    try {
      _classes = await classRepository.getClasses();
      _status = ClassStatus.loaded;
    } catch (e) {
      _status = ClassStatus.error;
      _errorMessage = "Erreur lors du chargement des classes.";
    }
    notifyListeners();
  }

  /// Charge le détail d'une classe par son ID
  Future<void> loadClassById(String classId) async {
    _status = ClassStatus.loading;
    notifyListeners();
    try {
      _selectedClass = await classRepository.getClassById(classId);
      _status = ClassStatus.loaded;
    } catch (e) {
      _status = ClassStatus.error;
      _errorMessage = "Erreur lors du chargement de la classe.";
    }
    notifyListeners();
  }

  /// Crée une nouvelle classe
  Future<bool> createClass(Map<String, dynamic> classData) async {
    _status = ClassStatus.loading;
    notifyListeners();
    try {
      final success = await classRepository.createClass(classData);
      if (success) {
        await loadClasses();
        _status = ClassStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = ClassStatus.error;
        _errorMessage = "La création de la classe a échoué.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = ClassStatus.error;
      _errorMessage = "Erreur lors de la création de la classe.";
      notifyListeners();
      return false;
    }
  }

  /// Met à jour une classe
  Future<bool> updateClass(String classId, Map<String, dynamic> updateData) async {
    _status = ClassStatus.loading;
    notifyListeners();
    try {
      final success = await classRepository.updateClass(classId, updateData);
      if (success) {
        await loadClassById(classId);
        await loadClasses();
        _status = ClassStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = ClassStatus.error;
        _errorMessage = "La mise à jour de la classe a échoué.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = ClassStatus.error;
      _errorMessage = "Erreur lors de la mise à jour de la classe.";
      notifyListeners();
      return false;
    }
  }

  /// Supprime une classe
  Future<bool> deleteClass(String classId) async {
    _status = ClassStatus.loading;
    notifyListeners();
    try {
      final success = await classRepository.deleteClass(classId);
      if (success) {
        await loadClasses();
        _status = ClassStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = ClassStatus.error;
        _errorMessage = "La suppression de la classe a échoué.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = ClassStatus.error;
      _errorMessage = "Erreur lors de la suppression de la classe.";
      notifyListeners();
      return false;
    }
  }
}