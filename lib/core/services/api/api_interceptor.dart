/// api_interceptor.dart
/// Intercepteur HTTP pour gérer l'authentification (token), la journalisation, le rafraîchissement de token, etc.
/// Pensé pour être utilisé avec `http`, `dio`, ou tout autre client supportant les intercepteurs.
/// Cet exemple est basique et adapté pour le package `http` avec surcouche personnalisée.
library;

import 'dart:async';
import 'package:http/http.dart' as http;

/// Un intercepteur HTTP basique pour ajouter l'authentification et d'autres headers.
/// Peut aussi servir à logger ou à rafraîchir un token si besoin.
class ApiInterceptor extends http.BaseClient {
  final http.Client _inner;
  final FutureOr<String?> Function()? getToken; // Fonction pour récupérer le token JWT ou autre

  ApiInterceptor({
    http.Client? inner,
    this.getToken,
  }) : _inner = inner ?? http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Ajout du token d'authentification s'il existe
    final token = await getToken?.call();
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    // Ajoutez ici d'autres headers ou traitements (langue, user-agent, etc.)
    // request.headers['Accept-Language'] = 'fr';

    // Logger simple (optionnel)
    // print('[API] ${request.method} ${request.url}');

    final response = await _inner.send(request);

    // Ici, vous pouvez gérer des cas particuliers (ex: token expiré, logs avancés, etc.)

    return response;
  }

  /// N'oubliez pas de fermer le client pour libérer les ressources réseau.
  @override
  void close() {
    _inner.close();
    super.close();
  }
}