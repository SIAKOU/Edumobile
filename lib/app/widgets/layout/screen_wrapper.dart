/// screen_wrapper.dart
/// Widget utilitaire pour fournir une structure de base cohérente à chaque écran de l'application.
/// Peut inclure : SafeArea, gestion du scroll, padding, background, etc.
/// Permet de centraliser les paramètres par défaut pour chaque page.
library;

import 'package:flutter/material.dart';

class ScreenWrapper extends StatelessWidget {
  final Widget child;
  final bool safeArea;
  final bool scrollable;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  const ScreenWrapper({
    Key? key,
    required this.child,
    this.safeArea = true,
    this.scrollable = false,
    this.padding = const EdgeInsets.all(20.0),
    this.backgroundColor,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton, required String title, required bool showDrawer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: padding,
      child: child,
    );

    if (scrollable) {
      content = SingleChildScrollView(child: content);
    }

    if (safeArea) {
      content = SafeArea(child: content);
    }

    return Scaffold(
      backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      appBar: appBar,
      body: content,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}