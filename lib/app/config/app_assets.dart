/// Centralise tous les chemins d'accès aux assets (images, icônes, fonts, mock data, etc.)
/// Utilisez toujours ces constantes pour éviter les "magic strings" et faciliter la maintenance.

// ignore_for_file: dangling_library_doc_comments

class AppAssets {
  // --- IMAGES LOGO & FOND ---
  static const String logo = 'assets/images/app_logo.png';
  static const String logoDark = 'assets/images/app_logo_dark.png';
  static const String splashBackground = 'assets/images/splash_bg.png';
  static const String appBackground = 'assets/images/app_bg.png';

  // --- ICONS ---
  static const String homeIcon = 'assets/images/icons/home_icon.png';
  static const String classesIcon = 'assets/images/icons/classes_icon.png';
  static const String gradesIcon = 'assets/images/icons/grades_icon.png';
  static const String scheduleIcon = 'assets/images/icons/schedule_icon.png';
  static const String announcementsIcon = 'assets/images/icons/announcements_icon.png';
  static const String paymentsIcon = 'assets/images/icons/payments_icon.png';
  static const String libraryIcon = 'assets/images/icons/library_icon.png';
  static const String attendanceIcon = 'assets/images/icons/attendance_icon.png';
  static const String chatIcon = 'assets/images/icons/chat_icon.png';
  static const String aiAssistantIcon = 'assets/images/icons/ai_icon.png';
  static const String settingsIcon = 'assets/images/icons/settings_icon.png';
  static const String logoutIcon = 'assets/images/icons/logout_icon.png';
  static const String profileIcon = 'assets/images/icons/profile_icon.png';
  static const String notificationIcon = 'assets/images/icons/notification_icon.png';
  static const String addIcon = 'assets/images/icons/add_icon.png';
  static const String editIcon = 'assets/images/icons/edit_icon.png';
  static const String deleteIcon = 'assets/images/icons/delete_icon.png';
  static const String downloadIcon = 'assets/images/icons/download_icon.png';
  static const String uploadIcon = 'assets/images/icons/upload_icon.png';
  static const String cameraIcon = 'assets/images/icons/camera_icon.png';
  static const String pdfIcon = 'assets/images/icons/pdf_icon.png';
  static const String docIcon = 'assets/images/icons/doc_icon.png';
  static const String videoIcon = 'assets/images/icons/video_icon.png';
  static const String audioIcon = 'assets/images/icons/audio_icon.png';
  static const String arrowBackIcon = 'assets/images/icons/arrow_back.png';
  static const String arrowForwardIcon = 'assets/images/icons/arrow_forward.png';
  static const String calendarIcon = 'assets/images/icons/calendar_icon.png';
  static const String searchIcon = 'assets/images/icons/search_icon.png';
  static const String filterIcon = 'assets/images/icons/filter_icon.png';
  static const String menuIcon = 'assets/images/icons/menu_icon.png';
  static const String moreIcon = 'assets/images/icons/more_icon.png';
  // Ajoutez d'autres icônes au besoin...

  // --- ILLUSTRATIONS ---
  static const String emptyState = 'assets/images/illustrations/empty_state.png';
  static const String noInternet = 'assets/images/illustrations/no_internet.png';
  static const String onboarding1 = 'assets/images/illustrations/onboarding_1.png';
  static const String onboarding2 = 'assets/images/illustrations/onboarding_2.png';
  static const String onboarding3 = 'assets/images/illustrations/onboarding_3.png';
  static const String welcomeIllustration = 'assets/images/illustrations/welcome.png';
  static const String aiIllustration = 'assets/images/illustrations/ai_assistant.png';
  static const String paymentIllustration = 'assets/images/illustrations/payment.png';
  static const String libraryIllustration = 'assets/images/illustrations/library.png';
  static const String attendanceIllustration = 'assets/images/illustrations/attendance.png';
  static const String chatIllustration = 'assets/images/illustrations/chat.png';
  // Ajoutez d'autres illustrations au besoin...

  // --- PLACEHOLDERS ---
  static const String userPlaceholder = 'assets/images/placeholders/user_placeholder.png';
  static const String classPlaceholder = 'assets/images/placeholders/class_placeholder.png';
  static const String documentPlaceholder = 'assets/images/placeholders/document_placeholder.png';
  static const String imagePlaceholder = 'assets/images/placeholders/image_placeholder.png';
  static const String teacherPlaceholder = 'assets/images/placeholders/teacher_placeholder.png';
  static const String studentPlaceholder = 'assets/images/placeholders/student_placeholder.png';

  // --- FONTS ---
  static const String robotoRegular = 'assets/fonts/roboto/Roboto-Regular.ttf';
  static const String robotoBold = 'assets/fonts/roboto/Roboto-Bold.ttf';
  static const String poppinsRegular = 'assets/fonts/poppins/Poppins-Regular.ttf';
  static const String poppinsBold = 'assets/fonts/poppins/Poppins-Bold.ttf';

  // --- MOCK DATA ---
  static const String mockUsers = 'assets/mock_data/users.json';
  static const String mockClasses = 'assets/mock_data/classes.json';
  static const String mockAnnouncements = 'assets/mock_data/announcements.json';
  static const String mockGrades = 'assets/mock_data/grades.json';
  static const String mockSchedule = 'assets/mock_data/schedule.json';
  static const String mockPayments = 'assets/mock_data/payments.json';
  static const String mockLibrary = 'assets/mock_data/library.json';
  static const String mockAttendance = 'assets/mock_data/attendance.json';
  static const String mockMessages = 'assets/mock_data/messages.json';

  // --- LOCALISATION ---
  static const String l10nEn = 'assets/l10n/app_en.arb';
  static const String l10nFr = 'assets/l10n/app_fr.arb';

  // --- DIVERS / AJOUTEZ VOS PROPRES CHEMINS SI BESOIN ---
}