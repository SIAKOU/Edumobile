// app_constants.dart
//
// Ce fichier centralise toutes les constantes globales, clés d'API, noms de routes, etc.
// Place ici uniquement des valeurs non sensibles (jamais de secrets ou clés privées en dur !)
// Pour les secrets, utilise un gestionnaire d'environnement (dotenv, etc.)

import 'package:flutter/material.dart';

// --- GLOBAL APP INFO ---
class AppConstants {
  static const String appName = 'Gestion École';
  static const String appVersion = '1.0.0+1';
  static const String companyName = 'YourCompany';
  static const String defaultLanguage = 'fr';

  // --- API & CLOUD KEYS (PUBLIC ONLY) ---
  // Pour Firebase, la config est dans firebase_options.dart (non ici)
  // Pour Supabase, NE MET JAMAIS la service key ici !
  static const String supabaseUrl = 'https://slupfyvmzrmhqxqvpwhy.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNsdXBmeXZtenJtaHF4cXZwd2h5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDgzNzY2NTcsImV4cCI6MjA2Mzk1MjY1N30.uZmdxVMTHhhD8BTsxCZCgPRwndf-yMhEHW6k7IoIHVY';

  // --- STORAGE BUCKETS ---
  static const String supabaseBucketDocuments = 'documents';
  static const String supabaseBucketAvatars = 'avatars';
  static const String firebaseStorageRoot = 'files';

  // --- ROUTE NAMES (centralisé pour éviter les hardcodes) ---
  static const String routeOnboarding = '/onboarding';
  static const String routeLogin = '/login';
  static const String routeSignup = '/signup';
  static const String routeForgotPassword = '/forgot-password';
  static const String routeResetPassword = '/reset-password';
  static const String routeStudentDashboard = '/student-dashboard';
  static const String routeTeacherDashboard = '/teacher-dashboard';
  static const String routeAdminDashboard = '/admin-dashboard';
  // Ajoute ici tes autres routes de façon centralisée

  // --- VALIDATION ---
  static const int passwordMinLength = 8;
  static const int usernameMinLength = 3;
  static const int maxFileSizeMb = 10;

  // --- DATES & FORMATS ---
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm';

  // --- DIVERS ---
  static const int apiTimeoutSeconds = 20;
  static const String defaultAvatarPath = 'assets/images/placeholders/user_placeholder.png';
  static const String defaultClassImagePath = 'assets/images/placeholders/class_placeholder.png';

  // --- THEME ---
  static const double borderRadius = 12.0;

  // --- LINKS & SUPPORT ---
  static const String privacyPolicyUrl = 'https://yourdomain.com/privacy';
  static const String termsOfServiceUrl = 'https://yourdomain.com/terms';
  static const String supportEmail = 'support@yourdomain.com';

  // Ajoute ici toutes les constantes globales dont tu pourrais avoir besoin...
}