/// validators.dart
/// Fonctions de validation centralisées pour tous les formulaires de l’application.
/// Utilisez-les dans vos TextFormField, vos services ou vos widgets personnalisés.
/// Messages prêts à être traduits (i18n).
library;

class Validators {
  // --- Champ obligatoire ---
  static String? required(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'Ce champ est obligatoire';
    }
    return null;
  }

  // --- Email valide ---
  static String? email(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!regex.hasMatch(value)) {
      return message ?? 'Adresse email invalide';
    }
    return null;
  }

  // --- Mot de passe fort ---
  static String? password(String? value, {int minLength = 8, String? message}) {
    if (value == null || value.isEmpty) return null;
    if (value.length < minLength) {
      return message ?? 'Le mot de passe doit contenir au moins $minLength caractères';
    }
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins une majuscule';
    }
    if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins une minuscule';
    }
    if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins un chiffre';
    }
    if (!RegExp(r'(?=.*[!@#\$&*~\-_])').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins un caractère spécial';
    }
    return null;
  }

  // --- Confirmation de mot de passe ---
  static String? confirmPassword(String? value, String? original, {String? message}) {
    if (value != original) {
      return message ?? 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  // --- Numéro de téléphone international ---
  static String? phone(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(r'^\+?\d{7,15}$');
    if (!regex.hasMatch(value)) {
      return message ?? 'Numéro de téléphone invalide';
    }
    return null;
  }

  // --- Nom d’utilisateur alphanumérique ---
  static String? username(String? value, {int minLength = 3, String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    if (value.length < minLength) {
      return message ?? 'Le nom d\'utilisateur doit contenir au moins $minLength caractères';
    }
    if (!RegExp(r'^[a-zA-Z0-9_.-]+$').hasMatch(value)) {
      return 'Seuls les caractères a-z, 0-9, _ . - sont autorisés';
    }
    return null;
  }

  // --- Valeur numérique ---
  static String? number(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    if (double.tryParse(value) == null) {
      return message ?? 'Veuillez entrer un nombre valide';
    }
    return null;
  }

  // --- Date valide (ISO) ---
  static String? date(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    try {
      DateTime.parse(value);
    } catch (_) {
      return message ?? 'Date invalide (format attendu AAAA-MM-JJ)';
    }
    return null;
  }

  // --- Longueur minimale ---
  static String? minLength(String? value, int length, {String? message}) {
    if (value == null || value.length < length) {
      return message ?? 'Doit contenir au moins $length caractères';
    }
    return null;
  }

  // --- Longueur maximale ---
  static String? maxLength(String? value, int length, {String? message}) {
    if (value != null && value.length > length) {
      return message ?? 'Ne doit pas dépasser $length caractères';
    }
    return null;
  }

  // --- Validation par motif RegExp ---
  static String? pattern(String? value, String pattern, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    if (!RegExp(pattern).hasMatch(value)) {
      return message ?? 'Format invalide';
    }
    return null;
  }
}