/// assignment_list_screen.dart
/// Écran affichant la liste des devoirs.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../core/providers/assignment_list_provider.dart';
import '../../../core/models/assignment_model.dart';
import '../../../app/widgets/layout/screen_wrapper.dart';
import '../../../app/widgets/common/loading_indicator.dart';
import '../../../app/widgets/common/error_widget.dart' as app_error;
import '../../../app/config/app_routes.dart'; // Import AppRouteNames

class AssignmentListScreen extends StatefulWidget {
  // Paramètres optionnels pour filtrer la liste
  final String? classId;
  final String? teacherId;
  final String? studentId;
  final bool? toReview; // Pour afficher les devoirs à corriger

  const AssignmentListScreen({
    super.key,
    this.classId,
    this.teacherId,
    this.studentId,
    this.toReview,
  });

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}

class _AssignmentListScreenState extends State<AssignmentListScreen> {
  @override
  void initState() {
    super.initState();
    // Déclenche le chargement des devoirs au démarrage de l'écran
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AssignmentListProvider>(context, listen: false).loadAssignments(
        classId: widget.classId,
        teacherId: widget.teacherId,
        studentId: widget.studentId,
        toReview: widget.toReview,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      // Adapte le titre en fonction des filtres si nécessaire
      title: widget.toReview == true ? 'assignments_to_review_title'.tr() : 'assignments_list_title'.tr(),
      showDrawer: true, // Adapte si l'écran doit avoir un tiroir
      child: Consumer<AssignmentListProvider>(
        builder: (context, provider, _) {
          final bool isLoading = provider.status == AssignmentListStatus.loading;
          final String? error = provider.errorMessage;
          final List<AssignmentModel> assignments = provider.assignments;

          if (isLoading && assignments.isEmpty) { // Afficher l'indicateur seulement si la liste est vide
            return const LoadingIndicator();
          }
          if (error != null && error.isNotEmpty) {
            return app_error.CustomErrorWidget(
              message: error,
              onRetry: () => provider.loadAssignments( // Permet de réessayer avec les mêmes filtres
                classId: widget.classId,
                teacherId: widget.teacherId,
                studentId: widget.studentId,
                toReview: widget.toReview,
              ),
            );
          }

          if (assignments.isEmpty && !isLoading) { // Afficher un message si la liste est vide après chargement
             return Center(
               child: Text('assignments_list_empty'.tr()),
             );
          }

          return RefreshIndicator(
            onRefresh: () async => provider.loadAssignments( // Permet de rafraîchir avec les mêmes filtres
              classId: widget.classId,
              teacherId: widget.teacherId,
              studentId: widget.studentId,
              toReview: widget.toReview,
            ),
            child: ListView.separated(
              itemCount: assignments.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final assignment = assignments[index];
                return _AssignmentListTile(assignment: assignment);
              },
            ),
          );
        },
      ),
    );
  }
}

// Widget pour afficher un devoir dans la liste
class _AssignmentListTile extends StatelessWidget {
  final AssignmentModel assignment;
  const _AssignmentListTile({required this.assignment});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.assignment, color: Colors.blueGrey),
      title: Text(
        assignment.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Affiche la date d'échéance si disponible
          if (assignment.dueDate != null)
            Text(
              'assignments_due_date'.tr(namedArgs: {'date': MaterialLocalizations.of(context).formatFullDate(assignment.dueDate!)}),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          // Affiche le nombre de copies à corriger si pertinent
          if (assignment.toReviewCount != null && assignment.toReviewCount! > 0)
             Text(
               'assignments_to_review_count'.tr(namedArgs: {'count': assignment.toReviewCount!.toString()}),
               style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red),
             ),
          // Ajoutez d'autres informations pertinentes (classe, matière, etc.)
          // Exemple: Text(assignment.className ?? ''),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Naviguer vers l'écran de détail du devoir ou de correction
        // Assurez-vous que la route 'assignmentDetail' existe et gère le type extra
        context.pushNamed(AppRouteNames.assignmentDetail, extra: assignment);
      },
    );
  }
}

