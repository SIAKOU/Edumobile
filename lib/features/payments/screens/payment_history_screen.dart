/// payment_history_screen.dart
/// Affiche l'historique détaillé des paiements (effectués et en attente) pour un élève/utilisateur.
library;

import 'package:flutter/material.dart';

class PaymentHistoryScreen extends StatelessWidget {
  PaymentHistoryScreen({super.key});

  // Remplacer par un service/provider récupérant les paiements réels 
  // ignore: unused_field
  final List<Map<String, dynamic>> _payments = [];  
  List<Map<String, dynamic>> _getPaymentHistory() {
    return [
      {
        'id': 'p1',
        'label': 'Frais de scolarité - 1er trimestre',
        'amount': 150000,
        'status': 'payé',
        'date': DateTime(2025, 1, 15),
        'method': 'Espèces',
      },
      {
        'id': 'p2',
        'label': 'Frais de bibliothèque',
        'amount': 7500,
        'status': 'en attente',
        'date': null,
        'method': null,
      },
      {
        'id': 'p3',
        'label': 'Frais d\'examen',
        'amount': 20000,
        'status': 'payé',
        'date': DateTime(2025, 4, 22),
        'method': 'Mobile Money',
      },
      {
        'id': 'p4',
        'label': 'Frais d\'uniforme',
        'amount': 10000,
        'status': 'payé',
        'date': DateTime(2025, 2, 10),
        'method': 'Chèque',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final history = _getPaymentHistory();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des paiements'),
      ),
      body: history.isEmpty
          ? const Center(child: Text("Aucun historique de paiement trouvé."))
          : ListView.separated(
              itemCount: history.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (context, index) {
                final payment = history[index];
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
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Montant : ${_formatAmount(payment['amount'])}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      if (payment['status'] == 'payé' && payment['date'] != null)
                        Text(
                          "Payé le : ${_formatDate(payment['date'])}"
                          "${payment['method'] != null ? ' | Moyen : ${payment['method']}' : ''}",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      if (payment['status'] != 'payé')
                        const Text(
                          "À régler",
                          style: TextStyle(fontSize: 12, color: Colors.orange),
                        ),
                    ],
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
                    // Naviguer vers le détail du paiement si besoin
                    Navigator.pushNamed(context, '/payments/detail', arguments: payment);
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