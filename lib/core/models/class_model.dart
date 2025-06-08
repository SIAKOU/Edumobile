/// class_model.dart
/// Modèle de données représentant une classe dans l'établissement.
/// Conçu pour être utilisé avec des APIs REST, Firestore, Supabase, etc.
/// Ajoutez ou adaptez les champs selon vos besoins métiers.
library;

import 'package:equatable/equatable.dart';

class ClassModel extends Equatable {
  final String id;
  final String name;
  final String? code;
  final String? level;      // ex: "6ème", "Terminale", "CP", etc.
  final String? section;    // ex: "Scientifique", "Littéraire", "Générale"
  final String? schoolYear; // ex: "2024-2025"
  final int? studentCount;  // nombre d'élèves inscrits
  final String? teacherId;  // responsable principal (professeur)
  final String? teacherName;
  final bool? isArchived;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? room;       // salle de classe

  // Ajoutez d'autres champs métiers si besoin (description, effectif max, etc.)

  const ClassModel({
    required this.id,
    required this.name,
    this.code,
    this.level,
    this.section,
    this.schoolYear,
    this.studentCount,
    this.teacherId,
    this.teacherName,
    this.isArchived,
    this.createdAt,
    this.updatedAt,
    this.room,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    code,
    level,
    section,
    schoolYear,
    studentCount,
    teacherId,
    teacherName,
    isArchived,
    createdAt,
    updatedAt,
    room,
  ];

  /// Factory pour créer un ClassModel depuis du JSON (API, Firestore, etc.)
  factory ClassModel.fromJson(Map<String, dynamic> json) => ClassModel(
    id: json['id'] as String,
    name: json['name'] as String? ?? '',
    code: json['code'] as String?,
    level: json['level'] as String?,
    section: json['section'] as String?,
    schoolYear: json['schoolYear'] as String? ?? json['school_year'] as String?,
    studentCount: json['studentCount'] as int? ?? json['student_count'] as int?,
    teacherId: json['teacherId'] as String? ?? json['teacher_id'] as String?,
    teacherName: json['teacherName'] as String? ?? json['teacher_name'] as String?,
    isArchived: json['isArchived'] as bool? ?? json['is_archived'] as bool? ?? false,
    createdAt: (json['createdAt'] != null)
        ? DateTime.tryParse(json['createdAt'])
        : (json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null),
    updatedAt: (json['updatedAt'] != null)
        ? DateTime.tryParse(json['updatedAt'])
        : (json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null),
    room: json['room'] as String?,
  );

  /// Convertit ce modèle en JSON pour l'API ou la sauvegarde locale.
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    if (code != null) 'code': code,
    if (level != null) 'level': level,
    if (section != null) 'section': section,
    if (schoolYear != null) 'schoolYear': schoolYear,
    if (studentCount != null) 'studentCount': studentCount,
    if (teacherId != null) 'teacherId': teacherId,
    if (teacherName != null) 'teacherName': teacherName,
    if (isArchived != null) 'isArchived': isArchived,
    if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    if (room != null) 'room': room,
  };

  /// Affichage court pour UI/debug/log
  @override
  String toString() => 'Classe: $name (${code ?? id})';

  /// Savoir si la classe est archivée (désactivée)
  bool get archived => isArchived == true;

  /// Savoir si la classe est active (valide)
  bool get active => !archived;
}