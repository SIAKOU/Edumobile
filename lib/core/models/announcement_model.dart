/// announcement_model.dart
/// Modèle représentant une annonce (notification, message d'information, etc.).
/// Adapté à la fois pour du stockage local et pour une API (REST, Firebase, Supabase…).
library;

import 'package:equatable/equatable.dart';

class AnnouncementModel extends Equatable {
  final String id;
  final String title;
  final String? content;
  final String? authorId;           // ID de l'utilisateur ayant créé l'annonce (prof, admin, etc.)
  final String? classId;            // ID de la classe concernée (optionnel)
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final DateTime? publishedAt;      // Date de publication effective (optionnelle)
  final bool isActive;
  final List<String>? attachments;  // URLs de pièces jointes, images, etc.
  // Ajoutez d'autres champs métiers si besoin (niveau priorité, type, etc.)

  const AnnouncementModel({
    required this.id,
    required this.title,
    this.content,
    this.authorId,
    this.classId,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.publishedAt,
    this.isActive = true,
    this.attachments,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    authorId,
    classId,
    createdAt,
    updatedAt,
    deletedAt,
    publishedAt,
    isActive,
    attachments,
  ];

  /// Mapping JSON <-> Objet
  factory AnnouncementModel.fromJson(Map<String, dynamic> json) => AnnouncementModel(
    id: json['id'] as String,
    title: json['title'] as String,
    content: json['content'] as String?,
    authorId: json['authorId'] as String? ?? json['author_id'] as String?,
    classId: json['classId'] as String? ?? json['class_id'] as String?,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : DateTime.now(),
    updatedAt: json['updatedAt'] != null
        ? DateTime.tryParse(json['updatedAt'])
        : json['updated_at'] != null
            ? DateTime.tryParse(json['updated_at'])
            : null,
    deletedAt: json['deletedAt'] != null
        ? DateTime.tryParse(json['deletedAt'])
        : json['deleted_at'] != null
            ? DateTime.tryParse(json['deleted_at'])
            : null,
    publishedAt: json['publishedAt'] != null
        ? DateTime.tryParse(json['publishedAt'])
        : json['published_at'] != null
            ? DateTime.tryParse(json['published_at'])
            : null,
    isActive: json['isActive'] as bool? ?? json['is_active'] as bool? ?? true,
    attachments: (json['attachments'] ?? json['attachments_urls']) is List
        ? List<String>.from(json['attachments'] ?? json['attachments_urls'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    if (content != null) 'content': content,
    if (authorId != null) 'authorId': authorId,
    if (classId != null) 'classId': classId,
    'createdAt': createdAt.toIso8601String(),
    if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    if (deletedAt != null) 'deletedAt': deletedAt!.toIso8601String(),
    if (publishedAt != null) 'publishedAt': publishedAt!.toIso8601String(),
    'isActive': isActive,
    if (attachments != null) 'attachments': attachments,
  };

  /// Copie avec modifications
  AnnouncementModel copyWith({
    String? id,
    String? title,
    String? content,
    String? authorId,
    String? classId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    DateTime? publishedAt,
    bool? isActive,
    List<String>? attachments,
  }) {
    return AnnouncementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      authorId: authorId ?? this.authorId,
      classId: classId ?? this.classId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      publishedAt: publishedAt ?? this.publishedAt,
      isActive: isActive ?? this.isActive,
      attachments: attachments ?? this.attachments,
    );
  }
}