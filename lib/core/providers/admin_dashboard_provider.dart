/// admin_dashboard_provider.dart
/// Provider (ChangeNotifier) pour gérer l'état du tableau de bord administrateur.
/// Permet de charger les informations importantes et synthétiques pour l'administrateur
/// (nombre d'élèves, classes, enseignants, annonces, etc).
/// Vous devez adapter les méthodes selon les repositories/services disponibles dans votre projet.

// ignore_for_file: dangling_library_doc_comments

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/extensions/map_extensions.dart';
import 'package:gestion_ecole/core/repositories/announcement_repository.dart';
import 'package:gestion_ecole/core/repositories/class_repository.dart';
import 'package:gestion_ecole/core/repositories/user_repository.dart';
import 'package:gestion_ecole/core/models/user_model.dart';
import 'package:gestion_ecole/core/models/class_info_model.dart';
import 'package:gestion_ecole/core/models/announcement_model.dart';

enum AdminDashboardStatus { initial, loading, loaded, error }

class AdminDashboardProvider extends ChangeNotifier {
  final UserRepository userRepository;
  final ClassRepository classRepository;
  final AnnouncementRepository announcementRepository;

  AdminDashboardStatus _status = AdminDashboardStatus.initial;
  int _studentsCount = 0;
  int _teachersCount = 0;
  int _classesCount = 0;
  int _announcementsCount = 0;
  String? _errorMessage;

  UserModel? _currentUser;
  List<UserModel>? _userList;
  List<ClassInfoModel>? _classList;
  List<AnnouncementModel>? _announcementList;
  int? _activeUsers;
  int? _totalPayments;

  AdminDashboardProvider({
    required this.userRepository,
    required this.classRepository,
    required this.announcementRepository,
  });

  AdminDashboardStatus get status => _status;
  int get studentsCount => _studentsCount;
  int get teachersCount => _teachersCount;
  int get classesCount => _classesCount;
  int get announcementsCount => _announcementsCount;
  String? get errorMessage => _errorMessage;

  /// Nouveaux getters demandés
  UserModel? get currentUser => _currentUser;
  List<UserModel>? get userList => _userList;
  List<ClassInfoModel>? get classList => _classList;
  List<AnnouncementModel>? get announcementList => _announcementList;
  int? get activeUsers => _activeUsers;
  int? get totalPayments => _totalPayments;

  /// Charge toutes les informations du dashboard administrateur
  Future<void> loadDashboard() async {
    _status = AdminDashboardStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      // Charger l'utilisateur courant (ADMIN)
      _currentUser = (await userRepository.getCurrentUser()) as UserModel?;

      // Charger tous les utilisateurs (élèves/profs/admins)
      final users = await userRepository.getUsers();
      _userList = users.cast<UserModel>();
      _studentsCount = users.where((u) => u.role == 'student').length;
      _teachersCount = users.where((u) => u.role == 'teacher').length;

      // Pour la stat d'utilisateurs actifs (exemple : tous connectés dans les dernières 24h)
      _activeUsers = users.where((u) => u.isActive == true).length;

      // Charger toutes les classes
      final classes = await classRepository.getClasses();
      _classList = classes.cast<ClassInfoModel>();
      _classesCount = classes.length;

      // Charger toutes les annonces
      final announcements = await announcementRepository.getAnnouncements();
      _announcementList = announcements.cast<AnnouncementModel>();
      _announcementsCount = announcements.length;

      // Paiements (adapte selon tes services/metiers)
      // Exemple fictif: userRepository.getTotalPayments() ou PaymentRepository.getTotalPayments()
      // Ici, on met un mock :
      _totalPayments = 123; // À remplacer par une vraie méthode

      _status = AdminDashboardStatus.loaded;
    } catch (e) {
      _status = AdminDashboardStatus.error;
      _errorMessage = "Erreur lors du chargement du tableau de bord administrateur.";
    }
    notifyListeners();
  }
}
