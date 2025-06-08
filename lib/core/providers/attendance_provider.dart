/// attendance_provider.dart
/// Provider (ChangeNotifier) pour gérer l'état des présences (attendance) dans l'application.
/// Utilise AttendanceRepository pour effectuer les opérations backend et expose l'état à la couche UI.
/// Permet de charger la liste des présences, les détails, la création, la mise à jour, la suppression, etc.
library;

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/repositories/attendance_repository.dart';


enum AttendanceStatus { initial, loading, loaded, error }

class AttendanceProvider extends ChangeNotifier {
  final AttendanceRepository attendanceRepository;

  AttendanceStatus _status = AttendanceStatus.initial;
  List<Map<String, dynamic>> _attendances = [];
  Map<String, dynamic>? _selectedAttendance;
  String? _errorMessage;

  AttendanceProvider({required this.attendanceRepository});

  AttendanceStatus get status => _status;
  List<Map<String, dynamic>> get attendances => _attendances;
  Map<String, dynamic>? get selectedAttendance => _selectedAttendance;
  String? get errorMessage => _errorMessage;

  /// Charge la liste des présences (optionnellement pour une classe ou un élève spécifique)
  Future<void> loadAttendances({String? classId, String? studentId}) async {
    _status = AttendanceStatus.loading;
    notifyListeners();
    try {
      _attendances = await attendanceRepository.getAttendances(classId: classId, studentId: studentId);
      _status = AttendanceStatus.loaded;
    } catch (e) {
      _status = AttendanceStatus.error;
      _errorMessage = "Erreur lors du chargement des présences.";
    }
    notifyListeners();
  }

  /// Charge les détails d'une présence
  Future<void> loadAttendanceById(String attendanceId) async {
    _status = AttendanceStatus.loading;
    notifyListeners();
    try {
      _selectedAttendance = await attendanceRepository.getAttendanceById(attendanceId);
      _status = AttendanceStatus.loaded;
    } catch (e) {
      _status = AttendanceStatus.error;
      _errorMessage = "Erreur lors du chargement de la présence.";
    }
    notifyListeners();
  }

  /// Crée une nouvelle présence
  Future<bool> createAttendance(Map<String, dynamic> attendanceData) async {
    _status = AttendanceStatus.loading;
    notifyListeners();
    try {
      final success = await attendanceRepository.createAttendance(attendanceData);
      if (success) {
        await loadAttendances();
        _status = AttendanceStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = AttendanceStatus.error;
        _errorMessage = "La création de la présence a échoué.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AttendanceStatus.error;
      _errorMessage = "Erreur lors de la création de la présence.";
      notifyListeners();
      return false;
    }
  }

  /// Met à jour une présence
  Future<bool> updateAttendance(String attendanceId, Map<String, dynamic> updateData) async {
    _status = AttendanceStatus.loading;
    notifyListeners();
    try {
      final success = await attendanceRepository.updateAttendance(attendanceId, updateData);
      if (success) {
        await loadAttendanceById(attendanceId);
        await loadAttendances();
        _status = AttendanceStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = AttendanceStatus.error;
        _errorMessage = "La mise à jour de la présence a échoué.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AttendanceStatus.error;
      _errorMessage = "Erreur lors de la mise à jour de la présence.";
      notifyListeners();
      return false;
    }
  }

  /// Supprime une présence
  Future<bool> deleteAttendance(String attendanceId) async {
    _status = AttendanceStatus.loading;
    notifyListeners();
    try {
      final success = await attendanceRepository.deleteAttendance(attendanceId);
      if (success) {
        await loadAttendances();
        _status = AttendanceStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = AttendanceStatus.error;
        _errorMessage = "La suppression de la présence a échoué.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AttendanceStatus.error;
      _errorMessage = "Erreur lors de la suppression de la présence.";
      notifyListeners();
      return false;
    }
  }
}