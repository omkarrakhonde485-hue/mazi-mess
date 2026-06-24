enum WebhookIntegrationStatus {
  setupRequired,
  active,
  inactive,
  error;

  String get label => switch (this) {
        WebhookIntegrationStatus.setupRequired => 'Setup Required',
        WebhookIntegrationStatus.active => 'Active',
        WebhookIntegrationStatus.inactive => 'Inactive',
        WebhookIntegrationStatus.error => 'Error',
      };
}

class WebhookIntegration {
  final String id;
  final String messName;
  final String ownerName;
  final String verificationGmail;
  final String makeAccountEmail;
  final String makeAccountPassword;
  final String webhookUrl;
  final DateTime setupDate;
  final String configuredBy;
  final WebhookIntegrationStatus status;

  const WebhookIntegration({
    required this.id,
    required this.messName,
    required this.ownerName,
    required this.verificationGmail,
    required this.makeAccountEmail,
    required this.makeAccountPassword,
    required this.webhookUrl,
    required this.setupDate,
    required this.configuredBy,
    required this.status,
  });

  WebhookIntegration copyWith({
    String? id,
    String? messName,
    String? ownerName,
    String? verificationGmail,
    String? makeAccountEmail,
    String? makeAccountPassword,
    String? webhookUrl,
    DateTime? setupDate,
    String? configuredBy,
    WebhookIntegrationStatus? status,
  }) {
    return WebhookIntegration(
      id: id ?? this.id,
      messName: messName ?? this.messName,
      ownerName: ownerName ?? this.ownerName,
      verificationGmail: verificationGmail ?? this.verificationGmail,
      makeAccountEmail: makeAccountEmail ?? this.makeAccountEmail,
      makeAccountPassword: makeAccountPassword ?? this.makeAccountPassword,
      webhookUrl: webhookUrl ?? this.webhookUrl,
      setupDate: setupDate ?? this.setupDate,
      configuredBy: configuredBy ?? this.configuredBy,
      status: status ?? this.status,
    );
  }
}
