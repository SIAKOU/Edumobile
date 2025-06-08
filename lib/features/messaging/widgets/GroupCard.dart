
import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  final String groupName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final int memberCount;
  final VoidCallback onTap;

  const GroupCard({
    Key? key,
    required this.groupName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.memberCount,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(groupName.substring(0, 2)),
      ),
      title: Text(groupName),
      subtitle: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${lastMessageTime.hour}:${lastMessageTime.minute.toString().padLeft(2, '0')}',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          if (unreadCount > 0)
            Container(
              margin: EdgeInsets.only(top: 4),
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red.shade400,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$unreadCount',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}