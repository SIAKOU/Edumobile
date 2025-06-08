/// tab_bar_widget.dart
/// TabBar personnalisable et réutilisable pour l’application.
/// Permet d’afficher des onglets avec un style cohérent et éventuellement un TabBarView associé.
/// Utilisez ce widget pour garantir une cohérence UI des barres d’onglets.
library;

import 'package:flutter/material.dart';

class TabBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final List<Tab> tabs;
  final TabController? controller;
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final double indicatorWeight;
  final EdgeInsetsGeometry? labelPadding;
  final bool isScrollable;
  final Color? backgroundColor;
  final double height;

  const TabBarWidget({
    Key? key,
    required this.tabs,
    this.controller,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorWeight = 2.0,
    this.labelPadding,
    this.isScrollable = false,
    this.backgroundColor,
    this.height = 48.0,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: backgroundColor ?? theme.appBarTheme.backgroundColor ?? theme.primaryColor,
      child: TabBar(
        controller: controller,
        tabs: tabs,
        indicatorColor: indicatorColor ?? theme.colorScheme.secondary,
        labelColor: labelColor ?? theme.primaryColorDark,
        unselectedLabelColor: unselectedLabelColor ?? theme.unselectedWidgetColor,
        indicatorWeight: indicatorWeight,
        labelPadding: labelPadding,
        isScrollable: isScrollable,
      ),
    );
  }
}