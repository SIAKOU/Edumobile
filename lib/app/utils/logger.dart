/// logger.dart
/// Utilitaire de logging centralisé et personnalisable pour l’application.
/// Permet de contrôler le niveau de logs (debug, info, warning, error), le format et la sortie.
/// Peut s’intégrer à des services externes (Sentry, Crashlytics, etc.) si besoin.
library;

import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class Logger {
  static LogLevel logLevel = LogLevel.debug;

  /// Active/désactive l’affichage console (utile en prod)
  static bool enableConsole = kDebugMode;

  /// Logger debug (détails pour le dev)
  static void debug(String message, {Object? error, StackTrace? stackTrace}) {
    if (logLevel.index <= LogLevel.debug.index) {
      _log('DEBUG', message, error: error, stackTrace: stackTrace);
    }
  }

  /// Logger info (infos importantes mais pas critiques)
  static void info(String message, {Object? error, StackTrace? stackTrace}) {
    if (logLevel.index <= LogLevel.info.index) {
      _log('INFO', message, error: error, stackTrace: stackTrace);
    }
  }

  /// Logger warning (anomalie non bloquante)
  static void warning(String message, {Object? error, StackTrace? stackTrace}) {
    if (logLevel.index <= LogLevel.warning.index) {
      _log('WARNING', message, error: error, stackTrace: stackTrace);
    }
  }

  /// Logger error (erreurs à corriger)
  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    if (logLevel.index <= LogLevel.error.index) {
      _log('ERROR', message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log brut personnalisé, pour usage avancé
  static void log(
    String tag,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    LogLevel level = LogLevel.debug,
  }) {
    if (logLevel.index <= level.index) {
      _log(tag, message, error: error, stackTrace: stackTrace);
    }
  }

  /// Implémentation interne du log
  static void _log(
    String tag,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!enableConsole) return;
    final time = DateTime.now().toIso8601String();
    var log = '[$time] [$tag] $message';
    if (error != null) log += '\n  Error: $error';
    if (stackTrace != null) log += '\n  Stack: $stackTrace';
    // Affichage console
    debugPrint(log);
    // Ici, vous pouvez ajouter l’envoi à un service externe si besoin (Sentry, Crashlytics, etc.)
  }
}