/// library_provider.dart
/// Provider (ChangeNotifier) pour gérer l'état de la bibliothèque (library) dans l'application.
/// Utilise LibraryRepository pour effectuer les opérations backend et expose l'état à la couche UI.
/// Permet de charger la liste des livres, les détails, l'ajout, la mise à jour, la suppression, etc.
library;

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/repositories/library_repository.dart';


enum LibraryStatus { initial, loading, loaded, error }

class LibraryProvider extends ChangeNotifier {
  final LibraryRepository libraryRepository;

  LibraryStatus _status = LibraryStatus.initial;
  List<Map<String, dynamic>> _books = [];
  Map<String, dynamic>? _selectedBook;
  String? _errorMessage;

  LibraryProvider({required this.libraryRepository});

  LibraryStatus get status => _status;
  List<Map<String, dynamic>> get books => _books;
  Map<String, dynamic>? get selectedBook => _selectedBook;
  String? get errorMessage => _errorMessage;

  /// Charge la liste des livres (optionnellement par catégorie ou auteur)
  Future<void> loadBooks({String? categoryId, String? authorId}) async {
    _status = LibraryStatus.loading;
    notifyListeners();
    try {
      _books = await libraryRepository.getBooks(categoryId: categoryId, authorId: authorId);
      _status = LibraryStatus.loaded;
    } catch (e) {
      _status = LibraryStatus.error;
      _errorMessage = "Erreur lors du chargement des livres.";
    }
    notifyListeners();
  }

  /// Charge les détails d'un livre
  Future<void> loadBookById(String bookId) async {
    _status = LibraryStatus.loading;
    notifyListeners();
    try {
      _selectedBook = await libraryRepository.getBookById(bookId);
      _status = LibraryStatus.loaded;
    } catch (e) {
      _status = LibraryStatus.error;
      _errorMessage = "Erreur lors du chargement du livre.";
    }
    notifyListeners();
  }

  /// Ajoute un nouveau livre
  Future<bool> createBook(Map<String, dynamic> bookData) async {
    _status = LibraryStatus.loading;
    notifyListeners();
    try {
      final success = await libraryRepository.createBook(bookData);
      if (success) {
        await loadBooks();
        _status = LibraryStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = LibraryStatus.error;
        _errorMessage = "L'ajout du livre a échoué.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = LibraryStatus.error;
      _errorMessage = "Erreur lors de l'ajout du livre.";
      notifyListeners();
      return false;
    }
  }

  /// Met à jour un livre
  Future<bool> updateBook(String bookId, Map<String, dynamic> updateData) async {
    _status = LibraryStatus.loading;
    notifyListeners();
    try {
      final success = await libraryRepository.updateBook(bookId, updateData);
      if (success) {
        await loadBookById(bookId);
        await loadBooks();
        _status = LibraryStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = LibraryStatus.error;
        _errorMessage = "La mise à jour du livre a échoué.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = LibraryStatus.error;
      _errorMessage = "Erreur lors de la mise à jour du livre.";
      notifyListeners();
      return false;
    }
  }

  /// Supprime un livre
  Future<bool> deleteBook(String bookId) async {
    _status = LibraryStatus.loading;
    notifyListeners();
    try {
      final success = await libraryRepository.deleteBook(bookId);
      if (success) {
        await loadBooks();
        _status = LibraryStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = LibraryStatus.error;
        _errorMessage = "La suppression du livre a échoué.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = LibraryStatus.error;
      _errorMessage = "Erreur lors de la suppression du livre.";
      notifyListeners();
      return false;
    }
  }
}