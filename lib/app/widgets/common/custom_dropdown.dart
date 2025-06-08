/// custom_dropdown.dart
/// Menu déroulant personnalisable et réutilisable pour l’application.
/// Centralise le style et les comportements pour cohérence UI.
/// Utilisez ce widget au lieu de [DropdownButtonFormField] pour garantir la cohérence UI.
library;

import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String? label;
  final String? hintText;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool enabled;
  final Widget? icon;
  final double borderRadius;
  final EdgeInsetsGeometry contentPadding;
  final Color? fillColor;

  const CustomDropdown({
    Key? key,
    this.label,
    this.hintText,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.icon,
    this.borderRadius = 8.0,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    this.fillColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        contentPadding: contentPadding,
        filled: fillColor != null,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.red),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      icon: icon ?? const Icon(Icons.arrow_drop_down),
      isExpanded: true,
      dropdownColor: fillColor ?? Theme.of(context).canvasColor,
    );
  }
}