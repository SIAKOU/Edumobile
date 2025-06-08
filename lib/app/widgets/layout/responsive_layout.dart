/// responsive_layout.dart
/// Widget utilitaire pour adapter automatiquement l'UI entre mobile, tablette et web/desktop.
/// Permet de définir différents widgets selon la largeur de l'écran.
/// À utiliser pour garantir une expérience utilisateur optimale sur toutes les plateformes.
library;

import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;
  final double tabletBreakpoint;
  final double desktopBreakpoint;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
    this.tabletBreakpoint = 700.0,
    this.desktopBreakpoint = 1100.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    if (width >= desktopBreakpoint) {
      return desktop;
    } else if (tablet != null && width >= tabletBreakpoint) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}