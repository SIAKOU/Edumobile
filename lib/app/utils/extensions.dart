/// extensions.dart
/// Extensions Dart utiles et réutilisables pour améliorer la lisibilité du code.
/// Place ici toutes tes extensions custom (sur String, DateTime, num, List, BuildContext, etc.)
library;

// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExtensions on String {
  /// Capitalise la première lettre
  String capitalize() =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : this;

  /// Retourne true si la chaîne est un email valide
  bool get isValidEmail =>
      RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(this);

  /// Retourne true si la chaîne est un numéro de téléphone international
  bool get isValidPhone =>
      RegExp(r'^\+?\d{7,15}$').hasMatch(this);

  /// Tronque la chaîne à [maxLength] caractères, ajoute "…" si coupée
  String truncate(int maxLength) =>
      (length <= maxLength) ? this : '${substring(0, maxLength)}…';

  /// Retire tous les espaces
  String removeSpaces() => replaceAll(' ', '');
}

extension DateTimeExtensions on DateTime {
  /// Formatage rapide en JJ/MM/AAAA
  String toShortFr() => DateFormat('dd/MM/yyyy', 'fr').format(this);

  /// Formatage rapide en JJ/MM/AAAA HH:MM
  String toShortWithTimeFr() => DateFormat('dd/MM/yyyy HH:mm', 'fr').format(this);

  /// Retourne l’âge (en années) par rapport à aujourd’hui
  int get age {
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }
}

extension NumExtensions on num {
  /// Formate le nombre en monnaie (ex: 1 234,50 €)
  String toCurrencyFr({String symbol = '€', int decimal = 2}) =>
      NumberFormat.currency(locale: 'fr', symbol: symbol, decimalDigits: decimal).format(this);

  /// Formate en pourcentage (ex: 12,5 %)
  String toPercentFr({int decimal = 1}) =>
      NumberFormat.percentPattern('fr').format(this);

  /// Formate en forme compacte (1.2K, 3.5M)
  String toCompactFr() =>
      NumberFormat.compact(locale: 'fr').format(this);
}

extension ListExtensions<T> on List<T> {
  /// Retourne true si la liste est vide ou null
  bool get isNullOrEmpty => this == null || isEmpty;

  /// Retourne le premier élément correspondant au prédicat, sinon null
  T? firstWhereOrNull(bool Function(T) test) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }
}

extension BuildContextExtensions on BuildContext {
  /// Raccourci pour accéder à MediaQuery.size
  Size get screenSize => MediaQuery.of(this).size;

  /// Raccourci pour afficher un snackbar facilement
  void showSnackBar(String message, {Duration duration = const Duration(seconds: 2)}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message), duration: duration),
    );
  }
}