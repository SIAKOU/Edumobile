/// drawer_widget.dart
/// Drawer (menu latéral) personnalisable pour la navigation dans l'application.
/// Centralise les entrées du menu, le style et les actions.
/// À utiliser comme [drawer] du [Scaffold].
library;

import 'package:flutter/material.dart';

class DrawerMenuItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  DrawerMenuItem({
    required this.icon,
    required this.label,
    this.onTap,
  });
}

class DrawerWidget extends StatelessWidget {
  final List<DrawerMenuItem> items;
  final Widget? header;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;

  const DrawerWidget({
    Key? key,
    required this.items,
    this.header,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          if (header != null) header!,
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: items.length,
              separatorBuilder: (context, index) => Divider(
                color: theme.dividerColor,
                height: 1,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: Icon(item.icon, color: iconColor ?? theme.iconTheme.color),
                  title: Text(
                    item.label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: textColor ?? theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  onTap: item.onTap,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}