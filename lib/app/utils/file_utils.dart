/// file_utils.dart
/// Helpers pour la manipulation de fichiers (lecture, écriture, sélection, suppression, etc.)
/// Compatible Flutter mobile, web et desktop si besoin.
/// Nécessite parfois des dépendances externes (ex: path_provider, file_picker, dart:io).
library;

import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class FileUtils {
  /// Retourne le répertoire documents/temp selon la plateforme
  static Future<String> getAppDirectory({bool temporary = false}) async {
    if (kIsWeb) {
      // Pas vraiment de FS sur le web
      return '/';
    }
    final dir = temporary
        ? await getTemporaryDirectory()
        : await getApplicationDocumentsDirectory();
    return dir.path;
  }

  /// Lit un fichier texte du bundle (assets)
  static Future<String> loadAsset(String assetPath) async {
    return await rootBundle.loadString(assetPath);
  }

  /// Lit un fichier texte local
  static Future<String> readFile(String path) async {
    if (kIsWeb) {
      throw UnsupportedError("Lecture de fichiers locaux non supportée sur le web");
    }
    final file = io.File(path);
    return await file.readAsString();
  }

  /// Ecrit du texte dans un fichier local, l'écrase si existe
  static Future<void> writeFile(String path, String content) async {
    if (kIsWeb) {
      throw UnsupportedError("Écriture de fichiers locaux non supportée sur le web");
    }
    final file = io.File(path);
    await file.writeAsString(content);
  }

  /// Supprime un fichier local
  static Future<void> deleteFile(String path) async {
    if (kIsWeb) {
      throw UnsupportedError("Suppression de fichiers locaux non supportée sur le web");
    }
    final file = io.File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Vérifie si le fichier existe (local seulement)
  static Future<bool> fileExists(String path) async {
    if (kIsWeb) return false;
    final file = io.File(path);
    return file.exists();
  }

  /// Retourne le nom de fichier sans le chemin
  static String basename(String filePath) => p.basename(filePath);

  /// Retourne le dossier parent
  static String dirname(String filePath) => p.dirname(filePath);

  /// Extension du fichier
  static String extension(String filePath) => p.extension(filePath);

  /// Sélectionne un fichier via file_picker (mobile/desktop)
  /// Nécessite le package file_picker
  /*
  static Future<PlatformFile?> pickFile({
    List<String>? allowedExtensions,
    FileType type = FileType.any,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: type,
      allowedExtensions: allowedExtensions,
    );
    return result?.files.first;
  }
  */
}