/// connectivity_service.dart
/// Service utilitaire pour vérifier l'état de la connexion réseau (Wi-Fi, mobile, aucune connexion…)
/// Utilise le package `connectivity_plus` pour obtenir le statut réseau en temps réel.
// ignore_for_file: unintended_html_in_doc_comment, unrelated_type_equality_checks

library;

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  ConnectivityService(Connectivity connectivity);

  /// Vérifie le statut actuel de la connexion réseau (wifi, mobile, none)
  Future<List<ConnectivityResult>> checkConnectivity() async {
    return await _connectivity.checkConnectivity();
  }

  /// Écoute les changements de statut de la connexion réseau
  /// Retourne un Stream<ConnectivityResult>
  Stream<List<ConnectivityResult>> onConnectivityChanged() {
    return _connectivity.onConnectivityChanged;
  }

  /// Retourne true si une connexion réseau est disponible (wifi ou mobile)
  Future<bool> isConnected() async {
    final result = await checkConnectivity();
    return result == ConnectivityResult.mobile || result == ConnectivityResult.wifi;
  }

  void startMonitoring() {}
}