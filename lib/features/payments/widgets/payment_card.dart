import 'package:flutter/material.dart';

class PaymentCard extends StatelessWidget {
  final String title;
  final double amount;
  final String status;
  final VoidCallback? onTap;

  const PaymentCard({
    super.key,
    required this.title,
    required this.amount,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (status) {
      case 'À payer':
        statusColor = Colors.orange;
        break;
      case 'Payé':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      child: ListTile(
        leading: Icon(Icons.payments, color: statusColor),
        title: Text(title),
        subtitle: Text('Montant : $amount €'),
        trailing: Text(status, style: TextStyle(color: statusColor)),
        onTap: onTap,
      ),
    );
  }
}