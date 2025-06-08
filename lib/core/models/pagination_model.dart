/// pagination_model.dart
/// Modèle générique pour représenter une page de résultats paginés (liste d'éléments avec infos de pagination).
/// Utile pour les retours d'API paginés ou la gestion locale de listes volumineuses.
library;

import 'package:equatable/equatable.dart';

class PaginationModel<T> extends Equatable {
  final List<T> items;           // Liste des éléments de la page
  final int page;                // Numéro de la page (0 ou 1 basé selon convention)
  final int pageSize;            // Nombre d'éléments par page
  final int totalItems;          // Nombre total d'éléments
  final int totalPages;          // Nombre total de pages

  const PaginationModel({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [items, page, pageSize, totalItems, totalPages];

  /// Factory pour créer à partir d'un JSON, avec un constructeur d'item optionnel
  factory PaginationModel.fromJson(
    Map<String, dynamic> json, {
    required T Function(dynamic) fromItem,
  }) {
    final List<dynamic> rawItems = json['items'] ?? json['results'] ?? [];
    return PaginationModel<T>(
      items: rawItems.map((e) => fromItem(e)).toList(),
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? json['page_size'] as int? ?? rawItems.length,
      totalItems: json['totalItems'] as int? ?? json['total_items'] as int? ?? rawItems.length,
      totalPages: json['totalPages'] as int? ?? json['total_pages'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'items': items,
        'page': page,
        'pageSize': pageSize,
        'totalItems': totalItems,
        'totalPages': totalPages,
      };

  /// Copie avec modifications
  PaginationModel<T> copyWith({
    List<T>? items,
    int? page,
    int? pageSize,
    int? totalItems,
    int? totalPages,
  }) {
    return PaginationModel<T>(
      items: items ?? this.items,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}