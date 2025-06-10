import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/admin_dashboard_provider.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/class_info_model.dart';
import '../../../core/models/announcement_model.dart';
import '../../../app/widgets/layout/screen_wrapper.dart';
import '../../../app/widgets/common/loading_indicator.dart';
import '../../../app/widgets/common/error_widget.dart' as app_error;
import '../widgets/dashboard_card.dart';
import '../widgets/quick_actions.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../app/config/app_routes.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      title: 'dashboard_admin_title'.tr(),
      showDrawer: true,
      child: Consumer<AdminDashboardProvider>(
        builder: (context, dashboard, _) {
          final bool isLoading =
              dashboard.status == AdminDashboardStatus.loading;
          final String? error = dashboard.errorMessage;
          final UserModel? user = dashboard.currentUser;
          final List<UserModel> users = dashboard.userList ?? [];
          final List<ClassInfoModel> classes = dashboard.classList ?? [];
          final List<AnnouncementModel> announcements =
              dashboard.announcementList ?? [];
          final int? activeUsers = dashboard.activeUsers;
          final int? totalPayments = dashboard.totalPayments;

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
                        'dashboard_admin_greeting'.tr(namedArgs: {
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
                        context.goNamed('announcements'); // Utiliser le nom de la route
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'dashboard_admin_intro'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 18),

                // Stat cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StatCard(
                      label: 'dashboard_admin_active_users'.tr(),
                      value: activeUsers?.toString() ?? "0",
                      icon: Icons.people,
                      color: Colors.blue,
                    ),
                    _StatCard(
                      label: 'dashboard_admin_payments'.tr(),
                      value: totalPayments?.toString() ?? "0",
                      icon: Icons.payment,
                      color: Colors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Users management
                DashboardCard(
                  title: 'dashboard_admin_users'.tr(),
                  icon: Icons.people,
                  actionText: 'dashboard_admin_users_manage'.tr(),
                  onActionTap: () => context.goNamed('studentList'), // Utiliser le nom de la route
                  child: users.isEmpty
                      ? Center(child: Text('dashboard_admin_users_empty'.tr()))
                      : AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: Column(
                            key: ValueKey(users.length),
                            children: users
                                .take(5)
                                .map((u) => _UserTile(user: u))
                                .toList(),
                          ),
                        ),
                ),
                const SizedBox(height: 18),

                // Classes management
                DashboardCard(
                  title: 'dashboard_admin_classes'.tr(),
                  icon: Icons.class_,
                  actionText: 'dashboard_admin_classes_manage'.tr(),
                  onActionTap: () => context.goNamed('classList'), // Utiliser le nom de la route
                  child: classes.isEmpty
                      ? Center(
                          child: Text('dashboard_admin_classes_empty'.tr()))
                      : AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: SizedBox(
                            key: ValueKey(classes.length),
                            height: 100,
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

                // Announcements management
                DashboardCard(
                  title: 'dashboard_admin_announcements'.tr(),
                  icon: Icons.campaign,
                  actionText: 'dashboard_admin_announcements_all'.tr(),
                  onActionTap: () => context.goNamed('announcements'), // Utiliser le nom de la route
                  child: announcements.isEmpty
                      ? Center(
                          child:
                              Text('dashboard_admin_announcements_empty'.tr()))
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

                // Quick actions
                QuickActions(
                  onFilesTap: () => context.goNamed('virtualLibrary'), // Utiliser le nom de la route
                  onAiAssistantTap: () => context.goNamed('aiAssistant'), // Utiliser le nom de la route
                  onPaymentsTap: () => context.goNamed('paymentList'), // Utiliser le nom de la route
                  onAttendanceTap: () => context.goNamed('attendanceRecords'), // Utiliser le nom de la route
                  onScheduleTap: () => context.goNamed('schedule', // Utiliser le nom de la route
                      extra: 'some_default_class_id'), // Assurez-vous que la route 'schedule' existe et accepte 'extra'
                  onChatTap: () => context.goNamed('directMessages'), // Utiliser le nom de la route
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

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.08),
      elevation: 0,
      child: Container(
        width: 140,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
          // Route classDetail attend un String classId
          context.goNamed(AppRouteNames.classDetail, extra: classInfo.id);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: 140,
          padding: const EdgeInsets.all(12),
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
              const SizedBox(height: 6),
              Text(
                classInfo.level ?? '',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontFamily: 'Poppins'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
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

class _UserTile extends StatelessWidget {
  final UserModel user;
  const _UserTile({required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: (user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
            ? NetworkImage(user.avatarUrl!)
            : const AssetImage(
                    'assets/images/placeholders/user_placeholder.png')
                as ImageProvider,
      ),
      title: Text(user.fullName ?? user.email ?? ""),
      subtitle: Text(user.role ?? ''),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Route user_detail non définie. Naviguer vers liste étudiants/enseignants ou ajouter route détail utilisateur.
        debugPrint(
            'Navigation vers le détail utilisateur non implémentée car la route est manquante.');
        // Exemple si route userDetail existait et attendait un userId:
        // context.goNamed(AppRouteNames.userDetail, pathParameters: {'userId': user.id});
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
        // Route announcementDetail attend un AnnouncementModel
        context.goNamed(AppRouteNames.announcementDetail, extra: announcement);
      },
    );
  }
}
