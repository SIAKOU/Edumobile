/// assignment_model.dart
/// Modèle pour un devoir ou une remise à corriger dans l'application EduMobile.
// ignore_for_file: strict_top_level_inference

library;

class AssignmentModel {
  final String id;
  final String title;
  final DateTime? dueDate;
  final int? toReviewCount;
  final String? description;
  final String? classId;

  AssignmentModel({
    required this.id,
    required this.title,
    this.dueDate,
    this.toReviewCount,
    this.description,
    this.classId,
  });

  // Pour la désérialisation depuis Firebase, Supabase, ou API
  factory AssignmentModel.fromMap(Map<String, dynamic> map) {
    return AssignmentModel(
      id: map['id'] as String,
      title: map['title'] as String,
      dueDate: map['dueDate'] != null
          ? DateTime.tryParse(map['dueDate'].toString())
          : null,
      toReviewCount: map['toReviewCount'] != null
          ? int.tryParse(map['toReviewCount'].toString())
          : null,
      description: map['description'] as String?,
      classId: map['classId'] as String?,
    );
  }

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id'] as String,
      title: json['title'] as String,
      dueDate: json['dueDate'] != null
          ? DateTime.tryParse(json['dueDate'].toString())
          : null,
      toReviewCount: json['toReviewCount'] != null
          ? int.tryParse(json['toReviewCount'].toString())
          : null,
      description: json['description'] as String?,
      classId: json['classId'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dueDate': dueDate?.toIso8601String(),
      'toReviewCount': toReviewCount,
      'description': description,
      'classId': classId,
    };
  }
}
