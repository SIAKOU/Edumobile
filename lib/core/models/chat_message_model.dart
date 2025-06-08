/// chat_message_model.dart
/// Modèle représentant un message dans une conversation (fil de discussion).
/// Convient au stockage local et à l’utilisation via API (REST, Firebase, etc.).
library;

import 'package:equatable/equatable.dart';

class ChatMessageModel extends Equatable {
  final String id;
  final String threadId;           // ID du fil de discussion (thread)
  final String senderId;           // ID de l’expéditeur
  final String? content;           // Contenu textuel du message
  final DateTime sentAt;           // Date/heure d’envoi
  final bool isRead;               // Message lu ou non
  final List<String>? attachments;  // URLs de pièces jointes (images, docs...)
  final String? type;              // Type (texte, image, fichier, etc.)
  final DateTime? updatedAt;       // Date de modification (si édité)
  final bool isSystem;             // Message système (notification, etc.)

  // Ajoutez d’autres champs métiers selon besoin

  const ChatMessageModel({
    required this.id,
    required this.threadId,
    required this.senderId,
    this.content,
    required this.sentAt,
    this.isRead = false,
    this.attachments,
    this.type,
    this.updatedAt,
    this.isSystem = false,
  });

  @override
  List<Object?> get props => [
        id,
        threadId,
        senderId,
        content,
        sentAt,
        isRead,
        attachments,
        type,
        updatedAt,
        isSystem,
      ];

  /// Mapping JSON <-> Objet
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => ChatMessageModel(
        id: json['id'] as String,
        threadId: json['threadId'] as String? ?? json['thread_id'] as String,
        senderId: json['senderId'] as String? ?? json['sender_id'] as String,
        content: json['content'] as String?,
        sentAt: json['sentAt'] != null
            ? DateTime.parse(json['sentAt'])
            : json['sent_at'] != null
                ? DateTime.parse(json['sent_at'])
                : DateTime.now(),
        isRead: json['isRead'] as bool? ?? json['is_read'] as bool? ?? false,
        attachments: (json['attachments']) is List
            ? List<String>.from(json['attachments'])
            : null,
        type: json['type'] as String?,
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'])
            : json['updated_at'] != null
                ? DateTime.tryParse(json['updated_at'])
                : null,
        isSystem: json['isSystem'] as bool? ?? json['is_system'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'threadId': threadId,
        'senderId': senderId,
        if (content != null) 'content': content,
        'sentAt': sentAt.toIso8601String(),
        'isRead': isRead,
        if (attachments != null) 'attachments': attachments,
        if (type != null) 'type': type,
        if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
        'isSystem': isSystem,
      };

  /// Copie avec modifications
  ChatMessageModel copyWith({
    String? id,
    String? threadId,
    String? senderId,
    String? content,
    DateTime? sentAt,
    bool? isRead,
    List<String>? attachments,
    String? type,
    DateTime? updatedAt,
    bool? isSystem,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      threadId: threadId ?? this.threadId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      sentAt: sentAt ?? this.sentAt,
      isRead: isRead ?? this.isRead,
      attachments: attachments ?? this.attachments,
      type: type ?? this.type,
      updatedAt: updatedAt ?? this.updatedAt,
      isSystem: isSystem ?? this.isSystem,
    );
  }
}