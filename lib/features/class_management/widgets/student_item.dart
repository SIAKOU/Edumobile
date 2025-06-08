import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/models/user_model.dart';

class StudentItem extends StatelessWidget {
  final UserModel student;
  final VoidCallback? onTap;

  const StudentItem({
    Key? key,
    required this.student,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          (student.fullName?.isNotEmpty == true
                  ? student.fullName![0]
                  : (student.username?.isNotEmpty == true
                      ? student.username![0]
                      : '?'))
              .toUpperCase(),
        ),
      ),
      title: Text(student.displayName),
      subtitle: student.email != null ? Text(student.email!) : null,
      onTap: onTap,
      // Ajoute d'autres infos selon besoin (ex: numéro d'élève, statut, etc.)
    );
  }
}