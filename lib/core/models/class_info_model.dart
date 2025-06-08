/// class_info_model.dart
/// Modèle de données représentant une classe (groupe d’élèves/professeur) dans l’application.
/// Adapté pour stockage local ou API (Firebase, Supabase, REST).
library;

import 'package:equatable/equatable.dart';

class ClassInfoModel extends Equatable {
  final String id;
  final String? name;
  final String? description;
  final String? code;              // Code unique de la classe (ex: 3A, MATH2025)
  final String? schoolId;          // ID de l’établissement
  final String? mainTeacherId;     // ID du professeur principal
  final List<String>? studentIds;  // Liste des IDs des élèves
  final int? studentCount;         // Nombre d'élèves dans la classe
  final String? level;             // Niveau de la classe (ex: Terminale, Première, etc.)
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  // Ajoutez d’autres champs métiers si besoin (ex: année scolaire…)

  const ClassInfoModel({
    required this.id,
    this.name,
    this.description,
    this.code,
    this.schoolId,
    this.mainTeacherId,
    this.studentIds,
    this.studentCount,
    this.level,
    this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        code,
        schoolId,
        mainTeacherId,
        studentIds,
        studentCount,
        level,
        createdAt,
        updatedAt,
        isActive,
      ];

  // --- Mapping JSON <-> Objet ---
  factory ClassInfoModel.fromJson(Map<String, dynamic> json) => ClassInfoModel(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
        code: json['code'] as String?,
        schoolId: json['schoolId'] as String? ?? json['school_id'] as String?,
        mainTeacherId: json['mainTeacherId'] as String? ?? json['main_teacher_id'] as String?,
        studentIds: (json['studentIds'] ?? json['student_ids']) is List
            ? List<String>.from(json['studentIds'] ?? json['student_ids'])
            : null,
        studentCount: json['studentCount'] as int? ??
            json['student_count'] as int? ??
            (json['studentIds'] != null
                ? (json['studentIds'] as List).length
                : (json['student_ids'] != null
                    ? (json['student_ids'] as List).length
                    : null)),
        level: json['level'] as String? ??
            json['classLevel'] as String? ??
            json['class_level'] as String?,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'])
            : json['created_at'] != null
                ? DateTime.tryParse(json['created_at'])
                : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'])
            : json['updated_at'] != null
                ? DateTime.tryParse(json['updated_at'])
                : null,
        isActive: json['isActive'] as bool? ?? json['is_active'] as bool? ?? true,
      );

  /// Pour une future extension : progress et nextTopic si tu veux utiliser de la progression dans les dashboards
  double get progress {
    // Ex : retourne un pourcentage d'avancement fictif, sinon à surcharger/étendre dans un autre model
    // Ici, tu pourrais brancher sur d'autres données (ex: nb chapitres terminés / total)
    return 0.0;
  }

  String? get nextTopic {
    // Ex : retourne le prochain chapitre, à surcharger/étendre
    return null;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (code != null) 'code': code,
        if (schoolId != null) 'schoolId': schoolId,
        if (mainTeacherId != null) 'mainTeacherId': mainTeacherId,
        if (studentIds != null) 'studentIds': studentIds,
        if (studentCount != null) 'studentCount': studentCount,
        if (level != null) 'level': level,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
        'isActive': isActive,
      };

  /// Copie avec modifications
  ClassInfoModel copyWith({
    String? id,
    String? name,
    String? description,
    String? code,
    String? schoolId,
    String? mainTeacherId,
    List<String>? studentIds,
    int? studentCount,
    String? level,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return ClassInfoModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      code: code ?? this.code,
      schoolId: schoolId ?? this.schoolId,
      mainTeacherId: mainTeacherId ?? this.mainTeacherId,
      studentIds: studentIds ?? this.studentIds,
      studentCount: studentCount ?? this.studentCount,
      level: level ?? this.level,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}