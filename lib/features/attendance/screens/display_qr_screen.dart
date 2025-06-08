import 'package:flutter/material.dart';

class DisplayQrScreen extends StatelessWidget {
  const DisplayQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Générer le vrai QR code (ex: qr_flutter)
    return Scaffold(
      appBar: AppBar(title: const Text('Mon QR de présence')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.grey.shade300,
              width: 200,
              height: 200,
              child: const Center(child: Text('QR CODE')),
            ),
            const SizedBox(height: 24),
            Text(
              'Présentez ce QR à l\'enseignant pour valider votre présence.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}