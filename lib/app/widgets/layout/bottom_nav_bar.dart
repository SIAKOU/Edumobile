/// bottom_nav_bar.dart
/// Barre de navigation inférieure personnalisée pour l'application.
/// Permet une gestion centralisée du style et des actions de navigation principales.
/// Utilisez ce widget comme [bottomNavigationBar] de votre [Scaffold].

// ignore_for_file: dangling_library_doc_comments

import 'package:flutter/material.dart';

class BottomNavBarItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final String? tooltip;

  BottomNavBarItem({
    required this.icon,
    required this.label,
    this.onTap,
    this.tooltip,
  });
}

class BottomNavBar extends StatelessWidget {
  final List<BottomNavBarItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double elevation;
  final double iconSize;
  final bool showLabels;

  const BottomNavBar({
    Key? key,
    required this.items,
    required this.currentIndex,
    this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 8.0,
    this.iconSize = 24.0,
    this.showLabels = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BottomNavigationBar(
      items: items
          .map(
            (item) => BottomNavigationBarItem(
              icon: Icon(item.icon, size: iconSize),
              label: showLabels ? item.label : '',
              tooltip: item.tooltip,
            ),
          )
          .toList(),
      currentIndex: currentIndex,
      onTap: (index) {
        items[index].onTap?.call();
        onTap?.call(index);
      },
      backgroundColor: backgroundColor ?? theme.bottomAppBarColor,
      selectedItemColor: selectedItemColor ?? theme.colorScheme.primary,
      unselectedItemColor: unselectedItemColor ?? theme.unselectedWidgetColor,
      elevation: elevation,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: showLabels,
      showUnselectedLabels: showLabels,
    );
  }
}

extension ThemeDataBottomAppBarColor on ThemeData {
  /// Retourne la couleur du BottomAppBar selon le thème courant.
  Color get bottomAppBarColor => bottomAppBarTheme.color ?? colorScheme.surface;
}