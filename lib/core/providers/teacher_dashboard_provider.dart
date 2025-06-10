// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // Import for ChangeNotifier
import 'package:gestion_ecole/core/repositories/announcement_repository.dart';
import 'package:gestion_ecole/core/repositories/class_repository.dart';
import 'package:gestion_ecole/core/repositories/grade_repository.dart';
import 'package:gestion_ecole/core/repositories/user_repository.dart';
import 'package:gestion_ecole/core/repositories/assignment_repository.dart';

import '../models/user_model.dart';
import '../models/class_info_model.dart';
import '../models/assignment_model.dart';
import '../models/announcement_model.dart';

/// Enum for dashboard state
enum TeacherDashboardState { initial, loading, loaded, error }

class TeacherDashboardProvider extends ChangeNotifier {
  TeacherDashboardState _state = TeacherDashboardState.initial;
  TeacherDashboardState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  List<ClassInfoModel> _classList = [];
  List<ClassInfoModel> get classList => _classList;

  List<AssignmentModel> _assignmentsToReview = [];
  List<AssignmentModel> get assignmentsToReview => _assignmentsToReview;

  List<AnnouncementModel> _announcementList = [];
  List<AnnouncementModel> get announcementList => _announcementList;

  List<dynamic> _upcomingEvents = [];
  List<dynamic> get upcomingEvents => _upcomingEvents;

  final UserRepository userRepository;
  final ClassRepository classRepository;
  final AnnouncementRepository announcementRepository;
  final GradeRepository gradeRepository;
  final AssignmentRepository assignmentRepository;

  TeacherDashboardProvider({
    required this.userRepository,
    required this.classRepository,
    required this.announcementRepository,
    required this.gradeRepository,
    required this.assignmentRepository,
  }) {
    loadDashboard();
  }

  /// Loads all teacher dashboard data
  Future<void> loadDashboard() async {
    if (_state == TeacherDashboardState.loading) return;

    _state = TeacherDashboardState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final userData = await userRepository.getCurrentUser();
      if (userData != null) {
        _currentUser = UserModel.fromJson(userData);
      } else {
        _currentUser = null;
        debugPrint('TeacherDashboardProvider: Current user not found.');
      }

      final classListData = await classRepository.getClasses(studentId: '');
      _classList = classListData
          .map((data) => ClassInfoModel.fromJson(data))
          .toList();

      final assignmentsData = await assignmentRepository.getAssignmentsToReview();
      _assignmentsToReview = assignmentsData
          .map((data) => AssignmentModel.fromJson(data))
          .toList();

      final announcementsData = await announcementRepository.getAnnouncements();
      _announcementList = announcementsData
          .map((data) => AnnouncementModel.fromJson(data))
          .toList();

      _upcomingEvents = [];
      for (var assignment in _assignmentsToReview) {
        _upcomingEvents
            .add({'title': assignment.title, 'date': assignment.dueDate});
      }
      for (var announcement in _announcementList) {
        if (announcement.publishedAt != null) {
          _upcomingEvents.add(
              {'title': announcement.title, 'date': announcement.publishedAt});
        }
      }
      _upcomingEvents.sort(
          (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));

      _state = TeacherDashboardState.loaded;
      debugPrint('TeacherDashboardProvider: Teacher dashboard loaded successfully.');
    } catch (e, st) {
      _errorMessage = "Error loading teacher dashboard: ${e.toString()}";
      _state = TeacherDashboardState.error;
      debugPrint('TeacherDashboardProvider: Error loading dashboard: $e');
      debugPrint('Stack: $st');
    } finally {
      notifyListeners();
    }
  }

  /// Refreshes current user data
  Future<void> refreshCurrentUser() async {
    _errorMessage = null;
    try {
      final userData = await userRepository.getCurrentUser();
      if (userData != null) {
        _currentUser = UserModel.fromJson(userData);
        debugPrint('TeacherDashboardProvider: Current user refreshed.');
      } else {
        _currentUser = null;
        debugPrint('TeacherDashboardProvider: Current user not found during refresh.');
      }
    } catch (e, st) {
      _errorMessage = "Error refreshing user: ${e.toString()}";
      debugPrint('TeacherDashboardProvider: Error refreshing user: $e');
      debugPrint('Stack: $st');
    } finally {
      notifyListeners();
    }
  }

  /// Refreshes class list
  Future<void> refreshClassList() async {
    _errorMessage = null;
    try {
      final classListData = await classRepository.getClasses(studentId: '');
      _classList =
          classListData.map((data) => ClassInfoModel.fromJson(data)).toList();
      debugPrint('TeacherDashboardProvider: Class list refreshed.');
    } catch (e, st) {
      _errorMessage = "Error refreshing classes: ${e.toString()}";
      debugPrint('TeacherDashboardProvider: Error refreshing classes: $e');
      debugPrint('Stack: $st');
    } finally {
      notifyListeners();
    }
  }

  /// Refreshes assignments to review
  Future<void> refreshAssignmentsToReview() async {
    _errorMessage = null;
    try {
      final assignmentsData =
          await assignmentRepository.getAssignmentsToReview();
      _assignmentsToReview = assignmentsData
          .map((data) => AssignmentModel.fromJson(data))
          .toList();

      _upcomingEvents = [];
      for (var assignment in _assignmentsToReview) {
        _upcomingEvents
            .add({'title': assignment.title, 'date': assignment.dueDate});
      }
      for (var announcement in _announcementList) {
        if (announcement.publishedAt != null) {
          _upcomingEvents.add(
              {'title': announcement.title, 'date': announcement.publishedAt});
        }
      }
      _upcomingEvents.sort(
          (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));

      debugPrint('TeacherDashboardProvider: Assignments to review refreshed.');
    } catch (e, st) {
      _errorMessage = "Error refreshing assignments: ${e.toString()}";
      debugPrint('TeacherDashboardProvider: Error refreshing assignments: $e');
      debugPrint('Stack: $st');
    } finally {
      notifyListeners();
    }
  }

  /// Refreshes announcement list
  Future<void> refreshAnnouncementList() async {
    _errorMessage = null;
    try {
      final announcementsData = await announcementRepository.getAnnouncements();
      _announcementList = announcementsData
          .map((data) => AnnouncementModel.fromJson(data))
          .toList();

      _upcomingEvents = [];
      _assignmentsToReview.forEach((assignment) {
        _upcomingEvents
            .add({'title': assignment.title, 'date': assignment.dueDate});
      });
      _announcementList.forEach((announcement) {
        if (announcement.publishedAt != null) {
          _upcomingEvents.add(
              {'title': announcement.title, 'date': announcement.publishedAt});
        }
      });
      _upcomingEvents.sort(
          (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));

      debugPrint('TeacherDashboardProvider: Announcement list refreshed.');
    } catch (e, st) {
      _errorMessage = "Error refreshing announcements: ${e.toString()}";
      debugPrint('TeacherDashboardProvider: Error refreshing announcements: $e');
      debugPrint('Stack: $st');
    } finally {
      notifyListeners();
    }
  }
}

extension FutureListMapExtension<T> on Future<List<T>> {
  Future<List<R>> map<R>(R Function(T element) f) async {
    final List<T> list = await this;
    return list.map(f).toList();
  }
  
  List<AssignmentModel> toList() {
    return map((item) => AssignmentModel.fromJson(item)).toList();
  }
}
