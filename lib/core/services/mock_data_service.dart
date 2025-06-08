/// mock_data_service.dart
/// Service utilitaire pour fournir des données factices (mock) lors du développement ou des tests.
/// Peut être utilisé pour simuler les réponses API, listes d'objets, etc.
library;

class MockDataService {
  /// Exemple : Retourne une liste factice d'utilisateurs
  List<Map<String, dynamic>> getMockUsers({int count = 5}) {
    return List.generate(count, (index) {
      return {
        'id': index + 1,
        'name': 'Utilisateur $index',
        'email': 'user$index@example.com',
        'role': index % 2 == 0 ? 'admin' : 'user',
      };
    });
  }

  /// Exemple : Retourne une liste factice de paiements
  List<Map<String, dynamic>> getMockPayments({int count = 5}) {
    return List.generate(count, (index) {
      return {
        'id': index + 1,
        'userId': (index % 3) + 1,
        'amount': 10000 + index * 500,
        'status': index % 2 == 0 ? 'paid' : 'pending',
        'date': DateTime.now().subtract(Duration(days: index)).toIso8601String(),
      };
    });
  }

  /// Exemple : Retourne une liste factice de fichiers de bibliothèque
  List<Map<String, dynamic>> getMockLibraryFiles({int count = 5}) {
    return List.generate(count, (index) {
      return {
        'id': index + 1,
        'title': 'Document $index',
        'type': index % 2 == 0 ? 'pdf' : 'image',
        'url': 'https://example.com/fakefile$index.${index % 2 == 0 ? 'pdf' : 'jpg'}',
        'uploadedAt': DateTime.now().subtract(Duration(days: index)).toIso8601String(),
      };
    });
  }

  /// Exemple : Retourne une présence factice
  Map<String, dynamic> getMockAttendance({int id = 1}) {
    return {
      'id': id,
      'userId': 1,
      'classId': 1,
      'status': 'present',
      'date': DateTime.now().toIso8601String(),
    };
  }
}