/// qr_service.dart
/// Service utilitaire pour la génération et la lecture de codes QR.
/// Utilise des packages comme `qr_flutter` (génération) et `qr_code_scanner` (lecture) côté UI,
/// ici on centralise la logique pour transformer des données en QR et décoder un QR en données.
library;

import 'dart:typed_data';
import 'dart:ui';
import 'package:mobile_scanner/mobile_scanner.dart' hide Barcode;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';

class QrService {
  /// Génère un widget QR à partir d'une donnée (ex: string ou url)
  Widget generateQrWidget(String data, {double size = 200.0}) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: size,
      gapless: false,
    );
  }

  /// Génère une image QR code sous forme de bytes pour sauvegarde ou partage
  Future<Uint8List> generateQrBytes(String data, {double size = 200.0}) async {
    final painter = QrPainter(
      data: data,
      version: QrVersions.auto,
      gapless: false,
    );
    final image = await painter.toImage(size.toInt() as double);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  /// Décodage d'un QR code à partir du résultat du scanner
  /// (La logique du scan se fait côté widget, ici on centralise juste la récupération du résultat)
  String? decodeQr(Barcode? scanData) {
    return scanData?.code;
  }
}

extension BarcodeExtension on Barcode? {
  String? get code => this?.code;
}