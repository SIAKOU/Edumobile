/// assignment_model.dart
/// Modèle pour un devoir ou une remise à corriger dans l'application EduMobile.
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

  static void fromJson(data) {}
}