/// payment_process_screen.dart
/// Écran pour effectuer un paiement (saisie des infos, confirmation, etc.)

// ignore_for_file: no_leading_underscores_for_local_identifiers, dangling_library_doc_comments

import 'package:flutter/material.dart';

class PaymentProcessScreen extends StatefulWidget {
  final Map<String, dynamic> payment;
  const PaymentProcessScreen({Key? key, required this.payment}) : super(key: key);

  @override
  State<PaymentProcessScreen> createState() => _PaymentProcessScreenState();
}

class _PaymentProcessScreenState extends State<PaymentProcessScreen> {
  bool _processing = false;
  bool _success = false;

  // Simule la validation du paiement (remplace par ton appel API réel)
  Future<void> _submitPayment() async {
    setState(() {
      _processing = true;
      _success = false;
    });
    // Simule un délai réseau
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _processing = false;
      _success = true;
    });
    // Affiche la confirmation puis retourne à la liste des paiements
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }

  @override
  Widget build(BuildContext context) {
    final payment = widget.payment;
    final String title = payment['label'] ?? payment['title'] ?? 'Paiement';
    final int amount = payment['amount'] ?? 0;
    String _formatAmount(int amount) {
      return '${amount.toString().replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (match) => "${match[1]} ")} FCFA';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Paiement - $title'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: _success
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 80),
                    const SizedBox(height: 16),
                    const Text(
                      "Paiement effectué avec succès !",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Text('Montant à payer : ${_formatAmount(amount)}', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 32),
                    _processing
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.payment),
                              onPressed: _submitPayment,
                              label: const Text('Valider le paiement'),
                            ),
                          ),
                  ],
                ),
        ),
      ),
    );
  }
}