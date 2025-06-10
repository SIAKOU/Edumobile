// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

// Repositories & Services
import 'package:gestion_ecole/core/repositories/schedule_Repository.dart';
import 'core/services/biometric_service.dart';
import 'package:gestion_ecole/core/providers/locale_provider.dart';
import 'package:gestion_ecole/core/providers/theme_provider.dart';
import 'package:gestion_ecole/core/repositories/announcement_repository.dart';
import 'package:gestion_ecole/core/repositories/attendance_repository.dart';
import 'package:gestion_ecole/core/repositories/auth_repository.dart';
import 'package:gestion_ecole/core/repositories/chat_repository.dart';
import 'package:gestion_ecole/core/repositories/class_repository.dart';
import 'package:gestion_ecole/core/repositories/grade_repository.dart';
import 'package:gestion_ecole/core/repositories/library_repository.dart';
import 'package:gestion_ecole/core/repositories/payment_repository.dart';
import 'package:gestion_ecole/core/repositories/user_repository.dart';
import 'package:gestion_ecole/core/repositories/assignment_repository.dart';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/storage_service.dart';
import 'package:gestion_ecole/core/services/user_service.dart';

// Providers
import 'package:gestion_ecole/core/providers/student_dashboard_provider.dart';
import 'package:gestion_ecole/core/providers/teacher_dashboard_provider.dart';
import 'package:gestion_ecole/core/providers/admin_dashboard_provider.dart';
import 'package:gestion_ecole/core/providers/assignment_list_provider.dart';

import 'package:provider/provider.dart';

// Supabase
import 'package:supabase_flutter/supabase_flutter.dart';

// Navigation
import 'package:go_router/go_router.dart';

// State management & DI
import 'package:get_it/get_it.dart';

// Local storage
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

// Thèmes, routes, config
import 'app/config/app_theme.dart';
import 'app/config/app_routes.dart';
import 'app/config/app_constants.dart';

final GetIt di = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Easy Localization
  await EasyLocalization.ensureInitialized();

  // Init Hive (si non web)
  if (!kIsWeb) {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  // Init SharedPreferences
  final sharedPrefs = await SharedPreferences.getInstance();
  di.registerSingleton<SharedPreferences>(sharedPrefs);

  // Init StorageService (singleton)
  await StorageService.initialize(sharedPrefs);

  // Init Supabase
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  // Init ApiClient
  final apiClient = ApiClient(
    baseUrl: '${AppConstants.supabaseUrl}/rest/v1/',
  );
  di.registerSingleton<ApiClient>(apiClient);

  // Setup all dependencies (repositories, providers, services)
  await setupDependencies();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('fr'), Locale('en')],
      path: 'assets/l10n',
      fallbackLocale: const Locale('fr'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (_) => di<StudentDashboardProvider>()),
          ChangeNotifierProvider(create: (_) => di<TeacherDashboardProvider>()),
          ChangeNotifierProvider(create: (_) => di<AdminDashboardProvider>()),
          ChangeNotifierProvider(create: (_) => di<AssignmentListProvider>()),
          // Ajoute ici d'autres providers si besoin
        ],
        child: const EduMobileApp(),
      ),
    ),
  );
}

class EduMobileApp extends StatefulWidget {
  const EduMobileApp({super.key});

  @override
  State<EduMobileApp> createState() => _EduMobileAppState();
}

class _EduMobileAppState extends State<EduMobileApp> {
  late GoRouter _goRouter;

  @override
  void initState() {
    super.initState();
    _goRouter = AppRouter.createGoRouter();
    _setupAuthListener();
  }

  Future<void> _fetchAndRedirectUser(User authUser) async {
    // Récupérer le rôle depuis la table publique 'users'
    try {
      final response = await Supabase.instance.client
          .from('users') // Assurez-vous que 'users' est le nom correct de votre table de profils
          .select('role')
          .eq('id', authUser.id)
          .maybeSingle();

      final String? userRoleFromTable = response?['role'];
      final String? userRoleFromMetadata = authUser.userMetadata?['role'];
      final String effectiveRole = userRoleFromTable ?? userRoleFromMetadata ?? 'student'; // Fallback

      debugPrint('Auth Listener: User ID: ${authUser.id}, Role from DB: $userRoleFromTable, Role from Metadata: $userRoleFromMetadata, Effective Role: $effectiveRole');

      if (effectiveRole == 'student') {
        _goRouter.goNamed('studentDashboard');
      } else if (effectiveRole == 'teacher') {
        _goRouter.goNamed('teacherDashboard');
      } else if (effectiveRole == 'admin') {
        _goRouter.goNamed('adminDashboard');
      } else {
        debugPrint('Rôle utilisateur inconnu après fetch: $effectiveRole');
        _goRouter.goNamed('login');
      }
    } catch (e) {
      debugPrint('Erreur lors de la récupération du rôle utilisateur depuis la table users: $e');
      _goRouter.goNamed('login'); // En cas d'erreur, rediriger vers login
    }
  }

  void _setupAuthListener() {
    final supabase = Supabase.instance.client;
    supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (session != null) {
          _fetchAndRedirectUser(session.user);
        } else {
          _goRouter.goNamed('onboarding'); // Utiliser le nom de la route
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return MaterialApp.router(
      title: 'Gestion École',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      routerConfig: _goRouter,
      locale: localeProvider.locale,
      localizationsDelegates: [
        ...context.localizationDelegates,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: context.supportedLocales,
    );
  }
}

Future<void> setupDependencies() async {
  // Enregistrez les services qui dépendent des singletons déjà enregistrés (SharedPreferences, ApiClient, StorageService)

  // BiometricService (en supposant qu'il n'a pas de dépendances DI)
  di.registerLazySingleton<BiometricService>(() => BiometricService());

  // UserService (en supposant qu'il dépend d'ApiClient et potentiellement StorageService)
  di.registerLazySingleton<UserService>(
    () => UserService(
      apiClient: di<ApiClient>(),
      // Vérifiez le constructeur de UserService s'il a besoin de StorageService
      //storageService: di<StorageService>(),
    ),
  );

  // Enregistrez les Repositories
  // Ils dépendent d'ApiClient et StorageService, qui sont enregistrés dans main AVANT cet appel.

  di.registerLazySingleton<UserRepository>(
    () => UserRepository(
      apiClient: di<ApiClient>(),
      storageService: di<StorageService>(),
    ),
  );

  di.registerLazySingleton<GradeRepository>(
    () => GradeRepository(
      apiClient: di<ApiClient>(),
      storageService: di<StorageService>(),
    ),
  );

  di.registerLazySingleton<AnnouncementRepository>(
    () => AnnouncementRepository(
      apiClient: di<ApiClient>(),
      storageService: di<StorageService>(),
    ),
  );

  di.registerLazySingleton<ClassRepository>(
    () => ClassRepository(
      apiClient: di<ApiClient>(),
      storageService: di<StorageService>(),
    ),
  );

  di.registerLazySingleton<PaymentRepository>(
    () => PaymentRepository(
      apiClient: di<ApiClient>(),
      storageService: di<StorageService>(),
    ),
  );

  di.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepository(
      apiClient: di<ApiClient>(),
      storageService: di<StorageService>(),
    ),
  );

  di.registerLazySingleton<ChatRepository>(
    () => ChatRepository(
      apiClient: di<ApiClient>(),
      storageService: di<StorageService>(),
    ),
  );

  di.registerLazySingleton<LibraryRepository>(
    () => LibraryRepository(
      apiClient: di<ApiClient>(),
      storageService: di<StorageService>(),
    ),
  );

  di.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      apiClient: di<ApiClient>(),
      storageService: di<StorageService>(),
      biometricService:
          di<BiometricService>(), // BiometricService doit être enregistré
    ),
  );

  di.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepository(
      apiClient: di<ApiClient>(),
      storageService: di<StorageService>(),
    ),
  );

  // Enregistrez AssignmentRepository s'il existe et est utilisé
  di.registerLazySingleton<AssignmentRepository>(
    () => AssignmentRepository(
      apiClient: di<ApiClient>(),
      storageService: di<StorageService>(),
    ),
  );

  // Enregistrez les Providers (utilisez registerFactory car ils sont souvent liés au cycle de vie de l'UI)
  // Ils dépendent des repositories qui sont maintenant enregistrés.

  di.registerFactory<StudentDashboardProvider>(
    () => StudentDashboardProvider(
      userRepository: di<UserRepository>(),
      gradeRepository: di<GradeRepository>(),
      announcementRepository: di<AnnouncementRepository>(), 
      scheduleRepository: di<ScheduleRepository>(),
      // Vérifiez si StudentDashboardProvider a besoin d'autres repositories (ex: ClassRepository)
      classRepository: di<ClassRepository>(),
    ),
  );

  di.registerFactory<TeacherDashboardProvider>(
    () => TeacherDashboardProvider(
      userRepository: di<UserRepository>(),
      classRepository: di<ClassRepository>(),
      announcementRepository: di<AnnouncementRepository>(),
      gradeRepository: di<GradeRepository>(),
      assignmentRepository:
          di<AssignmentRepository>(), // Nécessite AssignmentRepository
    ),
  );

  di.registerFactory<AdminDashboardProvider>(
    () => AdminDashboardProvider(
      userRepository: di<UserRepository>(),
      classRepository: di<ClassRepository>(),
      announcementRepository: di<AnnouncementRepository>(),
      // Nécessite d'autres repositories ? Vérifiez le constructeur de AdminDashboardProvider
      // gradeRepository: di<GradeRepository>(),
      // paymentRepository: di<PaymentRepository>(),
      // attendanceRepository: di<AttendanceRepository>(),
    ),
  );

  // Enregistrez AssignmentListProvider s'il existe et est utilisé
  di.registerFactory<AssignmentListProvider>(
    () => AssignmentListProvider(
      assignmentRepository: di<AssignmentRepository>(),
    ),
  );

  // Ajoutez d'autres providers ici
}
