/// card_layout.dart
/// Widget de carte personnalisée, pour un affichage cohérent de contenus dans l'application.
/// Utilisez ce widget comme conteneur pour listes, aperçus, etc.
/// Personnalisation possible (padding, marges, couleur, elevation, etc.)
library;

import 'package:flutter/material.dart';

class CardLayout extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final double elevation;
  final BorderRadiusGeometry borderRadius;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  const CardLayout({
    super.key, // Correction: utilisation de super parameter pour 'key'
    required this.child,
    this.margin = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
    this.padding = const EdgeInsets.all(16.0),
    this.color,
    this.elevation = 2.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.boxShadow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = color ?? theme.cardColor;

    // Correction du type pour borderRadius : il doit être BorderRadius? pour Material et InkWell
    final BorderRadius? effectiveBorderRadius = borderRadius is BorderRadius ? borderRadius as BorderRadius : null;

    return Container(
      margin: margin,
      child: Material(
        color: cardColor,
        elevation: elevation,
        borderRadius: effectiveBorderRadius,
        shadowColor: Colors.black.withOpacity(0.10), // Correction: voir ci-dessous pour .withOpacity
        child: InkWell(
          borderRadius: effectiveBorderRadius?.copyWith(topLeft: Radius.zero, topRight: Radius.zero),
          onTap: onTap,
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              boxShadow: boxShadow,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

extension BorderRadiusGeometryCopyWith on BorderRadius {
  BorderRadius copyWith({Radius? topLeft, Radius? topRight, Radius? bottomLeft, Radius? bottomRight}) {
    return BorderRadius.only(
      topLeft: topLeft ?? this.topLeft,
      topRight: topRight ?? this.topRight,
      bottomLeft: bottomLeft ?? this.bottomLeft,
      bottomRight: bottomRight ?? this.bottomRight,
    );
  }
}