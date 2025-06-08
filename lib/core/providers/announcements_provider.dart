/// announcements_provider.dart
/// Provider (ChangeNotifier) pour gérer l'état des annonces (announcements) dans l'application.
/// Utilise AnouncementRepository pour effectuer les opérations backend et expose l'état à la couche UI.
/// Permet de charger la liste des annonces, les détails, la création, la mise à jour, la suppression, etc.
library;

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/repositories/announcement_repository.dart';


enum AnnouncementsStatus { initial, loading, loaded, error }

class AnnouncementsProvider extends ChangeNotifier {
  final AnnouncementRepository anouncementRepository;

  AnnouncementsStatus _status = AnnouncementsStatus.initial;
  List<Map<String, dynamic>> _announcements = [];
  Map<String, dynamic>? _selectedAnnouncement;
  String? _errorMessage;

  AnnouncementsProvider({required this.anouncementRepository});

  AnnouncementsStatus get status => _status;
  List<Map<String, dynamic>> get announcements => _announcements;
  Map<String, dynamic>? get selectedAnnouncement => _selectedAnnouncement;
  String? get errorMessage => _errorMessage;

  /// Charge la liste des annonces
  Future<void> loadAnnouncements() async {
    _status = AnnouncementsStatus.loading;
    notifyListeners();
    try {
      _announcements = await anouncementRepository.getAnnouncements();
      _status = AnnouncementsStatus.loaded;
    } catch (e) {
      _status = AnnouncementsStatus.error;
      _errorMessage = "Erreur lors du chargement des annonces.";
    }
    notifyListeners();
  }

  /// Charge les détails d'une annonce
  Future<void> loadAnnouncementById(String announcementId) async {
    _status = AnnouncementsStatus.loading;
    notifyListeners();
    try {
      _selectedAnnouncement = await anouncementRepository.getAnnouncementById(announcementId);
      _status = AnnouncementsStatus.loaded;
    } catch (e) {
      _status = AnnouncementsStatus.error;
      _errorMessage = "Erreur lors du chargement de l'annonce.";
    }
    notifyListeners();
  }

  /// Crée une nouvelle annonce
  Future<bool> createAnnouncement(Map<String, dynamic> announcementData) async {
    _status = AnnouncementsStatus.loading;
    notifyListeners();
    try {
      final success = await anouncementRepository.createAnnouncement(announcementData);
      if (success) {
        await loadAnnouncements();
        _status = AnnouncementsStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = AnnouncementsStatus.error;
        _errorMessage = "La création de l'annonce a échoué.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AnnouncementsStatus.error;
      _errorMessage = "Erreur lors de la création de l'annonce.";
      notifyListeners();
      return false;
    }
  }

  /// Met à jour une annonce
  Future<bool> updateAnnouncement(String announcementId, Map<String, dynamic> updateData) async {
    _status = AnnouncementsStatus.loading;
    notifyListeners();
    try {
      final success = await anouncementRepository.updateAnnouncement(announcementId, updateData);
      if (success) {
        await loadAnnouncementById(announcementId);
        await loadAnnouncements();
        _status = AnnouncementsStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = AnnouncementsStatus.error;
        _errorMessage = "La mise à jour de l'annonce a échoué.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AnnouncementsStatus.error;
      _errorMessage = "Erreur lors de la mise à jour de l'annonce.";
      notifyListeners();
      return false;
    }
  }

  /// Supprime une annonce
  Future<bool> deleteAnnouncement(String announcementId) async {
    _status = AnnouncementsStatus.loading;
    notifyListeners();
    try {
      final success = await anouncementRepository.deleteAnnouncement(announcementId);
      if (success) {
        await loadAnnouncements();
        _status = AnnouncementsStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = AnnouncementsStatus.error;
        _errorMessage = "La suppression de l'annonce a échoué.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AnnouncementsStatus.error;
      _errorMessage = "Erreur lors de la suppression de l'annonce.";
      notifyListeners();
      return false;
    }
  }
}