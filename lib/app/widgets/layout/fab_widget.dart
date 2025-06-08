/// fab_widget.dart
/// Floating Action Button (FAB) personnalisable et réutilisable pour l’application.
/// Centralise le style, l’icône, le label et les comportements.
/// Utilisez ce widget pour garantir la cohérence UI des FAB dans l’app.
library;

import 'package:flutter/material.dart';

class FabWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String? label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool mini;
  final String? tooltip;
  final ShapeBorder? shape;

  const FabWidget({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 6.0,
    this.mini = false,
    this.tooltip,
    this.shape,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget child = Icon(icon);

    if (label == null) {
      return FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: elevation,
        mini: mini,
        tooltip: tooltip,
        shape: shape,
        child: child,
      );
    } else {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: elevation,
        icon: child,
        label: Text(label!),
        tooltip: tooltip,
        shape: shape,
        isExtended: true,
      );
    }
  }
}