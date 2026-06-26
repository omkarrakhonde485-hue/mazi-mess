import 'package:flutter/material.dart';

enum OwnerSubscriptionStatus {
  active,
  expiringSoon,
  expired;

  String get label => switch (this) {
        OwnerSubscriptionStatus.active => 'Active',
        OwnerSubscriptionStatus.expiringSoon => 'Expiring Soon',
        OwnerSubscriptionStatus.expired => 'Expired',
      };
}

enum BillingCycle {
  monthly,
  yearly;

  String get label => switch (this) {
        BillingCycle.monthly => 'Monthly',
        BillingCycle.yearly => 'Yearly',
      };
}

class OwnerSubscriptionPayment {
  final DateTime paymentDate;
  final String plan;
  final double amount;
  final String status;

  const OwnerSubscriptionPayment({
    required this.paymentDate,
    required this.plan,
    required this.amount,
    required this.status,
  });
}

class OwnerSubscription {
  final String id;
  final String ownerName;
  final String messName;
  final String planName; // "Premium", "Basic", etc.
  final BillingCycle billingCycle;
  final double amountPaid;
  final DateTime paymentDate;
  final DateTime expiryDate;
  final OwnerSubscriptionStatus status;
  final List<OwnerSubscriptionPayment> paymentHistory;

  const OwnerSubscription({
    required this.id,
    required this.ownerName,
    required this.messName,
    required this.planName,
    required this.billingCycle,
    required this.amountPaid,
    required this.paymentDate,
    required this.expiryDate,
    required this.status,
    this.paymentHistory = const [],
  });

  int get daysRemaining {
    final difference = expiryDate.difference(DateTime.now()).inDays;
    return difference < 0 ? 0 : difference;
  }

  OwnerSubscription copyWith({
    String? id,
    String? ownerName,
    String? messName,
    String? planName,
    BillingCycle? billingCycle,
    double? amountPaid,
    DateTime? paymentDate,
    DateTime? expiryDate,
    OwnerSubscriptionStatus? status,
    List<OwnerSubscriptionPayment>? paymentHistory,
  }) {
    return OwnerSubscription(
      id: id ?? this.id,
      ownerName: ownerName ?? this.ownerName,
      messName: messName ?? this.messName,
      planName: planName ?? this.planName,
      billingCycle: billingCycle ?? this.billingCycle,
      amountPaid: amountPaid ?? this.amountPaid,
      paymentDate: paymentDate ?? this.paymentDate,
      expiryDate: expiryDate ?? this.expiryDate,
      status: status ?? this.status,
      paymentHistory: paymentHistory ?? this.paymentHistory,
    );
  }
}
