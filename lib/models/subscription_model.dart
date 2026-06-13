enum SubscriptionStatus {
  active,
  expired,
  pendingPayment,
  cancelled,
  suspended;

  String get label => switch (this) {
        SubscriptionStatus.active => 'Active',
        SubscriptionStatus.expired => 'Expired',
        SubscriptionStatus.pendingPayment => 'Pending Payment',
        SubscriptionStatus.cancelled => 'Cancelled',
        SubscriptionStatus.suspended => 'Suspended',
      };

  bool get isActive => this == SubscriptionStatus.active;
}

class Subscription {
  const Subscription({
    required this.subscriptionId,
    required this.customerId,
    required this.messId,
    required this.planId,
    required this.messName,
    required this.planName,
    required this.startDate,
    required this.endDate,
    required this.daysRemaining,
    required this.status,
  });

  final String subscriptionId;
  final String customerId;
  final String messId;
  final String planId;
  final String messName;
  final String planName;
  final DateTime startDate;
  final DateTime endDate;
  final int daysRemaining;
  final SubscriptionStatus status;
}
