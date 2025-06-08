/// schedule_provider.dart
/// Provider (ChangeNotifier) pour gérer l'état de l'emploi du temps (schedule) dans l'application.
/// Utilise ScheduleRepository pour effectuer les opérations backend et expose l'état à la couche UI.
/// Permet de charger, créer, mettre à jour et supprimer les emplois du temps.
library;

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/repositories/schedule_Repository.dart';


enum ScheduleStatus { initial, loading, loaded, error }

class ScheduleProvider extends ChangeNotifier {
  final ScheduleRepository scheduleRepository;

  ScheduleStatus _status = ScheduleStatus.initial;
  List<Map<String, dynamic>> _schedules = [];
  Map<String, dynamic>? _selectedSchedule;
  String? _errorMessage;

  ScheduleProvider({required this.scheduleRepository});

  ScheduleStatus get status => _status;
  List<Map<String, dynamic>> get schedules => _schedules;
  Map<String, dynamic>? get selectedSchedule => _selectedSchedule;
  String? get errorMessage => _errorMessage;

  /// Charge la liste des emplois du temps (optionnellement pour une classe ou un élève spécifique)
  Future<void> loadSchedules({String? classId, String? studentId}) async {
    _status = ScheduleStatus.loading;
    notifyListeners();
    try {
      _schedules = await scheduleRepository.getSchedules(classId: classId, studentId: studentId);
      _status = ScheduleStatus.loaded;
    } catch (e) {
      _status = ScheduleStatus.error;
      _errorMessage = "Erreur lors du chargement de l'emploi du temps.";
    }
    notifyListeners();
  }

  /// Charge les détails d'un emploi du temps
  Future<void> loadScheduleById(String scheduleId) async {
    _status = ScheduleStatus.loading;
    notifyListeners();
    try {
      _selectedSchedule = await scheduleRepository.getScheduleById(scheduleId);
      _status = ScheduleStatus.loaded;
    } catch (e) {
      _status = ScheduleStatus.error;
      _errorMessage = "Erreur lors du chargement de l'emploi du temps.";
    }
    notifyListeners();
  }

  /// Crée un nouvel emploi du temps
  Future<bool> createSchedule(Map<String, dynamic> scheduleData) async {
    _status = ScheduleStatus.loading;
    notifyListeners();
    try {
      final success = await scheduleRepository.createSchedule(scheduleData);
      if (success) {
        await loadSchedules();
        _status = ScheduleStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = ScheduleStatus.error;
        _errorMessage = "La création de l'emploi du temps a échoué.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = ScheduleStatus.error;
      _errorMessage = "Erreur lors de la création de l'emploi du temps.";
      notifyListeners();
      return false;
    }
  }

  /// Met à jour un emploi du temps
  Future<bool> updateSchedule(String scheduleId, Map<String, dynamic> updateData) async {
    _status = ScheduleStatus.loading;
    notifyListeners();
    try {
      final success = await scheduleRepository.updateSchedule(scheduleId, updateData);
      if (success) {
        await loadScheduleById(scheduleId);
        await loadSchedules();
        _status = ScheduleStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = ScheduleStatus.error;
        _errorMessage = "La mise à jour de l'emploi du temps a échoué.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = ScheduleStatus.error;
      _errorMessage = "Erreur lors de la mise à jour de l'emploi du temps.";
      notifyListeners();
      return false;
    }
  }

  /// Supprime un emploi du temps
  Future<bool> deleteSchedule(String scheduleId) async {
    _status = ScheduleStatus.loading;
    notifyListeners();
    try {
      final success = await scheduleRepository.deleteSchedule(scheduleId);
      if (success) {
        await loadSchedules();
        _status = ScheduleStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = ScheduleStatus.error;
        _errorMessage = "La suppression de l'emploi du temps a échoué.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = ScheduleStatus.error;
      _errorMessage = "Erreur lors de la suppression de l'emploi du temps.";
      notifyListeners();
      return false;
    }
  }

  Future getSchedulesForClass(String classId) async {}
}