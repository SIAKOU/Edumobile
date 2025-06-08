import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gestion_ecole/app/config/app_routes.dart';

class PaymentDetailScreen extends StatelessWidget {
  final Map<String, dynamic> payment;
  const PaymentDetailScreen({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final String title = payment['label'] ?? payment['title'] ?? 'Détail paiement';
    final int amount = _parseAmount(payment['amount']);
    final String status = (payment['status'] ?? '').toString();
    final DateTime? dueDate = _parseDate(payment['dueDate']);
    final DateTime? paidDate = _parseDate(payment['date']);

    final bool isPaid = status.toLowerCase().contains('pay');
    final bool isPending = status.toLowerCase().contains('attente') || status.toLowerCase().contains('à payer');

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Montant : ${_formatAmount(amount)}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            Text(
              'Statut : ${_statusLabel(status)}',
              style: TextStyle(
                color: isPaid
                    ? Colors.green
                    : isPending
                        ? Colors.orange
                        : Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (dueDate != null) ...[
              const SizedBox(height: 12),
              Text('Date limite : ${_formatDate(dueDate)}'),
            ],
            if (paidDate != null && isPaid) ...[
              const SizedBox(height: 12),
              Text('Payé le : ${_formatDate(paidDate)}'),
            ],
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.payment),
                onPressed: isPaid
                    ? null
                    : () {
                        context.goNamed(
                          AppRouteNames.paymentProcess,
                          extra: payment,
                        );
                      },
                label: Text(isPaid ? 'Déjà payé' : 'Payer maintenant'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPaid ? Colors.grey : Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 18),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _parseAmount(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value.replaceAll(' ', '')) ?? 0;
    return 0;
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) return DateTime.tryParse(value);
    return null;
  }

  String _formatAmount(int amount) {
    if (amount == 0) return '0 FCFA';
    return '${amount.toString().replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (match) => "${match[1]} ")} FCFA';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'payé':
      case 'paye':
        return 'Payé';
      case 'en attente':
        return 'En attente';
      case 'à payer':
      case 'a payer':
        return 'À payer';
      default:
        return status;
    }
  }
}