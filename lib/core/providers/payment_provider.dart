/// payment_provider.dart
/// Provider (ChangeNotifier) pour gérer l'état des paiements (payments) dans l'application.
/// Utilise PaymentRepository pour effectuer les opérations backend et expose l'état à la couche UI.
/// Permet de charger la liste des paiements, les détails, la création, la mise à jour, la suppression, etc.
library;

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/repositories/payment_repository.dart';


enum PaymentStatus { initial, loading, loaded, error }

class PaymentProvider extends ChangeNotifier {
  final PaymentRepository paymentRepository;

  PaymentStatus _status = PaymentStatus.initial;
  List<Map<String, dynamic>> _payments = [];
  Map<String, dynamic>? _selectedPayment;
  String? _errorMessage;

  PaymentProvider({required this.paymentRepository});

  PaymentStatus get status => _status;
  List<Map<String, dynamic>> get payments => _payments;
  Map<String, dynamic>? get selectedPayment => _selectedPayment;
  String? get errorMessage => _errorMessage;

  /// Charge la liste des paiements (optionnellement pour une classe ou un élève spécifique)
  Future<void> loadPayments({String? classId, String? studentId}) async {
    _status = PaymentStatus.loading;
    notifyListeners();
    try {
      _payments = await paymentRepository.getPayments(classId: classId, studentId: studentId);
      _status = PaymentStatus.loaded;
    } catch (e) {
      _status = PaymentStatus.error;
      _errorMessage = "Erreur lors du chargement des paiements.";
    }
    notifyListeners();
  }

  /// Charge les détails d'un paiement
  Future<void> loadPaymentById(String paymentId) async {
    _status = PaymentStatus.loading;
    notifyListeners();
    try {
      _selectedPayment = await paymentRepository.getPaymentById(paymentId);
      _status = PaymentStatus.loaded;
    } catch (e) {
      _status = PaymentStatus.error;
      _errorMessage = "Erreur lors du chargement du paiement.";
    }
    notifyListeners();
  }

  /// Crée un nouveau paiement
  Future<bool> createPayment(Map<String, dynamic> paymentData) async {
    _status = PaymentStatus.loading;
    notifyListeners();
    try {
      final success = await paymentRepository.createPayment(paymentData);
      if (success) {
        await loadPayments();
        _status = PaymentStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = PaymentStatus.error;
        _errorMessage = "La création du paiement a échoué.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = PaymentStatus.error;
      _errorMessage = "Erreur lors de la création du paiement.";
      notifyListeners();
      return false;
    }
  }

  /// Met à jour un paiement
  Future<bool> updatePayment(String paymentId, Map<String, dynamic> updateData) async {
    _status = PaymentStatus.loading;
    notifyListeners();
    try {
      final success = await paymentRepository.updatePayment(paymentId, updateData);
      if (success) {
        await loadPaymentById(paymentId);
        await loadPayments();
        _status = PaymentStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = PaymentStatus.error;
        _errorMessage = "La mise à jour du paiement a échoué.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = PaymentStatus.error;
      _errorMessage = "Erreur lors de la mise à jour du paiement.";
      notifyListeners();
      return false;
    }
  }

  /// Supprime un paiement
  Future<bool> deletePayment(String paymentId) async {
    _status = PaymentStatus.loading;
    notifyListeners();
    try {
      final success = await paymentRepository.deletePayment(paymentId);
      if (success) {
        await loadPayments();
        _status = PaymentStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = PaymentStatus.error;
        _errorMessage = "La suppression du paiement a échoué.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = PaymentStatus.error;
      _errorMessage = "Erreur lors de la suppression du paiement.";
      notifyListeners();
      return false;
    }
  }
}