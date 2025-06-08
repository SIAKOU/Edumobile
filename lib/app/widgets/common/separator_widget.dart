/// separator_widget.dart
/// Un widget séparateur personnalisable pour séparer visuellement des éléments dans l'UI.
/// Permet d'ajuster l'épaisseur, la couleur, l'espacement et la direction (horizontal/vertical).
library;

import 'package:flutter/material.dart';

class SeparatorWidget extends StatelessWidget {
  final double thickness;
  final double length;
  final Color? color;
  final Axis direction;
  final EdgeInsetsGeometry margin;

  const SeparatorWidget({
    Key? key,
    this.thickness = 1.0,
    this.length = double.infinity,
    this.color,
    this.direction = Axis.horizontal,
    this.margin = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sepColor = color ?? Theme.of(context).dividerColor;
    return Container(
      margin: margin,
      width: direction == Axis.horizontal ? length : thickness,
      height: direction == Axis.horizontal ? thickness : length,
      color: sepColor,
    );
  }
}