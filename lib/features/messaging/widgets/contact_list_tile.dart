import 'package:flutter/material.dart';

class ContactListTile extends StatelessWidget {
  final String contactName;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;
  final VoidCallback? onTap;
  final Widget leading;
  final Widget trailing;

  const ContactListTile({
    super.key,
    required this.contactName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.leading,
    required this.trailing,
    this.onTap, required avatarText,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(
        contactName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.black54),
      ),
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
