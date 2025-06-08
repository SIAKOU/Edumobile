/// auth_state.dart
/// Modèle représentant l'état d'authentification de l'utilisateur.
/// Peut être utilisé avec Provider, Bloc ou tout autre gestionnaire d'état.
library;

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
  loading,
}

class AuthState {
  final AuthStatus status;
  final String? userId;
  final String? token;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.userId,
    this.token,
    this.errorMessage,
  });

  /// Crée une copie de l'état avec des valeurs modifiées
  AuthState copyWith({
    AuthStatus? status,
    String? userId,
    String? token,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      userId: userId ?? this.userId,
      token: token ?? this.token,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}