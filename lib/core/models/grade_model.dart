/// grade_model.dart
/// Modèle de données représentant une note/évaluation d’un élève.
/// Adapté pour stockage local ou API (REST, Firebase, Supabase…).

library;

import 'package:equatable/equatable.dart';

class GradeModel extends Equatable {
  final String id;
  final String studentId;        // ID de l’élève noté
  final String classId;          // ID de la classe concernée
  final String? subjectId;       // ID de la matière (optionnel, préférable à un nom brut)
  final String? subjectName;     // Nom de la matière (pour affichage)
  final double value;            // Note obtenue (ex: 15.5)
  final double? maxValue;        // Note maximale possible (ex: 20)
  final DateTime date;           // Date de l’évaluation
  final String? teacherId;       // ID du professeur qui a noté
  final String? comment;         // Commentaire sur la note
  final String? type;            // Type d’évaluation (ex: contrôle, oral…)
  final String? period;          // Période (trimestre, semestre, etc.)

  const GradeModel({
    required this.id,
    required this.studentId,
    required this.classId,
    required this.value,
    required this.date,
    this.subjectId,
    this.subjectName,
    this.maxValue,
    this.teacherId,
    this.comment,
    this.type,
    this.period,
  });

  @override
  List<Object?> get props => [
        id,
        studentId,
        classId,
        subjectId,
        subjectName,
        value,
        maxValue,
        date,
        teacherId,
        comment,
        type,
        period,
      ];

  /// Mapping JSON <-> Objet
  factory GradeModel.fromJson(Map<String, dynamic> json) => GradeModel(
        id: json['id'] as String,
        studentId: json['studentId'] as String? ?? json['student_id'] as String,
        classId: json['classId'] as String? ?? json['class_id'] as String,
        subjectId: json['subjectId'] as String? ?? json['subject_id'] as String?,
        subjectName: json['subjectName'] as String? ?? json['subject'] as String?,
        value: (json['value'] as num).toDouble(),
        maxValue: json['maxValue'] != null
            ? (json['maxValue'] as num).toDouble()
            : json['max_value'] != null
                ? (json['max_value'] as num).toDouble()
                : null,
        date: json['date'] != null
            ? DateTime.parse(json['date'])
            : DateTime.now(),
        teacherId: json['teacherId'] as String? ?? json['teacher_id'] as String?,
        comment: json['comment'] as String?,
        type: json['type'] as String?,
        period: json['period'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'studentId': studentId,
        'classId': classId,
        if (subjectId != null) 'subjectId': subjectId,
        if (subjectName != null) 'subjectName': subjectName,
        'value': value,
        if (maxValue != null) 'maxValue': maxValue,
        'date': date.toIso8601String(),
        if (teacherId != null) 'teacherId': teacherId,
        if (comment != null) 'comment': comment,
        if (type != null) 'type': type,
        if (period != null) 'period': period,
      };

  /// Copie avec modifications
  GradeModel copyWith({
    String? id,
    String? studentId,
    String? classId,
    String? subjectId,
    String? subjectName,
    double? value,
    double? maxValue,
    DateTime? date,
    String? teacherId,
    String? comment,
    String? type,
    String? period,
  }) {
    return GradeModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      classId: classId ?? this.classId,
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      value: value ?? this.value,
      maxValue: maxValue ?? this.maxValue,
      date: date ?? this.date,
      teacherId: teacherId ?? this.teacherId,
      comment: comment ?? this.comment,
      type: type ?? this.type,
      period: period ?? this.period,
    );
  }
}