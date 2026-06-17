enum PaymentStatus {
  success,
  pending,
  failed;

  String get label => switch (this) {
        PaymentStatus.success => 'Success',
        PaymentStatus.pending => 'Pending',
        PaymentStatus.failed => 'Failed',
      };
}

class PaymentItem {
  const PaymentItem({
    required this.paymentId,
    required this.transactionId,
    required this.amount,
    required this.paymentDate,
    required this.status,
    required this.messName,
    required this.planName,
    required this.paymentMethod,
  });

  final String paymentId;
  final String transactionId;
  final double amount;
  final DateTime paymentDate;
  final PaymentStatus status;
  final String messName;
  final String planName;
  final String paymentMethod;
}
