/// platform_utils.dart
/// Fonctions utilitaires pour gérer les spécificités des plateformes (iOS, Android, web, desktop, etc.)
/// Permet d'adapter certains comportements ou UI selon la plateforme cible.
library;

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

class PlatformUtils {
  /// True si l'app tourne sur le Web
  static bool get isWeb => kIsWeb;

  /// True si l'app tourne sur Android
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  /// True si l'app tourne sur iOS
  static bool get isIOS => !kIsWeb && Platform.isIOS;

  /// True si l'app tourne sur macOS
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  /// True si l'app tourne sur Windows
  static bool get isWindows => !kIsWeb && Platform.isWindows;

  /// True si l'app tourne sur Linux
  static bool get isLinux => !kIsWeb && Platform.isLinux;

  /// True si l'app tourne sur un desktop (Windows, macOS, Linux)
  static bool get isDesktop =>
      !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);

  /// True si l'app tourne sur mobile (Android ou iOS)
  static bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  /// Retourne la plateforme actuelle sous forme de chaîne
  static String get currentPlatform {
    if (isWeb) return "Web";
    if (isAndroid) return "Android";
    if (isIOS) return "iOS";
    if (isMacOS) return "macOS";
    if (isWindows) return "Windows";
    if (isLinux) return "Linux";
    return "Unknown";
  }

  /// Renvoie le TargetPlatform Flutter adapté
  static TargetPlatform get flutterPlatform => defaultTargetPlatform;

  /// Exemple d'utilisation pour adapter une UI :
  /// if (PlatformUtils.isIOS) {...} else {...}
}