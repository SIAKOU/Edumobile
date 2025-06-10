// ignore_for_file: non_constant_identifier_names, strict_top_level_inference

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/models/announcement_model.dart';
import 'package:gestion_ecole/core/models/grade_model.dart';
import 'package:gestion_ecole/core/models/subject_model.dart';
import 'package:gestion_ecole/core/models/user_model.dart';
import 'package:gestion_ecole/core/providers/admin_dashboard_provider.dart';
import 'package:gestion_ecole/core/providers/assignment_list_provider.dart';
import 'package:gestion_ecole/core/providers/student_dashboard_provider.dart';
import 'package:gestion_ecole/core/providers/teacher_dashboard_provider.dart';
import 'package:gestion_ecole/core/repositories/assignment_repository.dart';
import 'package:gestion_ecole/core/repositories/class_repository.dart';
import 'package:gestion_ecole/core/repositories/grade_repository.dart';
import 'package:gestion_ecole/core/repositories/schedule_Repository.dart';
import 'package:gestion_ecole/core/repositories/user_repository.dart';
import 'package:gestion_ecole/core/repositories/announcement_repository.dart';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/storage_service.dart';
import 'package:gestion_ecole/features/messaging/screens/Assignment_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

// --- Auth screens ---
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/reset_password_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';

// --- Dashboard screens ---
import '../../features/dashboard/screens/student_dashboard_screen.dart';
import '../../features/dashboard/screens/teacher_dashboard_screen.dart';
import '../../features/dashboard/screens/admin_dashboard_screen.dart';

// --- Class management ---
import '../../features/class_management/screens/class_list_screen.dart';
import '../../features/class_management/screens/class_detail_screen.dart';
import '../../features/class_management/screens/class_form_screen.dart';
import '../../features/class_management/screens/student_list_screen.dart';
import '../../features/class_management/screens/teacher_list_screen.dart';

// --- Grades ---
import '../../features/grades/screens/student_grades_screen.dart';
import '../../features/grades/screens/grade_detail_screen.dart';
import '../../features/grades/screens/enter_grades_screen.dart';
import '../../features/grades/screens/grade_statistics_screen.dart';

// --- Schedule ---
import '../../features/schedule/screens/schedule_screen.dart';
import '../../features/schedule/screens/schedule_day_view.dart'
    hide ScheduleScreen;
import '../../features/schedule/screens/schedule_week_view.dart';
import '../../features/schedule/screens/schedule_month_view.dart';

// --- Announcements ---
import '../../features/announcements/screens/announcements_screen.dart';
import '../../features/announcements/screens/announcement_detail_screen.dart';
import '../../features/announcements/screens/create_announcement_screen.dart';

// --- Messaging ---
import '../../features/messaging/screens/direct_message_list_screen.dart';
import '../../features/messaging/screens/class_group_list_screen.dart';
import '../../features/messaging/screens/chat_screen.dart';
import '../../features/messaging/screens/new_message_screen.dart';
import '../../features/messaging/screens/create_group_screen.dart';
import '../../features/messaging/screens/group_info_screen.dart';

// --- Attendance ---
import '../../features/attendance/screens/scan_qr_screen.dart';
import '../../features/attendance/screens/display_qr_screen.dart';
import '../../features/attendance/screens/attendance_records_screen.dart';
import '../../features/attendance/screens/attendance_report_screen.dart';
import '../../features/attendance/screens/attendance_stats_screen.dart';

// --- Payments ---
import '../../features/payments/screens/payment_list_screen.dart';
import '../../features/payments/screens/payment_detail_screen.dart';
import '../../features/payments/screens/payment_process_screen.dart';
import '../../features/payments/screens/payment_history_screen.dart';
import '../../features/payments/screens/payment_receipt_screen.dart';

// --- Library ---
import '../../features/library/screens/virtual_library_screen.dart';
import '../../features/library/screens/library_category_screen.dart';
import '../../features/library/screens/document_viewer_screen.dart';
import '../../features/library/screens/upload_document_screen.dart';
import '../../features/library/screens/search_documents_screen.dart';

// --- AI Assistant ---
import '../../features/ai_assistant/screens/ai_assistant_screen.dart';
import '../../features/ai_assistant/screens/ai_chat_screen.dart';
import '../../features/ai_assistant/screens/ai_resources_screen.dart';

final di = GetIt.instance;

class AppRouteNames {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  static const String studentDashboard = '/student-dashboard';
  static const String teacherDashboard = '/teacher-dashboard';
  static const String adminDashboard = '/admin-dashboard';

  // Class management
  static const String classList = '/classes';
  static const String classDetail = '/class-detail';
  static const String classForm = '/class-form';
  static const String studentList = '/students';
  static const String teacherList = '/teachers';

  // Grades
  static const String studentGrades = '/student-grades';
  static const String gradeDetail = '/grade-detail';
  static const String enterGrades = '/enter-grades';
  static const String gradeStatistics = '/grade-statistics';

  // Schedule
  static const String schedule = '/schedule';
  static const String scheduleDay = '/schedule-day';
  static const String scheduleWeek = '/schedule-week';
  static const String scheduleMonth = '/schedule-month';

  // Announcements
  static const String announcements = '/announcements';
  static const String announcementDetail = '/announcement-detail';
  static const String createAnnouncement = '/create-announcement';

  // Messaging
  static const String directMessages = '/messages';
  static const String classGroups = '/class-groups';
  static const String chat = '/chat';
  static const String newMessage = '/new-message';
  static const String createGroup = '/create-group';
  static const String groupInfo = '/group-info';

  // Attendance
  static const String scanQR = '/scan-qr';
  static const String displayQR = '/display-qr';
  static const String attendanceRecords = '/attendance-records';
  static const String attendanceReport = '/attendance-report';
  static const String attendanceStats = '/attendance-stats';

  // Payments
  static const String paymentList = '/payments';
  static const String paymentDetail = '/payment-detail';
  static const String paymentProcess = '/payment-process';
  static const String paymentHistory = '/payment-history';
  static const String paymentReceipt = '/payment-receipt';

  // Library
  static const String virtualLibrary = '/library';
  static const String libraryCategory = '/library-category';
  static const String documentViewer = '/document-viewer';
  static const String uploadDocument = '/upload-document';
  static const String searchDocuments = '/search-documents';

  // AI Assistant
  static const String aiAssistant = '/ai-assistant';
  static const String aiChat = '/ai-chat';
  static const String aiResources = '/ai-resources';

  // Assignments
  static String assignmentDetail = '/assignment-detail';
  static String assignmentList = '/assignment-list';
  static String assignmentCreate = '/assignment-create';
  static String assignmentEdit = '/assignment-edit';
}

class AppRouter {
  static GoRouter createGoRouter() {
    return GoRouter(
      initialLocation: AppRouteNames.onboarding,
      debugLogDiagnostics: true,
      routes: [
        // --- Auth & onboarding ---
        GoRoute(
          path: AppRouteNames.onboarding,
          name: 'onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: AppRouteNames.login,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        // Dans votre configuration de route :
        GoRoute(
          path: '/signup',
          builder: (context, state) => SignupScreen(),
        ),

        GoRoute(
          path: AppRouteNames.forgotPassword,
          name: 'forgotPassword',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: AppRouteNames.resetPassword,
          name: 'resetPassword',
          builder: (context, state) => const ResetPasswordScreen(),
        ),

        // --- Dashboards ---
        GoRoute(
          path: AppRouteNames.studentDashboard,
          name: 'studentDashboard',
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => StudentDashboardProvider(
              // Utiliser di<T>() pour obtenir les repositories
              userRepository: di<UserRepository>(),
              gradeRepository: di<GradeRepository>(),
              announcementRepository: di<AnnouncementRepository>(),
              classRepository: di<ClassRepository>(),
              scheduleRepository: di<ScheduleRepository>(),
            ),
            child: const StudentDashboardScreen(),
          ),
        ),

        GoRoute(
          path: AppRouteNames.teacherDashboard,
          name: 'teacherDashboard',
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => TeacherDashboardProvider(
              // Cette configuration était déjà correcte
              userRepository: di<UserRepository>(),
              classRepository: di<ClassRepository>(),
              announcementRepository: di<AnnouncementRepository>(),
              gradeRepository: di<GradeRepository>(),
              // Assurez-vous que AssignmentRepository est aussi injecté ici si nécessaire
              assignmentRepository: di<AssignmentRepository>(),
            ),
            child: const TeacherDashboardScreen(),
          ),
        ),

        GoRoute(
          path: AppRouteNames.adminDashboard,
          name: 'adminDashboard',
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => AdminDashboardProvider(
              // Utiliser di<T>() pour obtenir les repositories
              userRepository: di<UserRepository>(),
              classRepository: di<ClassRepository>(),
              announcementRepository: di<AnnouncementRepository>(),
              // Assurez-vous que d'autres repositories nécessaires sont aussi injectés ici
              // gradeRepository: di<GradeRepository>(),
            ),
            child: const AdminDashboardScreen(),
          ),
        ),

        // --- Class management ---
        GoRoute(
          path: AppRouteNames.classList,
          name: 'classList',
          builder: (context, state) => const ClassListScreen(),
        ),
        GoRoute(
          path: AppRouteNames.classDetail,
          name: 'classDetail',
          builder: (context, state) {
            final classId = state.extra is String ? state.extra as String : '';
            return ClassDetailScreen(classId: classId);
          },
        ),
        GoRoute(
          path: AppRouteNames.classForm,
          name: 'classForm',
          builder: (context, state) => const ClassFormScreen(),
        ),
        GoRoute(
          path: AppRouteNames.studentList,
          name: 'studentList',
          builder: (context, state) => const StudentListScreen(),
        ),
        GoRoute(
          path: AppRouteNames.teacherList,
          name: 'teacherList',
          builder: (context, state) => const TeacherListScreen(),
        ),

        // --- Grades ---
        GoRoute(
          path: AppRouteNames.studentGrades,
          name: 'studentGrades',
          builder: (context, state) {
            final extra = state.extra as Map<String, String>? ?? {};
            return StudentGradesScreen(
              studentId: extra['studentId'] ?? '',
              classId: extra['classId'] ?? '',
            );
          },
        ),
        GoRoute(
          path: AppRouteNames.gradeDetail,
          name: 'gradeDetail',
          builder: (context, state) {
            final grade = state.extra is GradeModel
                ? state.extra as GradeModel
                : GradeModel(
                    id: '',
                    value: 0,
                    studentId: '',
                    subjectId: '',
                    classId: '',
                    period: '',
                    date: DateTime.now());
            return GradeDetailScreen(
              grade: grade,
              onEdit: () {},
              onDelete: () {},
            );
          },
        ),
        GoRoute(
          path: AppRouteNames.enterGrades,
          name: 'enterGrades',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return EnterGradesScreen(
              classId: extra['classId'] ?? '',
              subject: extra['subject'] ?? SubjectModel(id: '', name: ''),
              period: extra['period'] ?? '',
              students: extra['students'] ?? <UserModel>[],
            );
          },
        ),
        GoRoute(
          path: AppRouteNames.gradeStatistics,
          name: 'gradeStatistics',
          builder: (context, state) {
            final classId = state.extra is String ? state.extra as String : '';
            return GradeStatisticsScreen(classId: classId);
          },
        ),

        // --- Schedule ---
        GoRoute(
          path: '/schedule',
          builder: (context, state) {
            return ScheduleScreen(
              classId:
                  state.extra as String, // ou passez les paramètres nécessaires
            );
          },
        ),
        GoRoute(
          path: AppRouteNames.scheduleWeek,
          name: 'scheduleWeek',
          builder: (context, state) => const ScheduleWeekView(),
        ),
        GoRoute(
          path: AppRouteNames.scheduleMonth,
          name: 'scheduleMonth',
          builder: (context, state) => const ScheduleMonthView(),
        ),

        // --- Announcements ---
        GoRoute(
          path: AppRouteNames.announcements,
          name: 'announcements',
          builder: (context, state) {
            final classId = state.extra is String ? state.extra as String : '';
            return AnnouncementsScreen(classId: classId);
          },
        ),
        GoRoute(
          path: AppRouteNames.announcementDetail,
          name: 'announcementDetail',
          builder: (context, state) {
            final announcement = state.extra is AnnouncementModel
                ? state.extra as AnnouncementModel
                : AnnouncementModel(
                    id: '',
                    title: '',
                    authorId: '',
                    content: '',
                    publishedAt: DateTime.now(),
                    createdAt: DateTime.now(),
                  );
            return AnnouncementDetailScreen(announcement: announcement);
          },
        ),
        GoRoute(
          path: AppRouteNames.createAnnouncement,
          name: 'createAnnouncement',
          builder: (context, state) => const CreateAnnouncementScreen(),
        ),

        // --- Messaging ---
        GoRoute(
          path: AppRouteNames.directMessages,
          name: 'directMessages',
          builder: (context, state) => const DirectMessageListScreen(),
        ),
        GoRoute(
          path: AppRouteNames.classGroups,
          name: 'classGroups',
          builder: (context, state) => const ClassGroupListScreen(),
        ),
        GoRoute(
          path: AppRouteNames.chat,
          name: 'chat',
          builder: (context, state) {
            final extra = state.extra as Map<String, String>? ?? {};
            return ChatScreen(
              title: extra['title'] ?? '',
              threadId: extra['threadId'] ?? '',
              recipientId: extra['recipientId'] ?? '',
            );
          },
        ),
        GoRoute(
          path: AppRouteNames.newMessage,
          name: 'newMessage',
          builder: (context, state) => const NewMessageScreen(),
        ),
        GoRoute(
          path: AppRouteNames.createGroup,
          name: 'createGroup',
          builder: (context, state) => const CreateGroupScreen(),
        ),
        GoRoute(
          path: AppRouteNames.groupInfo,
          name: 'groupInfo',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return GroupInfoScreen(
              groupName: extra['groupName'] ?? '',
              members: extra['members'] ?? [],
              isAdmin: extra['isAdmin'] ?? false,
            );
          },
        ),

        // --- Attendance ---
        GoRoute(
          path: AppRouteNames.scanQR,
          name: 'scanQR',
          builder: (context, state) => const ScanQrScreen(),
        ),
        GoRoute(
          path: AppRouteNames.displayQR,
          name: 'displayQR',
          builder: (context, state) => const DisplayQrScreen(),
        ),
        GoRoute(
          path: AppRouteNames.attendanceRecords,
          name: 'attendanceRecords',
          builder: (context, state) => const AttendanceRecordsScreen(),
        ),
        GoRoute(
          path: AppRouteNames.attendanceReport,
          name: 'attendanceReport',
          builder: (context, state) => const AttendanceReportScreen(),
        ),
        GoRoute(
          path: AppRouteNames.attendanceStats,
          name: 'attendanceStats',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return AttendanceStatsScreen(
              studentName: extra['studentName'],
              attendanceRecords: extra['attendanceRecords'],
            );
          },
        ),

        //--- Assignments ---
        GoRoute(
          path: '/assignments', // Ou un autre chemin approprié
          name: 'assignmentList',
          builder: (context, state) {
//     // Récupérer les paramètres de filtrage si passés via extra ou queryParameters
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return ChangeNotifierProvider(
              create: (_) => AssignmentListProvider(
                assignmentRepository:
                    di<AssignmentRepository>(), // Injecter le repository
              ),
              child: AssignmentListScreen(
                classId: extra['classId'] as String?,
                teacherId: extra['teacherId'] as String?,
                studentId: extra['studentId'] as String?,
                toReview: extra['toReview'] as bool?,
              ),
            );
          },
        ),

        // --- Payments ---
        GoRoute(
          path: AppRouteNames.paymentList,
          name: 'paymentList',
          builder: (context, state) => PaymentListScreen(),
        ),
        GoRoute(
          path: AppRouteNames.paymentDetail,
          name: 'paymentDetail',
          builder: (context, state) {
            final payment = state.extra as Map<String, dynamic>? ?? {};
            return PaymentDetailScreen(payment: payment);
          },
        ),
        GoRoute(
          path: AppRouteNames.paymentProcess,
          name: 'paymentProcess',
          builder: (context, state) {
            final payment = state.extra as Map<String, dynamic>? ?? {};
            return PaymentProcessScreen(payment: payment);
          },
        ),
        GoRoute(
          path: AppRouteNames.paymentHistory,
          name: 'paymentHistory',
          builder: (context, state) => PaymentHistoryScreen(),
        ),
        GoRoute(
          path: AppRouteNames.paymentReceipt,
          name: 'paymentReceipt',
          builder: (context, state) {
            final payment = state.extra as Map<String, dynamic>? ?? {};
            return PaymentReceiptScreen(payment: payment);
          },
        ),

        // --- Library ---
        GoRoute(
          path: AppRouteNames.virtualLibrary,
          name: 'virtualLibrary',
          builder: (context, state) => const VirtualLibraryScreen(),
        ),
        GoRoute(
          path: AppRouteNames.libraryCategory,
          name: 'libraryCategory',
          builder: (context, state) {
            final category = state.extra is String ? state.extra as String : '';
            return LibraryCategoryScreen(category: category);
          },
        ),
        GoRoute(
          path: AppRouteNames.documentViewer,
          name: 'documentViewer',
          builder: (context, state) {
            final document = state.extra as Map<String, dynamic>? ?? {};
            return DocumentViewerScreen(document: document);
          },
        ),
        GoRoute(
          path: AppRouteNames.uploadDocument,
          name: 'uploadDocument',
          builder: (context, state) => const UploadDocumentScreen(),
        ),
        GoRoute(
          path: AppRouteNames.searchDocuments,
          name: 'searchDocuments',
          builder: (context, state) => const SearchDocumentsScreen(),
        ),

        // --- AI Assistant ---
        GoRoute(
          path: AppRouteNames.aiAssistant,
          name: 'aiAssistant',
          builder: (context, state) => const AiAssistantScreen(),
        ),
        GoRoute(
          path: AppRouteNames.aiChat,
          name: 'aiChat',
          builder: (context, state) => const AiChatScreen(),
        ),
        GoRoute(
          path: AppRouteNames.aiResources,
          name: 'aiResources',
          builder: (context, state) => const AiResourcesScreen(),
        ),
      ],
      errorBuilder: (context, state) => const _NotFoundScreen(),
    );
  }
}

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          'Page non trouvée',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
