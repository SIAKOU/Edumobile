/// grades_provider.dart
/// Provider (ChangeNotifier) pour gérer l'état des notes (grades) dans l'application.
/// Utilise GradeRepository pour effectuer les opérations backend et expose l'état à la couche UI.
/// Permet de charger la liste des notes, les détails, la création, la mise à jour, la suppression, etc.
library;

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/repositories/grade_repository.dart';


enum GradesStatus { initial, loading, loaded, error }

class GradesProvider extends ChangeNotifier {
  final GradeRepository gradeRepository;

  GradesStatus _status = GradesStatus.initial;
  List<Map<String, dynamic>> _grades = [];
  Map<String, dynamic>? _selectedGrade;
  String? _errorMessage;

  GradesProvider({required this.gradeRepository});

  GradesStatus get status => _status;
  List<Map<String, dynamic>> get grades => _grades;
  Map<String, dynamic>? get selectedGrade => _selectedGrade;
  String? get errorMessage => _errorMessage;

  /// Charge la liste des notes (optionnellement pour une classe ou un élève spécifique)
  Future<void> loadGrades({String? classId, String? studentId}) async {
    _status = GradesStatus.loading;
    notifyListeners();
    try {
      _grades = await gradeRepository.getGrades(classId: classId, studentId: studentId);
      _status = GradesStatus.loaded;
    } catch (e) {
      _status = GradesStatus.error;
      _errorMessage = "Erreur lors du chargement des notes.";
    }
    notifyListeners();
  }

  /// Charge les détails d'une note
  Future<void> loadGradeById(String gradeId) async {
    _status = GradesStatus.loading;
    notifyListeners();
    try {
      _selectedGrade = await gradeRepository.getGradeById(gradeId);
      _status = GradesStatus.loaded;
    } catch (e) {
      _status = GradesStatus.error;
      _errorMessage = "Erreur lors du chargement de la note.";
    }
    notifyListeners();
  }

  /// Crée une nouvelle note
  Future<bool> createGrade(Map<String, dynamic> gradeData) async {
    _status = GradesStatus.loading;
    notifyListeners();
    try {
      final success = await gradeRepository.createGrade(gradeData);
      if (success) {
        await loadGrades();
        _status = GradesStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = GradesStatus.error;
        _errorMessage = "La création de la note a échoué.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = GradesStatus.error;
      _errorMessage = "Erreur lors de la création de la note.";
      notifyListeners();
      return false;
    }
  }

  /// Met à jour une note
  Future<bool> updateGrade(String gradeId, Map<String, dynamic> updateData) async {
    _status = GradesStatus.loading;
    notifyListeners();
    try {
      final success = await gradeRepository.updateGrade(gradeId, updateData);
      if (success) {
        await loadGradeById(gradeId);
        await loadGrades();
        _status = GradesStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = GradesStatus.error;
        _errorMessage = "La mise à jour de la note a échoué.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = GradesStatus.error;
      _errorMessage = "Erreur lors de la mise à jour de la note.";
      notifyListeners();
      return false;
    }
  }

  /// Supprime une note
  Future<bool> deleteGrade(String gradeId) async {
    _status = GradesStatus.loading;
    notifyListeners();
    try {
      final success = await gradeRepository.deleteGrade(gradeId);
      if (success) {
        await loadGrades();
        _status = GradesStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = GradesStatus.error;
        _errorMessage = "La suppression de la note a échoué.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = GradesStatus.error;
      _errorMessage = "Erreur lors de la suppression de la note.";
      notifyListeners();
      return false;
    }
  }
}