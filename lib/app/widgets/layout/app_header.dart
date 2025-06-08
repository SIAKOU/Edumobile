/// app_header.dart
/// Widget d’en-tête (header) personnalisable et réutilisable pour l’application.
/// Permet d’afficher un titre, un sous-titre, des actions, un bouton de retour, etc.
/// Utilisez ce widget pour garantir une cohérence UI des barres d’en-tête.
library;

import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBack;
  final Color? backgroundColor;
  final double elevation;
  final double height;

  const AppHeader({
    Key? key,
    required this.title,
    this.subtitle,
    this.actions,
    this.leading,
    this.showBackButton = false,
    this.onBack,
    this.backgroundColor,
    this.elevation = 1.0,
    this.height = kToolbarHeight,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height + (subtitle != null ? 24 : 0));

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
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.white70,
                ),
              ),
            ),
        ],
      ),
      actions: actions,
      centerTitle: false,
      toolbarHeight: height + (subtitle != null ? 18 : 0),
    );
  }
}