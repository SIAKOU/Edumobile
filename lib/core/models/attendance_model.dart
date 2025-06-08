/// attendance_model.dart
/// Modèle représentant la présence d'un élève à un cours ou événement.
/// Adapté pour stockage local et API (REST, Firebase, Supabase…).
library;

import 'package:equatable/equatable.dart';

class AttendanceModel extends Equatable {
  final String id;
  final String studentId;        // ID de l'élève
  final String classId;          // ID de la classe
  final DateTime date;           // Date de l'événement
  final String? status;          // Présent, absent, excusé, retard, etc.
  final String? reason;          // Raison de l'absence/retard (optionnel)
  final String? recordedBy;      // ID de l'utilisateur ayant enregistré la présence (prof, admin...)
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  // Ajoutez d'autres champs métiers si besoin

  const AttendanceModel({
    required this.id,
    required this.studentId,
    required this.classId,
    required this.date,
    this.status,
    this.reason,
    this.recordedBy,
    this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
        id,
        studentId,
        classId,
        date,
        status,
        reason,
        recordedBy,
        createdAt,
        updatedAt,
        isActive,
      ];

  /// Mapping JSON <-> Objet
  factory AttendanceModel.fromJson(Map<String, dynamic> json) => AttendanceModel(
        id: json['id'] as String,
        studentId: json['studentId'] as String? ?? json['student_id'] as String,
        classId: json['classId'] as String? ?? json['class_id'] as String,
        date: json['date'] != null
            ? DateTime.parse(json['date'])
            : DateTime.now(),
        status: json['status'] as String?,
        reason: json['reason'] as String?,
        recordedBy: json['recordedBy'] as String? ?? json['recorded_by'] as String?,
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
        'studentId': studentId,
        'classId': classId,
        'date': date.toIso8601String(),
        if (status != null) 'status': status,
        if (reason != null) 'reason': reason,
        if (recordedBy != null) 'recordedBy': recordedBy,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
        'isActive': isActive,
      };

  /// Copie avec modifications
  AttendanceModel copyWith({
    String? id,
    String? studentId,
    String? classId,
    DateTime? date,
    String? status,
    String? reason,
    String? recordedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      classId: classId ?? this.classId,
      date: date ?? this.date,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      recordedBy: recordedBy ?? this.recordedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}