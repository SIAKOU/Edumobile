/// subject_model.dart
/// Modèle de données représentant une matière (discipline, subject) scolaire.
/// Adapté pour stockage local ou synchronisation avec une API (REST, Firebase, etc).

library;

import 'package:equatable/equatable.dart';

class SubjectModel extends Equatable {
  final String id;
  final String name;
  final String? code;        // Code court (ex: MATH, HIST)
  final String? description; // Description facultative
  final String? color;       // Pour affichage UI (ex: "#FF0000")
  final String? teacherId;   // Professeur principal de la matière (optionnel)

  const SubjectModel({
    required this.id,
    required this.name,
    this.code,
    this.description,
    this.color,
    this.teacherId,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        description,
        color,
        teacherId,
      ];

  /// Mapping JSON <-> Objet
  factory SubjectModel.fromJson(Map<String, dynamic> json) => SubjectModel(
        id: json['id'] as String,
        name: json['name'] as String,
        code: json['code'] as String?,
        description: json['description'] as String?,
        color: json['color'] as String?,
        teacherId: json['teacherId'] as String? ?? json['teacher_id'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (code != null) 'code': code,
        if (description != null) 'description': description,
        if (color != null) 'color': color,
        if (teacherId != null) 'teacherId': teacherId,
      };

  /// Copie avec modifications
  SubjectModel copyWith({
    String? id,
    String? name,
    String? code,
    String? description,
    String? color,
    String? teacherId,
  }) {
    return SubjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      color: color ?? this.color,
      teacherId: teacherId ?? this.teacherId,
    );
  }
}