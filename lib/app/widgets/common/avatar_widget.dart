/// avatar_widget.dart
/// Widget d’avatar personnalisable et réutilisable pour l’application.
/// Permet d’afficher une image utilisateur ou des initiales avec un style cohérent.
/// Utilisez ce widget pour garantir une présentation uniforme des avatars.
library;

import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double radius;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? badge;
  final VoidCallback? onTap;

  const AvatarWidget({
    Key? key,
    this.imageUrl,
    this.initials,
    this.radius = 24.0,
    this.backgroundColor,
    this.textColor,
    this.badge,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? Colors.grey.shade300;
    final txtColor = textColor ?? Colors.black87;

    Widget avatarContent;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatarContent = CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl!),
        backgroundColor: bg,
      );
    } else if (initials != null && initials!.isNotEmpty) {
      avatarContent = CircleAvatar(
        radius: radius,
        backgroundColor: bg,
        child: Text(
          initials!.toUpperCase(),
          style: TextStyle(
            color: txtColor,
            fontWeight: FontWeight.bold,
            fontSize: radius * 0.7,
          ),
        ),
      );
    } else {
      avatarContent = CircleAvatar(
        radius: radius,
        backgroundColor: bg,
        child: Icon(Icons.person, color: txtColor, size: radius),
      );
    }

    Widget avatarWithBadge = badge == null
        ? avatarContent
        : Stack(
            clipBehavior: Clip.none,
            children: [
              avatarContent,
              Positioned(
                right: -4,
                bottom: -4,
                child: badge!,
              ),
            ],
          );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatarWithBadge,
      );
    }
    return avatarWithBadge;
  }
}