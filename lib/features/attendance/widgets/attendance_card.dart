import 'package:flutter/material.dart';

class AttendanceCard extends StatelessWidget {
  final String date;
  final String status;
  final String? note;

  const AttendanceCard({
    super.key,
    required this.date,
    required this.status,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (status) {
      case 'Présent':
        statusColor = Colors.green;
        break;
      case 'Absent':
        statusColor = Colors.red;
        break;
      case 'En retard':
        statusColor = Colors.orange;
        break;
      case 'Excusé':
        statusColor = Colors.blue;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      child: ListTile(
        leading: Icon(Icons.event_available, color: statusColor),
        title: Text(date),
        subtitle: Text(status + (note != null && note!.isNotEmpty ? ' • $note' : '')),
      ),
    );
  }
}