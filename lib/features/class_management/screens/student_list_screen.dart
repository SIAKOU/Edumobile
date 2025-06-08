/// student_list_screen.dart
/// Affiche la liste des élèves d'une classe, avec recherche et pagination.
/// Peut être utilisé depuis un détail de classe ou en accès direct.
library;

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/models/user_model.dart';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/user_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class StudentListScreen extends StatefulWidget {
  final String? classId;
  final String? className;

  const StudentListScreen({Key? key, this.classId, this.className})
      : super(key: key);

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  late final UserService _userService;
  List<UserModel> _students = [];
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
    _fetchStudents(reset: true);
  }

  Future<void> _fetchStudents({bool reset = false}) async {
    if (reset) {
      setState(() {
        _students = [];
        _currentPage = 1;
        _hasMore = true;
      });
    }
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      // Adapte la méthode dans UserService selon ton backend pour supporter search, pagination, classId
      final result = await _userService.getStudents(
        classId: widget.classId,
        search: _search,
        page: _currentPage,
        pageSize: _pageSize,
      );
      setState(() {
        if (_currentPage == 1) {
          _students = result;
        } else {
          _students.addAll(result);
        }
        _hasMore = result.length == _pageSize;
      });
    } catch (e) {
      setState(() {
        _error = "Erreur lors du chargement des élèves : $e";
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _onSearchChanged() {
    _search = _searchController.text.trim();
    _fetchStudents(reset: true);
  }

  void _loadMore() {
    if (!_hasMore || _isLoading) return;
    setState(() => _currentPage++);
    _fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.className != null
            ? "Élèves de la classe ${widget.className}"
            : "Liste des élèves"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _fetchStudents(reset: true),
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
                hintText: 'Rechercher un élève...',
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
          if (_isLoading && _students.isEmpty)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            Expanded(
              child: Center(
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            )
          else if (_students.isEmpty)
            const Expanded(
              child: Center(child: Text('Aucun élève trouvé.')),
            )
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _fetchStudents(reset: true),
                child: ListView.separated(
                  itemCount: _students.length + (_hasMore ? 1 : 0),
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    if (index == _students.length) {
                      // Loader pour le scroll infini
                      _loadMore();
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final student = _students[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          (student.fullName?.isNotEmpty == true
                                  ? student.fullName![0]
                                  : (student.username?.isNotEmpty == true
                                      ? student.username![0]
                                      : '?'))
                              .toUpperCase(),
                        ),
                      ),
                      title: Text(student.displayName),
                      subtitle:
                          student.email != null ? Text(student.email!) : null,
                      onTap: () {
                        // Naviguer vers l'écran de détail de l'élève
                        context.go('/student-detail', extra: student);
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
