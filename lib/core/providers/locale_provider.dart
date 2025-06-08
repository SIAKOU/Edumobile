/// locale_provider.dart
/// Provider (ChangeNotifier) pour la gestion de la langue (locale) dans l'application.
/// Permet de changer la langue de l'application et de notifier les consommateurs du changement.
library;

import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('fr');

  LocaleProvider();

  Locale get locale => _locale;

  /// Définit explicitement la langue
  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }

  /// Réinitialise la langue à la valeur par défaut (français)
  void clearLocale() {
    _locale = const Locale('fr');
    notifyListeners();
  }
}