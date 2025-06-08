import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/models/user_model.dart';

class TeacherItem extends StatelessWidget {
  final UserModel teacher;
  final VoidCallback? onTap;

  const TeacherItem({
    Key? key,
    required this.teacher,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          (teacher.fullName?.isNotEmpty == true
                  ? teacher.fullName![0]
                  : (teacher.username?.isNotEmpty == true
                      ? teacher.username![0]
                      : '?'))
              .toUpperCase(),
        ),
      ),
      title: Text(teacher.displayName),
      subtitle: teacher.email != null ? Text(teacher.email!) : null,
      onTap: onTap,
      // Ajoute d'autres champs si besoin, par exemple matière principale, numéro de téléphone, etc.
    );
  }
}