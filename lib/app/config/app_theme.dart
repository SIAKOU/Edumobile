import 'package:flutter/material.dart';

/// Application Theme Configuration
/// Gère les thèmes light/dark, la typographie, les couleurs, l'accessibilité, l'adaptabilité et la sécurité.
class AppTheme {
  // --- Light Theme ---
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: _AppColors.primary,
    colorScheme: ColorScheme.light(
      primary: _AppColors.primary,
      secondary: _AppColors.secondary,
      background: _AppColors.background,
      error: _AppColors.error,
      surface: _AppColors.surface,
      onPrimary: _AppColors.onPrimary,
      onSecondary: _AppColors.onSecondary,
      onBackground: _AppColors.onBackground,
      onError: _AppColors.onError,
      onSurface: _AppColors.onSurface,
    ),
    scaffoldBackgroundColor: _AppColors.background,
    appBarTheme: const AppBarTheme(
      elevation: 1,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: _AppColors.onBackground,
      iconTheme: IconThemeData(color: _AppColors.primary),
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: _AppColors.onBackground,
      ),
    ),
    textTheme: _buildTextTheme(Brightness.light).apply(fontFamily: 'Poppins'),
    fontFamily: 'Poppins',
    buttonTheme: const ButtonThemeData(
      buttonColor: _AppColors.primary,
      textTheme: ButtonTextTheme.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: _AppColors.primary, width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: _AppColors.grey, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: _AppColors.primary, width: 2.0),
      ),
      labelStyle: const TextStyle(color: _AppColors.primary),
      floatingLabelStyle: const TextStyle(color: _AppColors.primary),
      filled: true,
      fillColor: _AppColors.inputFill,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: _AppColors.primary,
      contentTextStyle: TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      elevation: 6,
    ),
    cardTheme: CardThemeData(
      color: _AppColors.surface,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
    ),
    iconTheme: const IconThemeData(color: _AppColors.primary, size: 24),
    dividerTheme: const DividerThemeData(
      color: _AppColors.greyLight,
      thickness: 1.0,
      space: 1.0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _AppColors.primary,
      foregroundColor: Colors.white,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: ZoomPageTransitionsBuilder(),
        TargetPlatform.linux: ZoomPageTransitionsBuilder(),
      },
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      fillColor: WidgetStatePropertyAll(_AppColors.primary),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStatePropertyAll(_AppColors.primary),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(_AppColors.primary),
      trackColor: WidgetStatePropertyAll(_AppColors.primary.withOpacity(0.3)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _AppColors.surface,
      selectedItemColor: _AppColors.primary,
      unselectedItemColor: _AppColors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _AppColors.primary,
        foregroundColor: _AppColors.onPrimary,
        textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 2,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _AppColors.primary,
        textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16),
        side: const BorderSide(color: _AppColors.primary, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
  );

  // --- Dark Theme ---
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: _AppColors.primaryDark,
    colorScheme: ColorScheme.dark(
      primary: _AppColors.primaryDark,
      secondary: _AppColors.secondaryDark,
      background: _AppColors.backgroundDark,
      error: _AppColors.errorDark,
      surface: _AppColors.surfaceDark,
      onPrimary: _AppColors.onPrimaryDark,
      onSecondary: _AppColors.onSecondaryDark,
      onBackground: _AppColors.onBackgroundDark,
      onError: _AppColors.onErrorDark,
      onSurface: _AppColors.onSurfaceDark,
    ),
    scaffoldBackgroundColor: _AppColors.backgroundDark,
    appBarTheme: const AppBarTheme(
      elevation: 1,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: _AppColors.onBackgroundDark,
      iconTheme: IconThemeData(color: _AppColors.primaryDark),
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: _AppColors.onBackgroundDark,
      ),
    ),
    textTheme: _buildTextTheme(Brightness.dark).apply(fontFamily: 'Poppins'),
    fontFamily: 'Poppins',
    buttonTheme: const ButtonThemeData(
      buttonColor: _AppColors.primaryDark,
      textTheme: ButtonTextTheme.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: _AppColors.primaryDark, width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: _AppColors.greyDark, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: _AppColors.primaryDark, width: 2.0),
      ),
      labelStyle: const TextStyle(color: _AppColors.primaryDark),
      floatingLabelStyle: const TextStyle(color: _AppColors.primaryDark),
      filled: true,
      fillColor: _AppColors.inputFillDark,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: _AppColors.primaryDark,
      contentTextStyle: TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      elevation: 6,
    ),
    cardTheme: CardThemeData(
      color: _AppColors.surfaceDark,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
    ),
    iconTheme: const IconThemeData(color: _AppColors.primaryDark, size: 24),
    dividerTheme: const DividerThemeData(
      color: _AppColors.greyDark,
      thickness: 1.0,
      space: 1.0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _AppColors.primaryDark,
      foregroundColor: Colors.white,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: ZoomPageTransitionsBuilder(),
        TargetPlatform.linux: ZoomPageTransitionsBuilder(),
      },
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      fillColor: WidgetStatePropertyAll(_AppColors.primaryDark),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStatePropertyAll(_AppColors.primaryDark),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(_AppColors.primaryDark),
      trackColor: WidgetStatePropertyAll(_AppColors.primaryDark.withOpacity(0.3)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _AppColors.surfaceDark,
      selectedItemColor: _AppColors.primaryDark,
      unselectedItemColor: _AppColors.greyDark,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _AppColors.primaryDark,
        foregroundColor: _AppColors.onPrimaryDark,
        textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 2,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _AppColors.primaryDark,
        textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16),
        side: const BorderSide(color: _AppColors.primaryDark, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
  );

  static TextTheme _buildTextTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
        fontSize: 32,
        color: isDark ? _AppColors.onBackgroundDark : _AppColors.onBackground,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: 24,
        color: isDark ? _AppColors.onBackgroundDark : _AppColors.onBackground,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        fontSize: 20,
        color: isDark ? _AppColors.onBackgroundDark : _AppColors.onBackground,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: isDark ? _AppColors.onSurfaceDark : _AppColors.onSurface,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: isDark ? _AppColors.onSurfaceDark : _AppColors.onSurface,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        color: isDark ? _AppColors.onSurfaceDark : _AppColors.onSurface,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,
        color: isDark ? _AppColors.onSurfaceDark : _AppColors.onSurface,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w600,
        fontSize: 13,
        color: isDark ? _AppColors.primaryDark : _AppColors.primary,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: isDark ? _AppColors.onSurfaceDark : _AppColors.onSurface,
      ),
    );
  }
}

/// Palette de couleurs centralisée.
/// Pour la maintenance, toutes les couleurs globales sont définies ici.
/// Sécurité : évite les couleurs "magiques" dans le code.
class _AppColors {
  // Light
  static const Color primary = Color(0xFF0066CC);
  static const Color secondary = Color(0xFF00BFA5);
  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFD32F2F);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFF00332C);
  static const Color onBackground = Color(0xFF222B45);
  static const Color onSurface = Color(0xFF222B45);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color inputFill = Color(0xFFF1F3F6);

  static const Color grey = Color(0xFFBDBDBD);
  static const Color greyLight = Color(0xFFF0F0F0);

  // Dark
  static const Color primaryDark = Color(0xFF3399FF);
  static const Color secondaryDark = Color(0xFF44DDB6);
  static const Color backgroundDark = Color(0xFF181A20);
  static const Color surfaceDark = Color(0xFF23262B);
  static const Color errorDark = Color(0xFFFF5A5F);
  static const Color onPrimaryDark = Color(0xFF181A20);
  static const Color onSecondaryDark = Color(0xFF222B45);
  static const Color onBackgroundDark = Color(0xFFF6F6F7);
  static const Color onSurfaceDark = Color(0xFFF6F6F7);
  static const Color onErrorDark = Color(0xFF181A20);
  static const Color inputFillDark = Color(0xFF23262B);

  static const Color greyDark = Color(0xFF44474F);
}