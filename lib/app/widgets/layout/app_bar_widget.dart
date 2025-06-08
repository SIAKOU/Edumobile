/// app_bar_widget.dart
/// AppBar personnalisable et réutilisable pour l’application.
/// Permet d’afficher un titre, des actions, un bouton de retour, etc.
/// Utilisez ce widget pour garantir une cohérence UI des barres d’application.
library;

import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBack;
  final Color? backgroundColor;
  final double elevation;
  final double height;
  final bool centerTitle;

  const AppBarWidget({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = false,
    this.onBack,
    this.backgroundColor,
    this.elevation = 1.0,
    this.height = kToolbarHeight,
    this.centerTitle = false,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final Widget? effectiveLeading =
        leading ??
        (showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              )
            : null);

    return AppBar(
      backgroundColor: backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
      elevation: elevation,
      leading: effectiveLeading,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      actions: actions,
      centerTitle: centerTitle,
      toolbarHeight: height,
    );
  }
}