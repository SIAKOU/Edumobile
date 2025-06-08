import 'package:flutter/material.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final methods = ['Carte', 'PayPal', 'Virement'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Méthode de paiement', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          children: methods
              .map(
                (m) => ChoiceChip(
                  label: Text(m),
                  selected: selected == m,
                  onSelected: (_) => onChanged(m),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}