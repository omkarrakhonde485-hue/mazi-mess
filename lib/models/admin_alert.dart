enum AlertSeverity {
  info,
  warning,
  critical;

  String get label => switch (this) {
        AlertSeverity.info => 'Info',
        AlertSeverity.warning => 'Warning',
        AlertSeverity.critical => 'Critical',
      };
}

class AdminAlert {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final AlertSeverity severity;
  final bool isRead;

  const AdminAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.severity,
    this.isRead = false,
  });

  AdminAlert copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? timestamp,
    AlertSeverity? severity,
    bool? isRead,
  }) {
    return AdminAlert(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      severity: severity ?? this.severity,
      isRead: isRead ?? this.isRead,
    );
  }
}
