import 'package:flutter/material.dart';

class GroupMemberChip extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final bool isAdmin;

  const GroupMemberChip({
    Key? key,
    required this.name,
    this.avatarUrl,
    this.isAdmin = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: avatarUrl != null
          ? CircleAvatar(backgroundImage: NetworkImage(avatarUrl!))
          : CircleAvatar(child: Text(_getInitials(name))),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(name),
          if (isAdmin)
            const Padding(
              padding: EdgeInsets.only(left: 5),
              child: Icon(Icons.star, size: 16, color: Colors.amber),
            ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return parts.take(2).map((e) => e[0].toUpperCase()).join();
  }
}