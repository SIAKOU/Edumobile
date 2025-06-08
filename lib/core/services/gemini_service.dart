import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service pour interroger l'API Gemini (Google AI)
class GeminiService {
  final String apiKey;
  final String apiUrl;
  final String model;

  /// [apiKey] : ta clé API Gemini
  /// [apiUrl] : URL de l'API Gemini (par défaut : generativeLanguage)
  /// [model]  : nom du modèle (ex: gemini-pro, gemini-1.5-pro)
  GeminiService({
    this.apiKey = 'AIzaSyCD4cqiERSXClLHWZX1WdMaQnn3YgeviCw',
    this.apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=GEMINI_API_KEY',
    this.model = 'gemini-pro',
  });

  /// Envoie un prompt et récupère la réponse de Gemini (mode "chat")
  Future<String> sendMessage(String prompt, {List<Map<String, String>>? history}) async {
    // Gemini attend un format "contents" (liste d'échanges)
    final contents = <Map<String, dynamic>>[
      if (history != null)
        ...history.map((h) => {
              'role': h['role'] ?? 'user',
              'parts': [
                {'text': h['content'] ?? ''}
              ]
            }),
      {
        'role': 'user',
        'parts': [
          {'text': prompt}
        ]
      }
    ];

    final url = Uri.parse('$apiUrl/$model:generateContent?key=$apiKey');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'contents': contents}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final candidates = data['candidates'] as List?;
      if (candidates != null && candidates.isNotEmpty) {
        final parts = candidates.first['content']?['parts'] as List?;
        if (parts != null && parts.isNotEmpty) {
          return parts.first['text']?.toString().trim() ?? '';
        }
      }
      throw Exception('Aucune réponse générée par Gemini.');
    } else {
      String msg = 'Erreur Gemini (${response.statusCode})';
      try {
        final data = jsonDecode(response.body);
        msg += ': ${data['error']?['message'] ?? response.body}';
      } catch (_) {}
      throw Exception(msg);
    }
  }
}