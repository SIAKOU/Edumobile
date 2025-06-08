/// biometric_service.dart
/// Service pour la gestion de l'authentification biométrique (empreinte digitale, reconnaissance faciale, etc.).
/// Utilise le package `local_auth` de Flutter pour interagir avec les capteurs biométriques.
/// Ce service fournit des méthodes pour vérifier la disponibilité de la biométrie et effectuer une authentification utilisateur.
library;

import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Vérifie si un capteur biométrique est disponible sur l'appareil
  Future<bool> isBiometricAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics || await _localAuth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }

  /// Récupère la liste des types biométriques disponibles (empreinte, visage, etc.)
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return <BiometricType>[];
    }
  }

  /// Tente d'authentifier l'utilisateur via biométrie
  Future<bool> authenticateWithBiometrics({
    String reason = 'Veuillez vous authentifier pour accéder à cette fonctionnalité.',
    bool useErrorDialogs = true,
    bool stickyAuth = false,
  }) async {
    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
        ),
      );
      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }
}