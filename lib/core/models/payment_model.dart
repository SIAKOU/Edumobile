/// payment_model.dart
/// Modèle représentant un paiement lié à un élève, une classe, une prestation ou des frais scolaires.
/// Adapté au stockage local ou API (REST, Firebase, Supabase...).
library;

import 'package:equatable/equatable.dart';

class PaymentModel extends Equatable {
  final String id;
  final String? studentId;         // ID de l'élève concerné (optionnel)
  final String? classId;           // ID de la classe concernée (optionnel)
  final String? description;       // Description du paiement (ex: "Frais d'inscription")
  final double amount;             // Montant payé
  final String currency;           // Devise (ex: "EUR", "USD")
  final DateTime date;             // Date du paiement
  final String? paymentType;       // Espèces, carte, virement, chèque...
  final String? recordedBy;        // ID du user ayant enregistré le paiement
  final String? receiptUrl;        // URL du reçu (optionnel)
  final String? status;            // Statut : payé, en attente, remboursé, etc.
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  // Ajoutez d'autres champs métiers si besoin (ex: tags, catégorie...)

  const PaymentModel({
    required this.id,
    this.studentId,
    this.classId,
    this.description,
    required this.amount,
    required this.currency,
    required this.date,
    this.paymentType,
    this.recordedBy,
    this.receiptUrl,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
        id,
        studentId,
        classId,
        description,
        amount,
        currency,
        date,
        paymentType,
        recordedBy,
        receiptUrl,
        status,
        createdAt,
        updatedAt,
        isActive,
      ];

  /// Mapping JSON <-> Objet
  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        id: json['id'] as String,
        studentId: json['studentId'] as String? ?? json['student_id'] as String?,
        classId: json['classId'] as String? ?? json['class_id'] as String?,
        description: json['description'] as String?,
        amount: (json['amount'] as num).toDouble(),
        currency: json['currency'] as String,
        date: json['date'] != null
            ? DateTime.parse(json['date'])
            : DateTime.now(),
        paymentType: json['paymentType'] as String? ?? json['payment_type'] as String?,
        recordedBy: json['recordedBy'] as String? ?? json['recorded_by'] as String?,
        receiptUrl: json['receiptUrl'] as String? ?? json['receipt_url'] as String?,
        status: json['status'] as String?,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'])
            : json['created_at'] != null
                ? DateTime.tryParse(json['created_at'])
                : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'])
            : json['updated_at'] != null
                ? DateTime.tryParse(json['updated_at'])
                : null,
        isActive: json['isActive'] as bool? ?? json['is_active'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        if (studentId != null) 'studentId': studentId,
        if (classId != null) 'classId': classId,
        if (description != null) 'description': description,
        'amount': amount,
        'currency': currency,
        'date': date.toIso8601String(),
        if (paymentType != null) 'paymentType': paymentType,
        if (recordedBy != null) 'recordedBy': recordedBy,
        if (receiptUrl != null) 'receiptUrl': receiptUrl,
        if (status != null) 'status': status,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
        'isActive': isActive,
      };

  /// Copie avec modifications
  PaymentModel copyWith({
    String? id,
    String? studentId,
    String? classId,
    String? description,
    double? amount,
    String? currency,
    DateTime? date,
    String? paymentType,
    String? recordedBy,
    String? receiptUrl,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      classId: classId ?? this.classId,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      date: date ?? this.date,
      paymentType: paymentType ?? this.paymentType,
      recordedBy: recordedBy ?? this.recordedBy,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}