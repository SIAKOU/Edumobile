import 'package:flutter/material.dart';
import '../widgets/qr_scanner_overlay.dart';

class ScanQrScreen extends StatelessWidget {
  const ScanQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Brancher avec un vrai scanner QR (ex: qr_code_scanner package)
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner le QR de présence')),
      body: Stack(
        children: [
          Center(
            child: Container(
              color: Colors.black12,
              width: double.infinity,
              height: double.infinity,
              child: const Center(child: Text('Aperçu caméra ici')),
            ),
          ),
          const QrScannerOverlay(),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Simuler scan'),
                onPressed: () {
                  // TODO: Remplacer par la vraie détection QR
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Présence enregistrée !')),
                  );
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}