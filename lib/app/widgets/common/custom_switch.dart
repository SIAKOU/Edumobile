/// custom_switch.dart
/// Interrupteur (Switch) personnalisable pour une apparence cohérente dans toute l'application.
/// Préfère ce widget à [Switch] pour un contrôle complet sur le style et le comportement.
library;

import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final bool enabled;

  const CustomSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget switchWidget = Switch(
      value: value,
      onChanged: enabled ? onChanged : null,
      activeColor: activeColor ?? theme.colorScheme.primary,
      inactiveThumbColor: thumbColor ?? theme.unselectedWidgetColor,
      inactiveTrackColor: inactiveColor ?? theme.disabledColor.withOpacity(0.3),
    );

    if (label != null) {
      return GestureDetector(
        onTap: enabled ? () => onChanged(!value) : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            switchWidget,
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
    return switchWidget;
  }
}