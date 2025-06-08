/// assignment_list_provider.dart
/// Provider (ChangeNotifier) pour gérer l'état et les données de la liste des devoirs.
library;

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/models/assignment_model.dart';
import 'package:gestion_ecole/core/repositories/assignment_repository.dart';
import 'package:flutter/foundation.dart'; // Pour debugPrint

/// Enum pour l'état de la liste des devoirs
enum AssignmentListStatus { initial, loading, loaded, error }

class AssignmentListProvider extends ChangeNotifier {
  final AssignmentRepository assignmentRepository;

  AssignmentListStatus _status = AssignmentListStatus.initial;
  String? _errorMessage;
  List<AssignmentModel> _assignments = [];

  AssignmentListProvider({required this.assignmentRepository});

  AssignmentListStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<AssignmentModel> get assignments => _assignments;

  /// Charge la liste des devoirs.
  /// Peut prendre des paramètres pour filtrer la liste (ex: par classe, enseignant, étudiant, à corriger).
  Future<void> loadAssignments({
    String? classId,
    String? teacherId,
    String? studentId,
    bool? toReview,
  }) async {
    // Empêche les chargements multiples si un est déjà en cours
    if (_status == AssignmentListStatus.loading) {
      debugPrint('AssignmentListProvider: Already loading, ignoring request.');
      return;
    }

    _status = AssignmentListStatus.loading;
    _errorMessage = null;
    _assignments = []; // Efface la liste précédente lors du chargement
    notifyListeners();

    try {
      // Appelle le repository avec les paramètres de filtrage
      // Le repository est responsable du mapping des données brutes vers AssignmentModel
      _assignments = (await assignmentRepository.getAssignments(
        classId: classId,
        teacherId: teacherId,
        studentId: studentId,
        toReview: toReview,
      )).cast<AssignmentModel>();

      _status = AssignmentListStatus.loaded;

      debugPrint('AssignmentListProvider: Assignments loaded successfully. Count: ${_assignments.length}');

    } catch (e, st) {
      _status = AssignmentListStatus.error;
      // Inclut le type d'erreur dans le message de débogage pour plus de détails
      _errorMessage = "Erreur lors du chargement des devoirs : ${e.toString()}";
      debugPrint('AssignmentListProvider: Error loading assignments: ${e.runtimeType} - $e');
      debugPrint('Stack: $st');
    } finally {
      // Notifie toujours les auditeurs pour mettre à jour l'état de l'UI (loading, loaded, error)
      notifyListeners();
    }
  }


  // Ajoutez d'autres méthodes si nécessaire (ex: supprimer un devoir de la liste après suppression API)
}
