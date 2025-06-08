// app_sizes.dart
// Définition centralisée des tailles, espacements, rayons, élévations, etc.
// Utilisez ces constantes partout dans l’app pour cohérence et adaptabilité.

class AppSizes {
  // --- ESPACEMENTS ---
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // --- RAYONS DES BORDS ---
  static const double borderRadiusXs = 4.0;
  static const double borderRadiusSm = 8.0;
  static const double borderRadiusMd = 12.0;
  static const double borderRadiusLg = 16.0;
  static const double borderRadiusCircle = 50.0;

  // --- ÉPAISSEURS ---
  static const double divider = 1.0;
  static const double buttonHeight = 48.0;
  static const double inputHeight = 52.0;
  static const double iconSize = 24.0;
  static const double avatarRadius = 32.0;

  // --- ÉLÉVATION / SHADOW ---
  static const double elevationLow = 2.0;
  static const double elevationMed = 6.0;
  static const double elevationHigh = 12.0;

  // --- AUTRES ---
  static const double appBarHeight = 56.0;
  static const double bottomNavBarHeight = 64.0;
  static const double fabSize = 56.0;
  static const double cardPadding = md;

  // Responsive breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1440.0;
}