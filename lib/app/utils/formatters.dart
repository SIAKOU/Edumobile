/// formatters.dart
/// Fonctions utilitaires pour le formatage des dates, nombres, monnaies, etc.
/// Utilisez ces helpers pour garantir une cohérence d’affichage à travers l’application.
/// Prêt pour l’internationalisation.
library;

import 'package:intl/intl.dart';

class Formatters {
  // --- Dates ---
  static String formatDate(DateTime date, {String locale = 'fr', String pattern = 'dd/MM/yyyy'}) {
    return DateFormat(pattern, locale).format(date);
  }

  static String formatDateTime(DateTime date, {String locale = 'fr', String pattern = 'dd/MM/yyyy HH:mm'}) {
    return DateFormat(pattern, locale).format(date);
  }

  static String formatTime(DateTime date, {String locale = 'fr', String pattern = 'HH:mm'}) {
    return DateFormat(pattern, locale).format(date);
  }

  // --- Nombres ---
  static String formatNumber(num value, {String locale = 'fr', int decimal = 2}) {
    final format = NumberFormat.currency(
      locale: locale,
      symbol: '',
      decimalDigits: decimal,
      customPattern: '#,##0.${'0' * decimal}',
    );
    return format.format(value);
  }

  // --- Monnaie ---
  static String formatCurrency(num value, {String locale = 'fr', String symbol = 'FCFA', int decimal = 2}) {
    final format = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: decimal,
    );
    return format.format(value);
  }

  // --- Pourcentage ---
  static String formatPercent(num value, {String locale = 'fr', int decimal = 1}) {
    final format = NumberFormat.percentPattern(locale);
    format.minimumFractionDigits = decimal;
    return format.format(value);
  }

  // --- Format court (ex : 1.2K, 3.5M) ---
  static String formatCompact(num value, {String locale = 'fr'}) {
    return NumberFormat.compact(locale: locale).format(value);
  }

  // --- Masquage partiel (ex: email, phone) ---
  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final masked = name.length > 2 ? '${name[0]}***${name[name.length - 1]}' : '${name[0]}*';
    return '$masked@${parts[1]}';
  }

  static String maskPhone(String phone) {
    if (phone.length < 6) return phone;
    return '${phone.substring(0, 2)}******${phone.substring(phone.length - 2)}';
  }

  // --- Initiales pour avatar ---
  static String initials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts.last[0]).toUpperCase();
  }
}