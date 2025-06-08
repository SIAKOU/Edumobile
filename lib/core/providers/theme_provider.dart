/// theme_provider.dart
/// Provider (ChangeNotifier) pour la gestion du thème (clair/sombre) dans l'application.
/// Permet de basculer entre les modes light et dark, et de notifier les consommateurs du changement.
library;

import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider();

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Définit le mode thème explicitement
  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  /// Bascule entre clair et sombre
  void toggleTheme() {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }
    notifyListeners();
  }
}