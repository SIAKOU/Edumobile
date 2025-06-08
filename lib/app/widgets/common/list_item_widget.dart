/// list_item_widget.dart
/// Widget réutilisable pour afficher un élément d’une liste.
/// Permet d’afficher un titre, un sous-titre, une icône/leading, un trailing, etc.
/// Utilisez ce widget pour garantir une cohérence UI sur les listes.
library;

import 'package:flutter/material.dart';

class ListItemWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;
  final EdgeInsetsGeometry contentPadding;
  final Color? tileColor;
  final Color? selectedColor;
  final bool selected;

  const ListItemWidget({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.enabled = true,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.tileColor,
    this.selectedColor,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveTileColor = selected
        ? (selectedColor ?? Theme.of(context).primaryColor.withOpacity(0.08))
        : (tileColor ?? Colors.transparent);

    return ListTile(
      enabled: enabled,
      onTap: enabled ? onTap : null,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: enabled ? Colors.black : Colors.grey,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      leading: leading,
      trailing: trailing,
      contentPadding: contentPadding,
      tileColor: effectiveTileColor,
      selected: selected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}