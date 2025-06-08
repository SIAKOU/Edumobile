
library;

/// student_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/student_dashboard_provider.dart';
import '../../../core/models/class_info_model.dart';
import '../../../core/models/grade_model.dart';
import '../../../core/models/announcement_model.dart';
import '../../../core/models/user_model.dart';
import '../../../app/widgets/layout/screen_wrapper.dart';
import '../../../app/widgets/common/loading_indicator.dart';
import '../../../app/widgets/common/error_widget.dart' as app_error;
import '../widgets/dashboard_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/upcoming_events.dart';
import '../widgets/performance_summary.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../app/config/app_routes.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      title: 'dashboard_student_title'.tr(),
      showDrawer: true,
      child: Consumer<StudentDashboardProvider>(
        builder: (context, dashboard, _) {
          final bool isLoading = dashboard.status == StudentDashboardStatus.loading;
          final String? error = dashboard.errorMessage;
          final UserModel? user = dashboard.currentUser;
          final List<ClassInfoModel> classes = dashboard.classList;
          final List<GradeModel> grades = dashboard.gradeList;
          final List<AnnouncementModel> announcements = dashboard.announcementList;
          final List<dynamic> upcomingEvents = dashboard.upcomingEvents;

          if (isLoading) {
            return const LoadingIndicator();
          }
          if (error != null && error.isNotEmpty) {
            return app_error.CustomErrorWidget(
              message: error,
              onRetry: () => dashboard.loadDashboard(user?.id ?? ""),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => dashboard.loadDashboard(user?.id ?? ""),
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
                      backgroundImage: (user?.avatarUrl != null && user!.avatarUrl!.isNotEmpty)
                          ? NetworkImage(user.avatarUrl!)
                          : const AssetImage('assets/images/placeholders/user_placeholder.png') as ImageProvider,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'dashboard_student_greeting'.tr(namedArgs: {'user': user?.fullName != null ? ', ${user?.fullName}' : ''}),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontFamily: 'Poppins'),
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
                  'dashboard_student_intro'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 18),

                PerformanceSummary(gradesList: grades),
                const SizedBox(height: 18),

                UpcomingEvents(eventsList: upcomingEvents),
                const SizedBox(height: 18),

                DashboardCard(
                  title: 'dashboard_student_courses'.tr(),
                  icon: Icons.class_,
                  actionText: 'dashboard_student_courses_all'.tr(),
                  onActionTap: () {
                    context.goNamed(AppRouteNames.classList);
                  },
                  child: classes.isEmpty
                      ? Center(child: Text('dashboard_student_courses_empty'.tr()))
                      : AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: SizedBox(
                            key: ValueKey(classes.length),
                            height: 150,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: classes.length > 5 ? 5 : classes.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 12),
                              itemBuilder: (context, i) => _CourseMiniCard(course: classes[i]),
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 18),

                DashboardCard(
                  title: 'dashboard_student_grades'.tr(),
                  icon: Icons.grade,
                  actionText: 'dashboard_student_grades_all'.tr(),
                  onActionTap: () {
                    context.goNamed(
                      AppRouteNames.studentGrades,
                      extra: {'studentId': user?.id ?? '', 'classId': ''},
                    );
                  },
                  child: grades.isEmpty
                      ? Center(child: Text('dashboard_student_grades_empty'.tr()))
                      : AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: Column(
                            key: ValueKey(grades.length),
                            children: grades.take(3).map((g) => _GradeTile(grade: g)).toList(),
                          ),
                        ),
                ),
                const SizedBox(height: 18),

                DashboardCard(
                  title: 'dashboard_student_announcements'.tr(),
                  icon: Icons.campaign,
                  actionText: 'dashboard_student_announcements_all'.tr(),
                  onActionTap: () {
                    context.goNamed(AppRouteNames.announcements);
                  },
                  child: announcements.isEmpty
                      ? Center(child: Text('dashboard_student_announcements_empty'.tr()))
                      : AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: Column(
                            key: ValueKey(announcements.length),
                            children: announcements.take(3).map((a) => _AnnouncementTile(announcement: a)).toList(),
                          ),
                        ),
                ),
                const SizedBox(height: 18),

                QuickActions(
                  onScheduleTap: () {
                    final studentClassId = classes.isNotEmpty ? classes.first.id : 'some_default_class_id';
                    context.goNamed(AppRouteNames.schedule, extra: studentClassId);
                  },
                  onFilesTap: () => context.goNamed(AppRouteNames.virtualLibrary),
                  onPaymentsTap: () => context.goNamed(AppRouteNames.paymentList),
                  onAiAssistantTap: () => context.goNamed(AppRouteNames.aiAssistant),
                  onAttendanceTap: () => context.goNamed(AppRouteNames.attendanceRecords),
                  onChatTap: () => context.goNamed(AppRouteNames.directMessages),
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

class _CourseMiniCard extends StatelessWidget {
  final ClassInfoModel course;
  const _CourseMiniCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.07),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          context.goNamed(AppRouteNames.classDetail, extra: course.id);
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
                course.name ?? "",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (course.progress).clamp(0.0, 1.0),
                minHeight: 7,
                backgroundColor: Colors.grey.shade200,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                course.nextTopic ?? 'dashboard_student_next_topic'.tr(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'Poppins'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradeTile extends StatelessWidget {
  final GradeModel grade;
  const _GradeTile({required this.grade});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green.shade100,
        child: Text(
          grade.value.toStringAsFixed(1),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(grade.subjectName ?? 'Cours inconnu'),
      subtitle: Text(grade.type ?? ''),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        context.goNamed(AppRouteNames.gradeDetail, extra: grade);
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
            ? MaterialLocalizations.of(context).formatFullDate(announcement.publishedAt!)
            : '',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      onTap: () {
        context.goNamed(AppRouteNames.announcementDetail, extra: announcement);
      },
    );
  }
}
