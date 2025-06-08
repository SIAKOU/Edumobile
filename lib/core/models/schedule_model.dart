/// schedule_model.dart
/// Modèle représentant un créneau de planning/emploi du temps (cours, événement, etc.).
/// Adapté à la fois pour du stockage local et pour une API (REST, Firebase, Supabase…).
library;

import 'package:equatable/equatable.dart';

class ScheduleModel extends Equatable {
  final String id;
  final String? classId;          // ID de la classe concernée
  final String? subject;          // Matière ou type d’événement
  final String? teacherId;        // ID du professeur
  final String? teacher;          // Nom du professeur (optionnel)
  final DateTime startTime;       // Date et heure de début
  final DateTime endTime;         // Date et heure de fin
  final String? location;         // Salle ou lieu
  final String? room;             // Salle (détail)
  final String? description;      // Détail sur le cours/événement
  final bool isActive;

  // Ajoutez d'autres champs métiers si besoin (groupe, couleur, etc.)

  const ScheduleModel({
    required this.id,
    this.classId,
    this.subject,
    this.teacherId,
    this.teacher,
    required this.startTime,
    required this.endTime,
    this.location,
    this.room,
    this.description,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
        id,
        classId,
        subject,
        teacherId,
        teacher,
        startTime,
        endTime,
        location,
        room,
        description,
        isActive,
      ];

  /// Mapping JSON <-> Objet
  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
        id: json['id'] as String,
        classId: json['classId'] as String? ?? json['class_id'] as String?,
        subject: json['subject'] as String?,
        teacherId: json['teacherId'] as String? ?? json['teacher_id'] as String?,
        teacher: json['teacher'] as String?,
        startTime: json['startTime'] != null
            ? DateTime.parse(json['startTime'])
            : json['start_time'] != null
                ? DateTime.parse(json['start_time'])
                : DateTime.now(),
        endTime: json['endTime'] != null
            ? DateTime.parse(json['endTime'])
            : json['end_time'] != null
                ? DateTime.parse(json['end_time'])
                : DateTime.now(),
        location: json['location'] as String?,
        room: json['room'] as String?,
        description: json['description'] as String?,
        isActive: json['isActive'] as bool? ?? json['is_active'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        if (classId != null) 'classId': classId,
        if (subject != null) 'subject': subject,
        if (teacherId != null) 'teacherId': teacherId,
        if (teacher != null) 'teacher': teacher,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        if (location != null) 'location': location,
        if (room != null) 'room': room,
        if (description != null) 'description': description,
        'isActive': isActive,
      };

  /// Copie avec modifications
  ScheduleModel copyWith({
    String? id,
    String? classId,
    String? subject,
    String? teacherId,
    String? teacher,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    String? room,
    String? description,
    bool? isActive,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      subject: subject ?? this.subject,
      teacherId: teacherId ?? this.teacherId,
      teacher: teacher ?? this.teacher,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      room: room ?? this.room,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }
}