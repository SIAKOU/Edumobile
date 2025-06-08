/// custom_radio_button.dart
/// Radio button personnalisable et réutilisable pour l’application.
/// Permet de centraliser le style et le comportement des radio buttons.
/// Utilisez ce widget à la place de [Radio] pour garantir la cohérence UI.
library;

import 'package:flutter/material.dart';

class CustomRadioButton<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final String label;
  final Color? activeColor;
  final Color? fillColor;
  final double size;
  final double labelSpacing;
  final TextStyle? labelStyle;
  final bool enabled;

  const CustomRadioButton({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
    this.activeColor,
    this.fillColor,
    this.size = 22.0,
    this.labelSpacing = 8.0,
    this.labelStyle,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? Theme.of(context).primaryColor;
    final effectiveLabelStyle = labelStyle ??
        TextStyle(
          color: enabled ? Colors.black : Colors.grey,
          fontWeight: FontWeight.w500,
        );

    return InkWell(
      onTap: enabled ? () => onChanged(value) : null,
      borderRadius: BorderRadius.circular(size),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<T>(
            value: value,
            groupValue: groupValue,
            onChanged: enabled ? onChanged : null,
            activeColor: effectiveActiveColor,
            fillColor: fillColor != null
                ? MaterialStateProperty.all(fillColor)
                : null,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          SizedBox(width: labelSpacing),
          Text(label, style: effectiveLabelStyle),
        ],
      ),
    );
  }
}