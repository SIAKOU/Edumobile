/// api_exceptions.dart
/// Définition des exceptions personnalisées pour la gestion des erreurs API.
/// Permet de centraliser les différents cas d'erreur réseau, parsing, authentification, etc.
library;

class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic details;

  ApiException({
    this.statusCode,
    required this.message,
    this.details,
  });

  @override
  String toString() =>
      'ApiException${statusCode != null ? ' [$statusCode]' : ''}: $message${details != null ? ' | Details: $details' : ''}';
}

/// Exception pour une réponse 401 ou problème d'authentification
class UnauthorizedException extends ApiException {
  UnauthorizedException({String message = "Unauthorized", dynamic details})
      : super(statusCode: 401, message: message, details: details);
}

/// Exception pour une réponse 403 ou accès refusé
class ForbiddenException extends ApiException {
  ForbiddenException({String message = "Forbidden", dynamic details})
      : super(statusCode: 403, message: message, details: details);
}

/// Exception pour une ressource non trouvée (404)
class NotFoundException extends ApiException {
  NotFoundException({String message = "Not Found", dynamic details})
      : super(statusCode: 404, message: message, details: details);
}

/// Exception pour erreur de validation ou données incorrectes (422...)
class ValidationException extends ApiException {
  ValidationException({String message = "Invalid data", dynamic details})
      : super(statusCode: 422, message: message, details: details);
}

/// Exception pour erreurs serveur (500+)
class ServerException extends ApiException {
  ServerException({String message = "Server error", dynamic details, int? statusCode})
      : super(statusCode: statusCode ?? 500, message: message, details: details);
}

/// Exception pour problème réseau général (timeout, etc.)
class NetworkException extends ApiException {
  NetworkException({String message = "Network error", dynamic details})
      : super(message: message, details: details);
}