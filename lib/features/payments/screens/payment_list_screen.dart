/// payment_list_screen.dart
/// Affiche la liste des paiements effectués ou à effectuer.
/// Peut être adaptée pour l'historique des paiements d'un élève, d'une classe ou de l'établissement.
library;

import 'package:flutter/material.dart';
import 'package:gestion_ecole/features/payments/screens/payment_detail_screen.dart';

class PaymentListScreen extends StatelessWidget {
  PaymentListScreen({super.key});

  // Récupérer la liste réelle des paiements depuis un provider/service
  // Pour l'exemple, on utilise une liste statique
  // ignore: unused_field
  final List<Map<String, dynamic>> _payments = [];

  List<Map<String, dynamic>> _getPayments() {
    return [
      {
        'id': 'p1',
        'label': 'Frais de scolarité - 1er trimestre',
        'amount': 150000,
        'status': 'payé',
        'date': DateTime(2025, 1, 15),
      },
      {
        'id': 'p2',
        'label': 'Frais de bibliothèque',
        'amount': 7500,
        'status': 'en attente',
        'date': DateTime(2025, 3, 1),
      },
      {
        'id': 'p3',
        'label': 'Frais d\'examen',
        'amount': 20000,
        'status': 'payé',
        'date': DateTime(2025, 4, 22),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final payments = _getPayments();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des paiements'),
      ),
      body: payments.isEmpty
          ? const Center(child: Text("Aucun paiement trouvé."))
          : ListView.separated(
              itemCount: payments.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (context, index) {
                final payment = payments[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: payment['status'] == 'payé'
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    child: Icon(
                      payment['status'] == 'payé'
                          ? Icons.check_circle
                          : Icons.hourglass_bottom,
                      color: payment['status'] == 'payé'
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                  title: Text(payment['label']),
                  subtitle: Text(
                    "Montant : ${_formatAmount(payment['amount'])}\n"
                    "Date : ${_formatDate(payment['date'])}",
                  ),
                  trailing: Text(
                    payment['status'].toString().toUpperCase(),
                    style: TextStyle(
                      color: payment['status'] == 'payé'
                          ? Colors.green
                          : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    // Naviguer vers l'écran de détail du paiement si besoin
                    // Pour l'exemple, on affiche juste un message
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Vous avez cliqué sur le paiement ${payment['label']}'))
                            );
                    Navigator.push(
                       context,
                         MaterialPageRoute(
                           builder: (_) => PaymentDetailScreen(payment: payment),
                         ),
                      ); // Remplacer par l'écran de détail du paiement
                  },
                );
              },
            ),
    );
  }

  String _formatAmount(int amount) {
    return '${amount.toString().replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (match) => "${match[1]} ")} FCFA';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
