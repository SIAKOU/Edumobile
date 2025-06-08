/// Extension utilitaire pour accéder facilement aux champs courants dans un Map<String, dynamic>
/// Exemple d'usage :
///   map.isActive
///   map.role
library;

extension UserMapExtensions on Map<String, dynamic> {
  /// Retourne la valeur booléenne du champ 'isActive' ou 'is_active' si présente, sinon false.
  bool get isActive {
    final value = this['isActive'] ?? this['is_active'];
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) return value.toLowerCase() == 'true' || value == '1';
    return false;
  }

  /// Retourne la valeur du champ 'role' ou 'userRole' si présente, sinon null.
  String? get role {
    return this['role'] as String? ?? this['userRole'] as String?;
  }
}