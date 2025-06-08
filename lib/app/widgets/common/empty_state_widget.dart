/// empty_state_widget.dart
/// Widget réutilisable pour afficher un état vide (aucune donnée à afficher).
/// Permet d'afficher une illustration, un message et éventuellement une action.
/// Utilisez ce widget pour garantir une présentation cohérente des écrans vides.
library;

import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? details;
  final IconData icon;
  final double iconSize;
  final Color? iconColor;
  final Widget? illustration;
  final VoidCallback? onAction;
  final String actionLabel;
  final EdgeInsetsGeometry padding;

  const EmptyStateWidget({
    Key? key,
    required this.message,
    this.details,
    this.icon = Icons.inbox_outlined,
    this.iconSize = 56,
    this.iconColor,
    this.illustration,
    this.onAction,
    this.actionLabel = "Actualiser",
    this.padding = const EdgeInsets.all(32),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final resolvedIconColor = iconColor ?? Theme.of(context).primaryColor;

    return Padding(
      padding: padding,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            illustration ??
                Icon(
                  icon,
                  color: resolvedIconColor,
                  size: iconSize,
                ),
            SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            if (details != null && details!.isNotEmpty) ...[
              SizedBox(height: 8),
              Text(
                details!,
                style: TextStyle(fontSize: 15, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
            if (onAction != null) ...[
              SizedBox(height: 22),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel),
              )
            ]
          ],
        ),
      ),
    );
  }
}