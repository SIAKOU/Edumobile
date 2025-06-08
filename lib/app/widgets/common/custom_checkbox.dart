/// custom_checkbox.dart
/// Checkbox personnalisée pour une apparence cohérente dans toute l'application.
/// Préfère ce widget à [Checkbox] pour un contrôle complet sur le style et le comportement.
library;

import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String? label;
  final Color? activeColor;
  final Color? checkColor;
  final Color? borderColor;
  final double borderRadius;
  final double size;
  final bool enabled;

  const CustomCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.label,
    this.activeColor,
    this.checkColor,
    this.borderColor,
    this.borderRadius = 6.0,
    this.size = 24.0,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveActiveColor = activeColor ?? theme.colorScheme.primary;
    final effectiveCheckColor = checkColor ?? Colors.white;
    final effectiveBorderColor =
        borderColor ?? theme.dividerColor.withOpacity(0.7);

    Widget box = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: value ? effectiveActiveColor : Colors.transparent,
        border: Border.all(
          color: value ? effectiveActiveColor : effectiveBorderColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: value
          ? Icon(Icons.check, size: size * 0.7, color: effectiveCheckColor)
          : null,
    );

    Widget checkbox = InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      onTap: enabled ? () => onChanged(!value) : null,
      child: box,
    );

    if (label != null) {
      return GestureDetector(
        onTap: enabled ? () => onChanged(!value) : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            checkbox,
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                label!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: enabled ? null : theme.disabledColor,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return checkbox;
  }
}