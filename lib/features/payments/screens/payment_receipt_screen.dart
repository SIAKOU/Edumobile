import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';

class PaymentReceiptScreen extends StatelessWidget {
  final Map<String, dynamic> payment;
  const PaymentReceiptScreen({Key? key, required this.payment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String title = payment['label'] ?? payment['title'] ?? 'Reçu de paiement';
    final int amount = _parseAmount(payment['amount']);
    final String status = (payment['status'] ?? '').toString();
    final String method = payment['method'] ?? "N/A";
    final DateTime? paidDate = _parseDate(payment['date']);
    final String receiptNumber = payment['receiptNumber'] ?? payment['id'] ?? '---';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reçu de paiement'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: "Partager",
            onPressed: () async {
              final receiptText = _buildReceiptText(
                title: title,
                amount: amount,
                status: status,
                method: method,
                paidDate: paidDate,
                receiptNumber: receiptNumber,
              );
              await Share.share(receiptText, subject: 'Reçu de paiement');
            },
          ),
          IconButton(
            icon: const Icon(Icons.print),
            tooltip: "Imprimer",
            onPressed: () async {
              await Printing.layoutPdf(
                onLayout: (format) => _generatePdfReceipt(
                  title: title,
                  amount: amount,
                  status: status,
                  method: method,
                  paidDate: paidDate,
                  receiptNumber: receiptNumber,
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Card(
          elevation: 4,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const Icon(Icons.receipt_long, size: 48, color: Colors.green),
                      const SizedBox(height: 8),
                      Text(
                        "REÇU DE PAIEMENT",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.green.shade800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _infoRow("Référence", receiptNumber),
                const Divider(),
                _infoRow("Intitulé", title),
                const SizedBox(height: 8),
                _infoRow("Montant", _formatAmount(amount)),
                const SizedBox(height: 8),
                _infoRow("Statut", _statusLabel(status)),
                const SizedBox(height: 8),
                if (paidDate != null) _infoRow("Date du paiement", _formatDate(paidDate)),
                if (method.isNotEmpty && method != "N/A") _infoRow("Moyen de paiement", method),
                // Ajoute d'autres infos (nom élève, classe, etc.) selon les besoins de ton appli
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Merci pour votre paiement.",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Ce reçu est généré électroniquement et n’a pas besoin de signature.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Retour'),
                    onPressed: () {
                      context.goNamed('paymentList');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label : ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
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

  String _buildReceiptText({
    required String title,
    required int amount,
    required String status,
    required String method,
    required DateTime? paidDate,
    required String receiptNumber,
  }) {
    return '''
REÇU DE PAIEMENT

Référence : $receiptNumber
Intitulé : $title
Montant : ${_formatAmount(amount)}
Statut : ${_statusLabel(status)}
${paidDate != null ? "Date du paiement : ${_formatDate(paidDate)}\n" : ""}
${method.isNotEmpty && method != "N/A" ? "Moyen de paiement : $method\n" : ""}
Merci pour votre paiement.
Ce reçu est généré électroniquement et n’a pas besoin de signature.
''';
  }

  // Génère un PDF simple avec le package "pdf"
  Future<Uint8List> _generatePdfReceipt({
    required String title,
    required int amount,
    required String status,
    required String method,
    required DateTime? paidDate,
    required String receiptNumber,
  }) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Icon(pw.IconData(0xe5ca), size: 48, color: PdfColors.green),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    "REÇU DE PAIEMENT",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 20,
                      color: PdfColors.green800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 24),
            _pdfInfoRow("Référence", receiptNumber),
            pw.Divider(),
            _pdfInfoRow("Intitulé", title),
            pw.SizedBox(height: 8),
            _pdfInfoRow("Montant", _formatAmount(amount)),
            pw.SizedBox(height: 8),
            _pdfInfoRow("Statut", _statusLabel(status)),
            pw.SizedBox(height: 8),
            if (paidDate != null) _pdfInfoRow("Date du paiement", _formatDate(paidDate)),
            if (method.isNotEmpty && method != "N/A") _pdfInfoRow("Moyen de paiement", method),
            pw.SizedBox(height: 24),
            pw.Align(
              alignment: pw.Alignment.center,
              child: pw.Text(
                "Merci pour votre paiement.",
                style: pw.TextStyle(
                  color: PdfColors.grey700,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ),
            pw.Spacer(),
            pw.Align(
              alignment: pw.Alignment.center,
              child: pw.Text(
                "Ce reçu est généré électroniquement et n’a pas besoin de signature.",
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(fontSize: 12, color: PdfColors.grey),
              ),
            ),
          ],
        ),
      ),
    );
    return pdf.save();
  }

  pw.Widget _pdfInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "$label : ",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.Expanded(
            child: pw.Text(value, style: pw.TextStyle(fontWeight: pw.FontWeight.normal)),
          ),
        ],
      ),
    );
  }
}