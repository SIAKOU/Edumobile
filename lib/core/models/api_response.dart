/// api_response.dart
/// Modèle de réponse standard pour les appels API de l'application.
/// Permet d'uniformiser la gestion des réponses (statut, message, données, erreurs...).
library;

import 'package:equatable/equatable.dart';

class ApiResponse<T> extends Equatable {
  final bool success;            // Statut de la réponse (succès/échec)
  final String? message;         // Message associé (succès, erreur, info...)
  final T? data;                 // Données retournées (générique)
  final int? code;               // Code HTTP ou métier (optionnel)
  final dynamic error;           // Détail d'erreur (optionnel)

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.code,
    this.error,
  });

  @override
  List<Object?> get props => [success, message, data, code, error];

  /// Factory de création depuis un JSON dynamique
  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic)? fromData,
  }) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? (json['status'] == 'success'),
      message: json['message'] as String?,
      data: fromData != null && json['data'] != null ? fromData(json['data']) : json['data'],
      code: json['code'] as int?,
      error: json['error'],
    );
  }

  /// Convertit la réponse en JSON
  Map<String, dynamic> toJson() => {
        'success': success,
        if (message != null) 'message': message,
        if (data != null) 'data': data,
        if (code != null) 'code': code,
        if (error != null) 'error': error,
      };

  /// Copie avec modifications
  ApiResponse<T> copyWith({
    bool? success,
    String? message,
    T? data,
    int? code,
    dynamic error,
  }) {
    return ApiResponse<T>(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
      code: code ?? this.code,
      error: error ?? this.error,
    );
  }
}