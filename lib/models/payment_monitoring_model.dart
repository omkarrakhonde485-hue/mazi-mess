enum PaymentVerificationStatus {
  pending,
  verified,
  failed,
  manualOverride,
  retryRequired;

  String get label => switch (this) {
        PaymentVerificationStatus.pending => 'Pending',
        PaymentVerificationStatus.verified => 'Verified',
        PaymentVerificationStatus.failed => 'Failed',
        PaymentVerificationStatus.manualOverride => 'Manual Override',
        PaymentVerificationStatus.retryRequired => 'Retry Required',
      };
}

enum PaymentFailureReason {
  emailNotFound,
  webhookFailure,
  amountMismatch,
  duplicateTransaction,
  verificationTimeout,
  unknownError;

  String get label => switch (this) {
        PaymentFailureReason.emailNotFound => 'Email Not Found',
        PaymentFailureReason.webhookFailure => 'Webhook Failure',
        PaymentFailureReason.amountMismatch => 'Amount Mismatch',
        PaymentFailureReason.duplicateTransaction => 'Duplicate Transaction',
        PaymentFailureReason.verificationTimeout => 'Verification Timeout',
        PaymentFailureReason.unknownError => 'Unknown Error',
      };
}

class PaymentAuditLog {
  final String action;
  final DateTime timestamp;
  final String adminName;
  final String reason;

  const PaymentAuditLog({
    required this.action,
    required this.timestamp,
    required this.adminName,
    required this.reason,
  });
}

class PaymentVerificationRecord {
  final String id;
  final String customerName;
  final String customerMobile;
  final String messName;
  final double amount;
  final DateTime paymentTime;
  final PaymentVerificationStatus status;
  final String verificationSource;
  final String transactionRef;
  final PaymentFailureReason? failureReason;
  final List<PaymentAuditLog> auditLogs;

  const PaymentVerificationRecord({
    required this.id,
    required this.customerName,
    required this.customerMobile,
    required this.messName,
    required this.amount,
    required this.paymentTime,
    required this.status,
    required this.verificationSource,
    required this.transactionRef,
    this.failureReason,
    this.auditLogs = const [],
  });

  PaymentVerificationRecord copyWith({
    String? id,
    String? customerName,
    String? customerMobile,
    String? messName,
    double? amount,
    DateTime? paymentTime,
    PaymentVerificationStatus? status,
    String? verificationSource,
    String? transactionRef,
    PaymentFailureReason? failureReason,
    List<PaymentAuditLog>? auditLogs,
  }) {
    return PaymentVerificationRecord(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerMobile: customerMobile ?? this.customerMobile,
      messName: messName ?? this.messName,
      amount: amount ?? this.amount,
      paymentTime: paymentTime ?? this.paymentTime,
      status: status ?? this.status,
      verificationSource: verificationSource ?? this.verificationSource,
      transactionRef: transactionRef ?? this.transactionRef,
      failureReason: failureReason != null ? failureReason : this.failureReason,
      auditLogs: auditLogs ?? this.auditLogs,
    );
  }
}
