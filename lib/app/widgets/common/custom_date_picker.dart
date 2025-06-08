/// custom_date_picker.dart
/// Sélecteur de date personnalisable et réutilisable pour l’application.
/// Centralise le style, le format d’affichage et les comportements.
/// Utilisez ce widget pour garantir la cohérence UI sur la sélection de dates.
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateChanged;
  final String? label;
  final String? hintText;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateFormat displayFormat;
  final bool enabled;
  final Widget? icon;
  final EdgeInsetsGeometry contentPadding;

  CustomDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
    this.label,
    this.hintText,
    this.firstDate,
    this.lastDate,
    DateFormat? displayFormat,
    this.enabled = true,
    this.icon,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  }) : displayFormat = displayFormat ?? DateFormat('dd/MM/yyyy'); // <-- Correction ici

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final initial = selectedDate ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      locale: const Locale('fr'),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(
            primary: Theme.of(ctx).primaryColor,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? () => _pickDate(context) : null,
      child: AbsorbPointer(
        absorbing: true,
        child: TextFormField(
          enabled: enabled,
          readOnly: true,
          controller: TextEditingController(
            text: selectedDate != null ? displayFormat.format(selectedDate!) : '',
          ),
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText ?? 'Sélectionner une date',
            prefixIcon: icon ?? const Icon(Icons.calendar_today),
            contentPadding: contentPadding,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.red),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            suffixIcon: const Icon(Icons.arrow_drop_down),
          ),
        ),
      ),
    );
  }
}