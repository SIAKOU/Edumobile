/// api_client.dart
/// Client HTTP de base pour l'application (GET, POST, PUT, DELETE, gestion des erreurs, etc.).
/// Utilise le package `http` de Dart avec intégration de Supabase.
// ignore_for_file: avoid_print

library;

import 'dart:convert';
import 'package:gestion_ecole/app/config/app_constants.dart';
import 'package:http/http.dart' as http;

/// Exception personnalisée pour les erreurs API
class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic details;

  ApiException({required this.statusCode, required this.message, this.details});

  @override
  String toString() => 'ApiException($statusCode): $message ${details ?? ''}';
}

class ApiClient {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  ApiClient({
    required this.baseUrl,
    Map<String, String>? defaultHeaders,
  }) : defaultHeaders = {
          'Content-Type': 'application/json',
          'apikey': AppConstants.supabaseAnonKey,
          'Authorization': 'Bearer ${AppConstants.supabaseAnonKey}',
          ...?defaultHeaders,
        };

  /// Construit une URI complète
  Uri _buildUri(String endpoint, [Map<String, dynamic>? params]) {
    final uri = Uri.parse('$baseUrl$endpoint');
    if (params != null && params.isNotEmpty) {
      return uri.replace(
          queryParameters: params.map((k, v) => MapEntry(k, v.toString())));
    }
    return uri;
  }

  /// Fusionne les headers
  Map<String, String> _mergeHeaders([Map<String, String>? headers]) {
    return {...defaultHeaders, ...?headers};
  }

  /// GET request
  Future<http.Response> get(
    String endpoint, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(endpoint, params);
    print('GET Request to: $uri'); // Log l'URL appelée

    try {
      final response = await http.get(uri, headers: _mergeHeaders(headers));
      print(
          'Response: ${response.statusCode} - ${response.body}'); // Log la réponse
      _checkForErrors(response);
      return response;
    } catch (e) {
      print('Error in GET $uri: $e'); // Log l'erreur
      rethrow;
    }
  }

  /// POST request
  Future<http.Response> post(
    String endpoint, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.post(
        _buildUri(endpoint),
        headers: _mergeHeaders(headers),
        body: body != null ? jsonEncode(body) : null,
      );
      _checkForErrors(response);
      return response;
    } catch (e) {
      throw ApiException(
        statusCode: 500,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  /// PUT request
  Future<http.Response> put(
    String endpoint, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.put(
        _buildUri(endpoint),
        headers: _mergeHeaders(headers),
        body: body != null ? jsonEncode(body) : null,
      );
      _checkForErrors(response);
      return response;
    } catch (e) {
      throw ApiException(
        statusCode: 500,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  /// DELETE request
  Future<http.Response> delete(
    String endpoint, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.delete(
        _buildUri(endpoint),
        headers: _mergeHeaders(headers),
        body: body != null ? jsonEncode(body) : null,
      );
      _checkForErrors(response);
      return response;
    } catch (e) {
      throw ApiException(
        statusCode: 500,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  /// Vérifie les erreurs HTTP
  void _checkForErrors(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      String message;
      dynamic details;

      try {
        final decoded = jsonDecode(response.body);
        message = decoded['message'] ??
            decoded['error'] ??
            'Erreur HTTP ${response.statusCode}';
        details = decoded;
      } catch (_) {
        message = response.body.isNotEmpty
            ? response.body
            : 'Erreur HTTP ${response.statusCode} - ${response.reasonPhrase}';
      }

      throw ApiException(
        statusCode: response.statusCode,
        message: message,
        details: details ?? {'body': response.body},
      );
    }
  }

  /// Factory pour création asynchrone
  static Future<ApiClient> create({
    required String baseUrl,
    Map<String, String>? defaultHeaders,
  }) async {
    return ApiClient(
      baseUrl: baseUrl,
      defaultHeaders: defaultHeaders,
    );
  }
}
