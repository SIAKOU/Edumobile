/// Service for local storage management (key-value, preferences, etc.).
/// Uses SharedPreferences to store and retrieve data locally.
/// Can be used for tokens, user preferences, various flags, etc.
library;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

class StorageService {
  final SharedPreferences _prefs;

  /// Private constructor for dependency injection
  StorageService._(this._prefs);

  /// Initialize and register the StorageService with GetIt
  static Future<void> initialize(SharedPreferences prefs) async {
    GetIt.I.registerSingleton<StorageService>(StorageService._(prefs));
  }

  /// Get the registered instance from GetIt
  static StorageService get instance => GetIt.I<StorageService>();

  /// Saves a string value
  Future<bool> setString(String key, String value) async {
    try {
      return await _prefs.setString(key, value);
    } catch (e) {
      throw StorageException('Failed to save string: $e');
    }
  }

  /// Retrieves a string value
  String? getString(String key) {
    return _prefs.getString(key);
  }

  /// Saves a boolean value
  Future<bool> setBool(String key, bool value) async {
    try {
      return await _prefs.setBool(key, value);
    } catch (e) {
      throw StorageException('Failed to save boolean: $e');
    }
  }

  /// Retrieves a boolean value
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  /// Removes a key
  Future<bool> remove(String key) async {
    try {
      return await _prefs.remove(key);
    } catch (e) {
      throw StorageException('Failed to remove key: $e');
    }
  }

  /// Clears all local storage
  Future<bool> clear() async {
    try {
      return await _prefs.clear();
    } catch (e) {
      throw StorageException('Failed to clear storage: $e');
    }
  }

  /// Saves an integer value
  Future<bool> setInt(String key, int value) async {
    try {
      return await _prefs.setInt(key, value);
    } catch (e) {
      throw StorageException('Failed to save integer: $e');
    }
  }

  /// Retrieves an integer value
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  /// Saves a double value
  Future<bool> setDouble(String key, double value) async {
    try {
      return await _prefs.setDouble(key, value);
    } catch (e) {
      throw StorageException('Failed to save double: $e');
    }
  }

  /// Retrieves a double value
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  /// Saves a list of strings
  Future<bool> setStringList(String key, List<String> value) async {
    try {
      return await _prefs.setStringList(key, value);
    } catch (e) {
      throw StorageException('Failed to save string list: $e');
    }
  }

  /// Retrieves a list of strings
  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  /// Checks if a key exists
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }
}

/// Custom exception for storage operations
class StorageException implements Exception {
  final String message;
  StorageException(this.message);

  @override
  String toString() => 'StorageException: $message';
}
