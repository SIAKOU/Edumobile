/// student_dashboard_provider.dart
/// Provider (ChangeNotifier) pour gérer l'état du tableau de bord étudiant.
/// Permet de charger les informations importantes et synthétiques pour l'élève (notes, présences, annonces, etc).
/// Vous devez adapter les méthodes selon les repositories/services disponibles dans votre projet.
// ignore_for_file: prefer_final_fields

library;

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/models/announcement_model.dart';
import 'package:gestion_ecole/core/models/class_info_model.dart';
import 'package:gestion_ecole/core/models/grade_model.dart';
import 'package:gestion_ecole/core/models/user_model.dart';
import 'package:gestion_ecole/core/repositories/announcement_repository.dart';
import 'package:gestion_ecole/core/repositories/class_repository.dart';
import 'package:gestion_ecole/core/repositories/schedule_Repository.dart';
import 'package:gestion_ecole/core/repositories/grade_repository.dart';
import 'package:gestion_ecole/core/repositories/user_repository.dart';
import 'package:flutter/foundation.dart'; // Import pour debugPrint

enum StudentDashboardStatus { initial, loading, loaded, error }

class StudentDashboardProvider extends ChangeNotifier {
  final UserRepository userRepository;
  final GradeRepository gradeRepository;
  // Correction de la faute de frappe ici et dans le constructeur
 final ClassRepository classRepository;
 final ScheduleRepository scheduleRepository;
  final AnnouncementRepository announcementRepository;

  StudentDashboardStatus _status = StudentDashboardStatus.initial;
  // Stocker directement le modèle utilisateur
  UserModel? _studentProfile;
  // Stocker directement les listes de modèles
  List<GradeModel> _grades = [];
  List<AnnouncementModel> _announcements = []; // Correction de la faute de frappe
  // Ajout des champs manquants pour les autres getters
  List<ClassInfoModel> _classList = [];
  List<dynamic> _upcomingEvents = []; // Type à adapter si besoin

  String? _errorMessage;

  StudentDashboardProvider({
    required this.userRepository,
    required this.gradeRepository,
 required this.classRepository,
 required this.scheduleRepository,
    // Correction de la faute de frappe dans le nom du paramètre
    required this.announcementRepository,
  }); // Assigner le paramètre corrigé

  StudentDashboardStatus get status => _status;
  // Retourne directement le modèle utilisateur
  UserModel? get studentProfile => _studentProfile;
  // Retourne directement les listes de modèles
  List<GradeModel> get grades => _grades;
  List<AnnouncementModel> get announcements => _announcements; // Correction de la faute de frappe
  String? get errorMessage => _errorMessage;

  /// Liste des classes chargées
  // Retourne le champ privé corrigé
  List<ClassInfoModel> get classList => _classList;

  /// Liste des notes/grades chargées
  // Retourne le champ privé corrigé
  List<GradeModel> get gradeList => _grades;

  /// Liste des annonces chargées
  // Retourne le champ privé corrigé
  List<AnnouncementModel> get announcementList => _announcements;

  /// Liste des évènements à venir (adapte le type si besoin)
  // Retourne le champ privé corrigé
  List<dynamic> get upcomingEvents => _upcomingEvents;

  // Ce getter semble redondant avec studentProfile, mais le garde pour l'instant
  // Il devrait retourner _studentProfile
  UserModel? get currentUser => _studentProfile;
  


  /// Charge toutes les informations du dashboard étudiant
  Future<void> loadDashboard(String studentId) async {
    if (_status == StudentDashboardStatus.loading) return; // Empêche les chargements multiples

    _status = StudentDashboardStatus.loading;
    _errorMessage = null; // Réinitialise le message d'erreur
    notifyListeners();

    try {
      // Charger le profil étudiant et mapper en UserModel
      final profileData = await userRepository.getUserById(studentId);
      if (profileData != null) {
        _studentProfile = UserModel.fromJson(profileData); // Assurez-vous que UserModel a un fromJson
      } else {
         _studentProfile = null;
         debugPrint('StudentDashboardProvider: Profil étudiant non trouvé pour ID $studentId');
      }


      // Charger les notes et mapper en List<GradeModel>
      final gradesData = await gradeRepository.getGrades(studentId: studentId);
      _grades = gradesData.map((data) => GradeModel.fromJson(data)).toList(); // Assurez-vous que GradeModel a un fromJson

      // Charger les annonces et mapper en List<AnnouncementModel>
      final announcementsData = await announcementRepository.getAnnouncements(); // Correction de la faute de frappe
      _announcements = announcementsData.map((data) => AnnouncementModel.fromJson(data)).toList(); // Assurez-vous que AnnouncementModel a un fromJson

     
      // Charger les classes et mapper en List<ClassInfoModel>
      final classListData = await classRepository.getClasses(studentId: studentId);
      _classList = classListData.map((data) => ClassInfoModel.fromJson(data)).toList();
      final eventsData = await scheduleRepository.getUpcomingEvents(studentId,);
      _upcomingEvents = eventsData; // Adapter le mapping si les événements ont un modèle spécifique


      _status = StudentDashboardStatus.loaded;
      debugPrint('StudentDashboardProvider: Tableau de bord chargé avec succès pour ID $studentId');

    } catch (e, stack) {
      _status = StudentDashboardStatus.error;
      _errorMessage = "Erreur lors du chargement du tableau de bord étudiant.";
      debugPrint('StudentDashboardProvider: Erreur lors du chargement du tableau de bord: $e');
      debugPrint('Stack: $stack');
    } finally {
       notifyListeners(); // Notifie les auditeurs même en cas d'erreur
    }
  }

  /// Rafraîchit uniquement les notes de l'étudiant
  Future<void> refreshGrades(String studentId) async {
     _errorMessage = null; // Réinitialise le message d'erreur spécifique
    try {
      final gradesData = await gradeRepository.getGrades(studentId: studentId);
      _grades = gradesData.map((data) => GradeModel.fromJson(data)).toList();
      debugPrint('StudentDashboardProvider: Notes rafraîchies avec succès pour ID $studentId');
    } catch (e, stack) {
      _errorMessage = "Erreur lors du rafraîchissement des notes.";
      debugPrint('StudentDashboardProvider: Erreur lors du rafraîchissement des notes: $e');
      debugPrint('Stack: $stack');
    } finally {
       notifyListeners();
    }
  }

  /// Rafraîchit uniquement les annonces
  Future<void> refreshAnnouncements() async { // Correction du nom de la méthode
     _errorMessage = null; // Réinitialise le message d'erreur spécifique
    try {
      final announcementsData = await announcementRepository.getAnnouncements(); // Correction de la faute de frappe
      _announcements = announcementsData.map((data) => AnnouncementModel.fromJson(data)).toList();
      debugPrint('StudentDashboardProvider: Annonces rafraîchies avec succès.');
    } catch (e, stack) {
      _errorMessage = "Erreur lors du rafraîchissement des annonces.";
      debugPrint('StudentDashboardProvider: Erreur lors du rafraîchissement des annonces: $e');
      debugPrint('Stack: $stack');
    } finally {
       notifyListeners();
    }
  }

  /// Rafraîchit uniquement le profil de l'étudiant
  Future<void> refreshProfile(String studentId) async {
     _errorMessage = null; // Réinitialise le message d'erreur spécifique
    try {
      final profileData = await userRepository.getUserById(studentId);
       if (profileData != null) {
        _studentProfile = UserModel.fromJson(profileData);
        debugPrint('StudentDashboardProvider: Profil étudiant rafraîchi avec succès pour ID $studentId');
      } else {
         _studentProfile = null;
         debugPrint('StudentDashboardProvider: Profil étudiant non trouvé lors du rafraîchissement pour ID $studentId');
      }
    } catch (e, stack) {
      _errorMessage = "Erreur lors du rafraîchissement du profil.";
      debugPrint('StudentDashboardProvider: Erreur lors du rafraîchissement du profil: $e');
      debugPrint('Stack: $stack');
    } finally {
       notifyListeners();
    }
  }

  /// stats
  // Ajoutez ici des méthodes pour calculer ou récupérer des statistiques si nécessaire
}
