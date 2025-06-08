/// message_thread_model.dart
/// Modèle représentant un fil de discussion (ex: messagerie entre utilisateurs, groupe, etc.)
/// Adapté pour stockage local et API (REST, Firebase...).
library;

import 'package:equatable/equatable.dart';

class MessageThreadModel extends Equatable {
  final String id;
  final List<String> participantIds;    // IDs des utilisateurs participants au thread
  final String? lastMessageId;          // ID du dernier message (si besoin)
  final String? lastMessagePreview;     // Aperçu du dernier message (texte)
  final DateTime? lastMessageAt;        // Date/heure du dernier message
  final String? title;                  // Titre du thread (optionnel, pour groupe)
  final String? imageUrl;               // Image de groupe/avatar (optionnel)
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isGroup;
  final bool isActive;

  // Ajoutez d'autres champs métiers si besoin (muted, unreadCount, etc.)

  const MessageThreadModel({
    required this.id,
    required this.participantIds,
    this.lastMessageId,
    this.lastMessagePreview,
    this.lastMessageAt,
    this.title,
    this.imageUrl,
    required this.createdAt,
    this.updatedAt,
    this.isGroup = false,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
        id,
        participantIds,
        lastMessageId,
        lastMessagePreview,
        lastMessageAt,
        title,
        imageUrl,
        createdAt,
        updatedAt,
        isGroup,
        isActive,
      ];

  /// Mapping JSON <-> Objet
  factory MessageThreadModel.fromJson(Map<String, dynamic> json) => MessageThreadModel(
        id: json['id'] as String,
        participantIds: (json['participantIds'] ?? json['participants']) is List
            ? List<String>.from(json['participantIds'] ?? json['participants'])
            : <String>[],
        lastMessageId: json['lastMessageId'] as String? ?? json['last_message_id'] as String?,
        lastMessagePreview: json['lastMessagePreview'] as String? ?? json['last_message_preview'] as String?,
        lastMessageAt: json['lastMessageAt'] != null
            ? DateTime.tryParse(json['lastMessageAt'])
            : json['last_message_at'] != null
                ? DateTime.tryParse(json['last_message_at'])
                : null,
        title: json['title'] as String?,
        imageUrl: json['imageUrl'] as String? ?? json['image_url'] as String?,
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
        isGroup: json['isGroup'] as bool? ?? json['is_group'] as bool? ?? false,
        isActive: json['isActive'] as bool? ?? json['is_active'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'participantIds': participantIds,
        if (lastMessageId != null) 'lastMessageId': lastMessageId,
        if (lastMessagePreview != null) 'lastMessagePreview': lastMessagePreview,
        if (lastMessageAt != null) 'lastMessageAt': lastMessageAt!.toIso8601String(),
        if (title != null) 'title': title,
        if (imageUrl != null) 'imageUrl': imageUrl,
        'createdAt': createdAt.toIso8601String(),
        if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
        'isGroup': isGroup,
        'isActive': isActive,
      };

  /// Copie avec modifications
  MessageThreadModel copyWith({
    String? id,
    List<String>? participantIds,
    String? lastMessageId,
    String? lastMessagePreview,
    DateTime? lastMessageAt,
    String? title,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isGroup,
    bool? isActive,
  }) {
    return MessageThreadModel(
      id: id ?? this.id,
      participantIds: participantIds ?? this.participantIds,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isGroup: isGroup ?? this.isGroup,
      isActive: isActive ?? this.isActive,
    );
  }
}