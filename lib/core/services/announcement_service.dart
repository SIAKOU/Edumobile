import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:gestion_ecole/core/models/announcement_model.dart'; // Mets le bon chemin vers ton modèle

/// Service pour la gestion des annonces (announcements)
class AnnouncementService {
  // Singleton
  AnnouncementService._();
  static final AnnouncementService instance = AnnouncementService._();

  // Données fictives (remplace par un backend réel)
  final List<AnnouncementModel> _fakeData = [
    AnnouncementModel(
      id: '1',
      title: 'Contrôle de mathématiques',
      content: 'Un contrôle aura lieu le vendredi 7 juin à 10h.',
      authorId: 'u1',
      classId: 'c1',
      createdAt: DateTime(2025, 5, 28),
      isActive: true,
    ),
    AnnouncementModel(
      id: '2',
      title: 'Sortie scolaire',
      content: 'Sortie prévue le mardi 17 juin, pensez à rendre l\'autorisation signée.',
      authorId: 'u2',
      classId: 'c1',
      createdAt: DateTime(2025, 5, 29),
      isActive: true,
    ),
  ];

  /// Récupère toutes les annonces (optionnellement filtrées par classe)
  Future<List<AnnouncementModel>> getAll({String? classId, bool includeInactive = false}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _fakeData
        .where((a) =>
            (classId == null || a.classId == classId) &&
            (includeInactive || (a.isActive && a.deletedAt == null)))
        .toList();
  }

  /// Récupère une annonce par id
  Future<AnnouncementModel?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      final a = _fakeData.firstWhere((a) => a.id == id && a.deletedAt == null);
      return a;
    } catch (_) {
      return null;
    }
  }

  /// Crée une nouvelle annonce (génère un id unique si besoin)
  Future<AnnouncementModel> create(AnnouncementModel announcement) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final newId = announcement.id.isEmpty
        ? DateTime.now().millisecondsSinceEpoch.toString() + Random().nextInt(9999).toString()
        : announcement.id;
    final newAnnouncement = announcement.copyWith(
      id: newId,
      createdAt: DateTime.now(),
      isActive: true,
      deletedAt: null,
    );
    _fakeData.add(newAnnouncement);
    return newAnnouncement;
  }

  /// Met à jour une annonce existante
  Future<AnnouncementModel?> update(AnnouncementModel updated) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final idx = _fakeData.indexWhere((a) => a.id == updated.id && a.deletedAt == null);
    if (idx != -1) {
      _fakeData[idx] = updated.copyWith(
        // On ne modifie pas createdAt ni deletedAt ici
        createdAt: _fakeData[idx].createdAt,
        deletedAt: _fakeData[idx].deletedAt,
      );
      return _fakeData[idx];
    }
    return null;
  }

  /// Supprime (soft delete) une annonce
  Future<bool> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final idx = _fakeData.indexWhere((a) => a.id == id && a.deletedAt == null);
    if (idx != -1) {
      _fakeData[idx] = _fakeData[idx].copyWith(
        isActive: false,
        deletedAt: DateTime.now(),
      );
      return true;
    }
    return false;
  }

  Future<List<AnnouncementModel>> getForClass(String classId) async {
    return getAll(classId: classId);
  }
}