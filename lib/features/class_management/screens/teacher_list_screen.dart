/// teacher_list_screen.dart
/// Affiche la liste des enseignants avec recherche et pagination.
/// Utilisable en accès direct ou depuis une autre entité (classe, matière, etc.)
library;

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/models/user_model.dart';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/user_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TeacherListScreen extends StatefulWidget {
  final String? subjectId; // Pour filtrer par matière si besoin

  const TeacherListScreen({Key? key, this.subjectId}) : super(key: key);

  @override
  State<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends State<TeacherListScreen> {
  late final UserService _userService;
  List<UserModel> _teachers = [];
  bool _isLoading = false;
  String? _error;
  String _search = '';
  int _currentPage = 1;
  final int _pageSize = 30;
  bool _hasMore = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final apiClient = Provider.of<ApiClient>(context, listen: false);
    _userService = UserService(apiClient: apiClient);
    _fetchTeachers(reset: true);
  }

  Future<void> _fetchTeachers({bool reset = false}) async {
    if (reset) {
      setState(() {
        _teachers = [];
        _currentPage = 1;
        _hasMore = true;
      });
    }
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      // Adapte la méthode dans UserService selon ton backend pour supporter search, pagination, subjectId
      final result = await _userService.getTeachers(
        search: _search,
        page: _currentPage,
        pageSize: _pageSize,
        subjectId: widget.subjectId, // Ajoute ce paramètre si tu veux filtrer par matière
      );
      setState(() {
        if (_currentPage == 1) {
          _teachers = result;
        } else {
          _teachers.addAll(result);
        }
        _hasMore = result.length == _pageSize;
      });
    } catch (e) {
      setState(() {
        _error = "Erreur lors du chargement des enseignants : $e";
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _onSearchChanged() {
    _search = _searchController.text.trim();
    _fetchTeachers(reset: true);
  }

  void _loadMore() {
    if (!_hasMore || _isLoading) return;
    setState(() => _currentPage++);
    _fetchTeachers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des enseignants"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _fetchTeachers(reset: true),
            tooltip: 'Rafraîchir',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _onSearchChanged(),
              decoration: InputDecoration(
                hintText: 'Rechercher un enseignant...',
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          if (_isLoading && _teachers.isEmpty)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            Expanded(
              child: Center(
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            )
          else if (_teachers.isEmpty)
            const Expanded(
              child: Center(child: Text('Aucun enseignant trouvé.')),
            )
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _fetchTeachers(reset: true),
                child: ListView.separated(
                  itemCount: _teachers.length + (_hasMore ? 1 : 0),
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    if (index == _teachers.length) {
                      // Loader pour le scroll infini
                      _loadMore();
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final teacher = _teachers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          (teacher.fullName?.isNotEmpty == true
                                  ? teacher.fullName![0]
                                  : (teacher.username?.isNotEmpty == true
                                      ? teacher.username![0]
                                      : '?'))
                              .toUpperCase(),
                        ),
                      ),
                      title: Text(teacher.displayName),
                      subtitle: teacher.email != null ? Text(teacher.email!) : null,
                      onTap: () {
                         context.go('/teacher-detail', extra: teacher);
                      },
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