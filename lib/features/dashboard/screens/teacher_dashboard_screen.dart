library;

/// teacher_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/teacher_dashboard_provider.dart';
import '../../../core/models/class_info_model.dart';
import '../../../core/models/announcement_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/assignment_model.dart';
import '../../../app/widgets/layout/screen_wrapper.dart';
import '../../../app/widgets/common/loading_indicator.dart';
import '../../../app/widgets/common/error_widget.dart' as app_error;
import '../widgets/dashboard_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/upcoming_events.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../app/config/app_routes.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      title: 'dashboard_teacher_title'.tr(),
      showDrawer: true,
      child: Consumer<TeacherDashboardProvider>(
        builder: (context, dashboard, _) {
          final bool isLoading =
              dashboard.state == TeacherDashboardState.loading;
          final String? error = dashboard.errorMessage;
          final UserModel? user = dashboard.currentUser;
          final List<ClassInfoModel> classes = dashboard.classList;
          final List<AssignmentModel> assignmentsToReview =
              dashboard.assignmentsToReview;
          final List<AnnouncementModel> announcements =
              dashboard.announcementList;
          final List<dynamic> upcomingEvents = dashboard.upcomingEvents;

          if (isLoading) {
            return const LoadingIndicator();
          }
          if (error != null && error.isNotEmpty) {
            return app_error.CustomErrorWidget(
              message: error,
              onRetry: () => dashboard.loadDashboard(),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => dashboard.loadDashboard(),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                // Header: User info and notifications
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: (user?.avatarUrl != null &&
                              user!.avatarUrl!.isNotEmpty)
                          ? NetworkImage(user.avatarUrl!)
                          : const AssetImage(
                                  'assets/images/placeholders/user_placeholder.png')
                              as ImageProvider,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'dashboard_teacher_greeting'.tr(namedArgs: {
                          'user': user?.fullName != null
                              ? ', ${user?.fullName}'
                              : ''
                        }),
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontFamily: 'Poppins'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () {
                        context.goNamed(AppRouteNames.announcements);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'dashboard_teacher_intro'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 18),
                UpcomingEvents(eventsList: upcomingEvents),
                const SizedBox(height: 18),
                DashboardCard(
                  title: 'dashboard_teacher_classes'.tr(),
                  icon: Icons.class_,
                  actionText: 'dashboard_teacher_classes_all'.tr(),
                  onActionTap: () => context.goNamed(AppRouteNames.classList),
                  child: classes.isEmpty
                      ? Center(
                          child: Text('dashboard_teacher_classes_empty'.tr()))
                      : AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: SizedBox(
                            key: ValueKey(classes.length),
                            height: 150,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  classes.length > 5 ? 5 : classes.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, i) =>
                                  _ClassMiniCard(classInfo: classes[i]),
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 18),
                DashboardCard(
                  title: 'dashboard_teacher_assignments'.tr(),
                  icon: Icons.assignment,
                  actionText: 'dashboard_teacher_assignments_all'.tr(),
                  // Navigue vers la page d'entrée des notes (ou adapte si tu as une page dédiée aux devoirs)
                  onActionTap: () => context.goNamed(AppRouteNames.enterGrades),
                  child: assignmentsToReview.isEmpty
                      ? Center(
                          child:
                              Text('dashboard_teacher_assignments_empty'.tr()))
                      : AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: Column(
                            key: ValueKey(assignmentsToReview.length),
                            children: assignmentsToReview
                                .take(3)
                                .map((a) => _AssignmentTile(assignment: a))
                                .toList(),
                          ),
                        ),
                ),
                const SizedBox(height: 18),
                DashboardCard(
                  title: 'dashboard_teacher_announcements'.tr(),
                  icon: Icons.campaign,
                  actionText: 'dashboard_teacher_announcements_all'.tr(),
                  onActionTap: () =>
                      context.goNamed(AppRouteNames.announcements),
                  child: announcements.isEmpty
                      ? Center(
                          child: Text(
                              'dashboard_teacher_announcements_empty'.tr()))
                      : AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: Column(
                            key: ValueKey(announcements.length),
                            children: announcements
                                .take(3)
                                .map((a) => _AnnouncementTile(announcement: a))
                                .toList(),
                          ),
                        ),
                ),
                const SizedBox(height: 18),
                QuickActions(
                  onScheduleTap: () {
                    final teacherClassId = classes.isNotEmpty
                        ? classes.first.id
                        : 'some_default_class_id';
                    context.goNamed(AppRouteNames.schedule,
                        extra: teacherClassId);
                  },
                  onFilesTap: () =>
                      context.goNamed(AppRouteNames.virtualLibrary),
                  onAiAssistantTap: () =>
                      context.goNamed(AppRouteNames.aiAssistant),
                  onAttendanceTap: () =>
                      context.goNamed(AppRouteNames.attendanceRecords),
                  onChatTap: () =>
                      context.goNamed(AppRouteNames.directMessages),
                  onPaymentsTap: () =>
                      context.goNamed(AppRouteNames.paymentList),
                ),
                const SizedBox(height: 18),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ClassMiniCard extends StatelessWidget {
  final ClassInfoModel classInfo;
  const _ClassMiniCard({required this.classInfo});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.08),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          context.goNamed(AppRouteNames.classDetail, extra: classInfo.id);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: 170,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                classInfo.name ?? "",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                classInfo.level ?? '',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontFamily: 'Poppins'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                'dashboard_teacher_students_count'.tr(namedArgs: {
                  'count': (classInfo.studentCount ?? 0).toString()
                }),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontFamily: 'Poppins'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssignmentTile extends StatelessWidget {
  final AssignmentModel assignment;
  const _AssignmentTile({required this.assignment});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.assignment, color: Colors.orange),
      title: Text(
        assignment.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontFamily: 'Poppins'),
      ),
      subtitle: Text(
        'dashboard_teacher_due'.tr(namedArgs: {
          'date': assignment.dueDate != null
              ? MaterialLocalizations.of(context)
                  .formatFullDate(assignment.dueDate!)
              : "?"
        }),
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(fontFamily: 'Poppins'),
      ),
      trailing:
          assignment.toReviewCount != null && assignment.toReviewCount! > 0
              ? CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.red.shade100,
                  child: Text(
                    '${assignment.toReviewCount}',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontFamily: 'Poppins'),
                  ),
                )
              : null,
      onTap: () {
        // Si tu as une route de détail devoir, utilise-la ici
        // context.pushNamed(AppRouteNames.assignmentDetail, extra: assignment);
        debugPrint(
            'Navigation vers le détail devoir non implémentée car la route est manquante.');
      },
    );
  }
}

class _AnnouncementTile extends StatelessWidget {
  final AnnouncementModel announcement;
  const _AnnouncementTile({required this.announcement});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.notifications_active, color: Colors.blue),
      title: Text(
        announcement.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        (announcement.publishedAt != null)
            ? MaterialLocalizations.of(context)
                .formatFullDate(announcement.publishedAt!)
            : '',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      onTap: () {
        context.goNamed(AppRouteNames.announcementDetail, extra: announcement);
      },
    );
  }
}
