/// class_group_model.dart
/// Modèle représentant un groupe d’élèves rattaché à une classe (ex: groupes de TD, groupes personnalisés, etc.).
/// Permet de gérer des sous-ensembles d’une classe pour des activités, des projets, etc.
/// Adapté pour stockage local et API (REST, Firebase, Supabase…).
library;

import 'package:equatable/equatable.dart';

class ClassGroupModel extends Equatable {
  final String id;
  final String classId;              // ID de la classe parente
  final String? name;                // Nom du groupe (ex: Groupe A, TD2, etc.)
  final String? description;
  final List<String>? studentIds;    // IDs des membres du groupe
  final String? teacherId;           // ID du professeur responsable (optionnel)
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  // Ajoutez d’autres champs métiers si besoin (ex: couleur, niveau, etc.)

  const ClassGroupModel({
    required this.id,
    required this.classId,
    this.name,
    this.description,
    this.studentIds,
    this.teacherId,
    this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
        id,
        classId,
        name,
        description,
        studentIds,
        teacherId,
        createdAt,
        updatedAt,
        isActive,
      ];

  /// Mapping JSON <-> Objet
  factory ClassGroupModel.fromJson(Map<String, dynamic> json) => ClassGroupModel(
        id: json['id'] as String,
        classId: json['classId'] as String? ?? json['class_id'] as String,
        name: json['name'] as String?,
        description: json['description'] as String?,
        studentIds: (json['studentIds'] ?? json['student_ids']) is List
            ? List<String>.from(json['studentIds'] ?? json['student_ids'])
            : null,
        teacherId: json['teacherId'] as String? ?? json['teacher_id'] as String?,
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'classId': classId,
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (studentIds != null) 'studentIds': studentIds,
        if (teacherId != null) 'teacherId': teacherId,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
        'isActive': isActive,
      };

  /// Copie avec modifications
  ClassGroupModel copyWith({
    String? id,
    String? classId,
    String? name,
    String? description,
    List<String>? studentIds,
    String? teacherId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return ClassGroupModel(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      name: name ?? this.name,
      description: description ?? this.description,
      studentIds: studentIds ?? this.studentIds,
      teacherId: teacherId ?? this.teacherId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}