/// class_list_screen.dart
/// Écran listant toutes les classes de l'établissement.
/// Recherche, pagination, accès aux détails et gestion (création, édition, suppression) selon le rôle.
library;

import 'package:flutter/material.dart';
import 'package:gestion_ecole/app/config/app_routes.dart';
import 'package:gestion_ecole/core/models/class_model.dart';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/class_service.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ClassListScreen extends StatefulWidget {
  const ClassListScreen({super.key});

  @override
  State<ClassListScreen> createState() => _ClassListScreenState();
}

class _ClassListScreenState extends State<ClassListScreen> {
  final List<ClassModel> _classes = [];
  bool _isLoading = false;
  String? _error;
  String _search = '';
  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMore = true;
  final TextEditingController _searchController = TextEditingController();
  late final ClassService _classService;
  late final GoRouter _router;
  late final GoRouterState _routerState;
  late ApiClient _apiClient;

  @override
  @override
  void initState() {
    super.initState();
    _apiClient = di<ApiClient>();
    _classService = ClassService(apiClient: _apiClient);
    _fetchClasses(reset: true);
  }

  Future<void> _fetchClasses({bool reset = false}) async {
    if (reset) {
      setState(() {
        _classes.clear();
        _currentPage = 1;
        _hasMore = true;
      });
    }
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final result = await _classService.getClasses(
        search: _search,
        page: _currentPage,
        pageSize: _pageSize,
      );
      setState(() {
        if (_currentPage == 1) {
          _classes.clear();
          _classes.addAll(result);
        } else {
          _classes.addAll(result);
        }
        _hasMore = result.length == _pageSize;
      });
    } catch (e) {
      setState(() {
        _error = 'Erreur lors du chargement des classes : $e';
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _onSearchChanged() {
    _search = _searchController.text.trim();
    _fetchClasses(reset: true);
  }

  void _goToClassDetail(ClassModel classModel) {
    context.go('/class-detail', extra: classModel);
  }

  void _goToCreateClass() {
    context.go('/class-form');
  }

  void _loadMore() {
    if (!_hasMore || _isLoading) return;
    setState(() => _currentPage++);
    _fetchClasses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des classes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _fetchClasses(reset: true),
            tooltip: 'Rafraîchir',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCreateClass,
        tooltip: 'Ajouter une classe',
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _onSearchChanged(),
              decoration: InputDecoration(
                hintText: 'Rechercher une classe...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged();
                        },
                      )
                    : null,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          if (_isLoading && _classes.isEmpty)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            Expanded(
              child: Center(
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            )
          else if (_classes.isEmpty)
            const Expanded(
              child: Center(child: Text('Aucune classe trouvée.')),
            )
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _fetchClasses(reset: true),
                child: ListView.separated(
                  itemCount: _classes.length + (_hasMore ? 1 : 0),
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    if (index == _classes.length) {
                      // Loader pour le scroll infini
                      _loadMore();
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final classModel = _classes[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(classModel.name.isNotEmpty
                            ? classModel.name[0].toUpperCase()
                            : '?'),
                      ),
                      title: Text(classModel.name),
                      subtitle:
                          Text('Effectif : ${classModel.studentCount ?? "?"}'),
                      onTap: () => _goToClassDetail(classModel),
                      trailing: (classModel.isArchived ?? false)
                          ? const Icon(Icons.archive, color: Colors.grey)
                          : null,
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
