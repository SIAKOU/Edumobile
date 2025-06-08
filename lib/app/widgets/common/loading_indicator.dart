/// loading_indicator.dart
/// Indicateur de chargement personnalisable pour afficher une animation de "loading"
/// à utiliser à la place de [CircularProgressIndicator] ou [LinearProgressIndicator]
/// pour garantir la cohérence visuelle dans toute l'application.
library;

import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color? color;
  final bool centered;
  final String? message;
  final TextStyle? messageStyle;

  const LoadingIndicator({
    Key? key,
    this.size = 36.0,
    this.strokeWidth = 3.0,
    this.color,
    this.centered = true,
    this.message,
    this.messageStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final indicator = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Theme.of(context).colorScheme.primary,
        ),
      ),
    );

    final children = [
      indicator,
      if (message != null) ...[
        const SizedBox(height: 16),
        Text(
          message!,
          style: messageStyle ?? Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ]
    ];

    final widget = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );

    return centered
        ? Center(child: widget)
        : widget;
  }
}