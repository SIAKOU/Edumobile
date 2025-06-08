/// auth_events.dart
/// Définition des événements liés à l'authentification pour une architecture Bloc.
/// À utiliser avec AuthBloc pour gérer les changements d'état selon les actions utilisateur.
library;

import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Lancer la vérification de l'état d'authentification au démarrage
class AuthCheckRequested extends AuthEvent {}

/// Connexion avec email et mot de passe
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Inscription d'un nouvel utilisateur
class AuthRegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

/// Déconnexion
class AuthLogoutRequested extends AuthEvent {}

/// Connexion biométrique
class AuthBiometricRequested extends AuthEvent {}

/// Rafraîchir le token
class AuthRefreshTokenRequested extends AuthEvent {}