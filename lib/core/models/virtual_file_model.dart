/// virtual_file_model.dart
/// Modèle représentant un fichier virtuel (document, devoir, ressource, etc.) lié à un utilisateur, une classe, etc.
/// Adapté pour stockage local et API (REST, Firebase, Supabase…)
library;

import 'package:equatable/equatable.dart';

class VirtualFileModel extends Equatable {
  final String id;
  final String? ownerId;           // Propriétaire du fichier (user, prof, admin…)
  final String? classId;           // Classe concernée (optionnel)
  final String? groupId;           // Groupe concerné (optionnel)
  final String? name;              // Nom du fichier
  final String? description;       // Description ou annotation
  final String url;                // URL de stockage du fichier
  final String? type;              // Type MIME ou catégorie (pdf, image, devoir…)
  final int? size;                 // Taille en octets
  final DateTime uploadedAt;       // Date d’upload
  final String? uploadedBy;        // ID de l’uploader (user)
  final DateTime? updatedAt;       // Modification éventuelle
  final bool isActive;

  // Ajoutez d’autres champs métiers si besoin

  const VirtualFileModel({
    required this.id,
    this.ownerId,
    this.classId,
    this.groupId,
    this.name,
    this.description,
    required this.url,
    this.type,
    this.size,
    required this.uploadedAt,
    this.uploadedBy,
    this.updatedAt,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
    id,
    ownerId,
    classId,
    groupId,
    name,
    description,
    url,
    type,
    size,
    uploadedAt,
    uploadedBy,
    updatedAt,
    isActive,
  ];

  /// Mapping JSON <-> Objet
  factory VirtualFileModel.fromJson(Map<String, dynamic> json) => VirtualFileModel(
    id: json['id'] as String,
    ownerId: json['ownerId'] as String? ?? json['owner_id'] as String?,
    classId: json['classId'] as String? ?? json['class_id'] as String?,
    groupId: json['groupId'] as String? ?? json['group_id'] as String?,
    name: json['name'] as String?,
    description: json['description'] as String?,
    url: json['url'] as String,
    type: json['type'] as String?,
    size: json['size'] as int?,
    uploadedAt: json['uploadedAt'] != null
        ? DateTime.parse(json['uploadedAt'])
        : json['uploaded_at'] != null
            ? DateTime.parse(json['uploaded_at'])
            : DateTime.now(),
    uploadedBy: json['uploadedBy'] as String? ?? json['uploaded_by'] as String?,
    updatedAt: json['updatedAt'] != null
        ? DateTime.tryParse(json['updatedAt'])
        : json['updated_at'] != null
            ? DateTime.tryParse(json['updated_at'])
            : null,
    isActive: json['isActive'] as bool? ?? json['is_active'] as bool? ?? true,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    if (ownerId != null) 'ownerId': ownerId,
    if (classId != null) 'classId': classId,
    if (groupId != null) 'groupId': groupId,
    if (name != null) 'name': name,
    if (description != null) 'description': description,
    'url': url,
    if (type != null) 'type': type,
    if (size != null) 'size': size,
    'uploadedAt': uploadedAt.toIso8601String(),
    if (uploadedBy != null) 'uploadedBy': uploadedBy,
    if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    'isActive': isActive,
  };

  /// Copie avec modifications
  VirtualFileModel copyWith({
    String? id,
    String? ownerId,
    String? classId,
    String? groupId,
    String? name,
    String? description,
    String? url,
    String? type,
    int? size,
    DateTime? uploadedAt,
    String? uploadedBy,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return VirtualFileModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      classId: classId ?? this.classId,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      description: description ?? this.description,
      url: url ?? this.url,
      type: type ?? this.type,
      size: size ?? this.size,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}