import 'package:equatable/equatable.dart';

/// Modèle de données utilisateur générique et évolutif, compatible API/stockage local.
/// Utilisable pour Firebase/Supabase ou REST.
/// Ajoutez des champs ou méthodes selon vos besoins métiers.

class UserModel extends Equatable {
  final String id;
  final String? email;
  final String? username;
  final String? fullName;
  final String? phone;
  final String? avatarUrl;
  final String? role; // student, teacher, admin, etc.
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? language;
  final String? classId; // Si l'utilisateur est élève/prof
  final String? address; // Optionnel, si besoin de stocker l'adresse

  // Ajoutez d'autres champs métiers si besoin (adresse, etc.)

  const UserModel({
    required this.id,
    this.email,
    this.username,
    this.fullName,
    this.phone,
    this.avatarUrl,
    this.role,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.language,
    this.classId,
    this.address,
  });

  // --- Equatable pour faciliter les comparaisons (tests, state management) ---
  @override
  List<Object?> get props => [
        id,
        email,
        username,
        fullName,
        phone,
        avatarUrl,
        role,
        isActive,
        createdAt,
        updatedAt,
        language,
        classId,
        address,
      ];

  // --- Mapping pour JSON (API, stockage local, etc.) ---
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        email: json['email'] as String?,
        username: json['username'] as String?,
        fullName: json['fullName'] as String? ?? json['full_name'] as String?,
        phone: json['phone'] as String?,
        avatarUrl: json['avatarUrl'] as String? ?? json['avatar_url'] as String?,
        role: json['role'] as String?,
        isActive: json['isActive'] as bool? ?? json['is_active'] as bool? ?? true,
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
        language: json['language'] as String?,
        classId: json['classId'] as String? ?? json['class_id'] as String?,
        address: json['address'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        if (email != null) 'email': email,
        if (username != null) 'username': username,
        if (fullName != null) 'fullName': fullName,
        if (phone != null) 'phone': phone,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
        if (role != null) 'role': role,
        'isActive': isActive,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
        if (language != null) 'language': language,
        if (classId != null) 'classId': classId,
        if (address != null) 'address': address,
      };

  // --- Helpers pour l’app ---

  bool get isAdmin => role == 'admin';
  bool get isStudent => role == 'student';
  bool get isTeacher => role == 'teacher';

  /// Retourne le nom d’affichage prioritaire (fullName > username > email > id)
  String get displayName =>
      fullName?.isNotEmpty == true
          ? fullName!
          : (username?.isNotEmpty == true
              ? username!
              : (email?.isNotEmpty == true
                  ? email!
                  : id));
}