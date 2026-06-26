class GlobalSettingsModel {
  // Section 1: Platform Settings
  final String platformName;
  final String supportEmail;
  final String supportPhone;
  final String currentAppVersion;
  final bool maintenanceMode;

  // Section 2: Registration Control
  final bool allowNewOwnerRegistrations;
  final bool allowNewCustomerRegistrations;

  // Section 3: Owner Subscription Settings
  final double defaultMonthlySubscriptionPrice;
  final double defaultYearlySubscriptionPrice;
  final int gracePeriodDays;
  final int reminderBeforeExpiryDays;
  final bool autoSuspendExpiredOwners;

  // Section 4: Customer Rules
  final int minSubscriptionDaysToReview;
  final int defaultAttendanceApprovalWindowMinutes;
  final int maxLeaveDaysPerMonth;
  final int reviewEditTimeLimitMinutes;

  // Section 5: Payment Verification
  final bool uniqueAmountOffsetEnabled;
  final int verificationTimeoutMinutes;
  final bool autoRetryEnabled;
  final int retryAttempts;
  final int allowedVerificationTimeWindowMinutes;

  // Section 6: Notification Settings
  final bool pushNotificationsEnabled;
  final bool emailNotificationsEnabled;
  final bool ownerAlertsEnabled;
  final bool adminAlertsEnabled;
  final bool maintenanceBroadcastEnabled;

  // Section 8: Security
  final int sessionTimeoutMinutes;
  final String minSupportedAppVersion;
  final bool emergencyPlatformLock;

  const GlobalSettingsModel({
    required this.platformName,
    required this.supportEmail,
    required this.supportPhone,
    required this.currentAppVersion,
    required this.maintenanceMode,
    required this.allowNewOwnerRegistrations,
    required this.allowNewCustomerRegistrations,
    required this.defaultMonthlySubscriptionPrice,
    required this.defaultYearlySubscriptionPrice,
    required this.gracePeriodDays,
    required this.reminderBeforeExpiryDays,
    required this.autoSuspendExpiredOwners,
    required this.minSubscriptionDaysToReview,
    required this.defaultAttendanceApprovalWindowMinutes,
    required this.maxLeaveDaysPerMonth,
    required this.reviewEditTimeLimitMinutes,
    required this.uniqueAmountOffsetEnabled,
    required this.verificationTimeoutMinutes,
    required this.autoRetryEnabled,
    required this.retryAttempts,
    required this.allowedVerificationTimeWindowMinutes,
    required this.pushNotificationsEnabled,
    required this.emailNotificationsEnabled,
    required this.ownerAlertsEnabled,
    required this.adminAlertsEnabled,
    required this.maintenanceBroadcastEnabled,
    required this.sessionTimeoutMinutes,
    required this.minSupportedAppVersion,
    required this.emergencyPlatformLock,
  });

  GlobalSettingsModel copyWith({
    String? platformName,
    String? supportEmail,
    String? supportPhone,
    String? currentAppVersion,
    bool? maintenanceMode,
    bool? allowNewOwnerRegistrations,
    bool? allowNewCustomerRegistrations,
    double? defaultMonthlySubscriptionPrice,
    double? defaultYearlySubscriptionPrice,
    int? gracePeriodDays,
    int? reminderBeforeExpiryDays,
    bool? autoSuspendExpiredOwners,
    int? minSubscriptionDaysToReview,
    int? defaultAttendanceApprovalWindowMinutes,
    int? maxLeaveDaysPerMonth,
    int? reviewEditTimeLimitMinutes,
    bool? uniqueAmountOffsetEnabled,
    int? verificationTimeoutMinutes,
    bool? autoRetryEnabled,
    int? retryAttempts,
    int? allowedVerificationTimeWindowMinutes,
    bool? pushNotificationsEnabled,
    bool? emailNotificationsEnabled,
    bool? ownerAlertsEnabled,
    bool? adminAlertsEnabled,
    bool? maintenanceBroadcastEnabled,
    int? sessionTimeoutMinutes,
    String? minSupportedAppVersion,
    bool? emergencyPlatformLock,
  }) {
    return GlobalSettingsModel(
      platformName: platformName ?? this.platformName,
      supportEmail: supportEmail ?? this.supportEmail,
      supportPhone: supportPhone ?? this.supportPhone,
      currentAppVersion: currentAppVersion ?? this.currentAppVersion,
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
      allowNewOwnerRegistrations: allowNewOwnerRegistrations ?? this.allowNewOwnerRegistrations,
      allowNewCustomerRegistrations: allowNewCustomerRegistrations ?? this.allowNewCustomerRegistrations,
      defaultMonthlySubscriptionPrice: defaultMonthlySubscriptionPrice ?? this.defaultMonthlySubscriptionPrice,
      defaultYearlySubscriptionPrice: defaultYearlySubscriptionPrice ?? this.defaultYearlySubscriptionPrice,
      gracePeriodDays: gracePeriodDays ?? this.gracePeriodDays,
      reminderBeforeExpiryDays: reminderBeforeExpiryDays ?? this.reminderBeforeExpiryDays,
      autoSuspendExpiredOwners: autoSuspendExpiredOwners ?? this.autoSuspendExpiredOwners,
      minSubscriptionDaysToReview: minSubscriptionDaysToReview ?? this.minSubscriptionDaysToReview,
      defaultAttendanceApprovalWindowMinutes: defaultAttendanceApprovalWindowMinutes ?? this.defaultAttendanceApprovalWindowMinutes,
      maxLeaveDaysPerMonth: maxLeaveDaysPerMonth ?? this.maxLeaveDaysPerMonth,
      reviewEditTimeLimitMinutes: reviewEditTimeLimitMinutes ?? this.reviewEditTimeLimitMinutes,
      uniqueAmountOffsetEnabled: uniqueAmountOffsetEnabled ?? this.uniqueAmountOffsetEnabled,
      verificationTimeoutMinutes: verificationTimeoutMinutes ?? this.verificationTimeoutMinutes,
      autoRetryEnabled: autoRetryEnabled ?? this.autoRetryEnabled,
      retryAttempts: retryAttempts ?? this.retryAttempts,
      allowedVerificationTimeWindowMinutes: allowedVerificationTimeWindowMinutes ?? this.allowedVerificationTimeWindowMinutes,
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      emailNotificationsEnabled: emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      ownerAlertsEnabled: ownerAlertsEnabled ?? this.ownerAlertsEnabled,
      adminAlertsEnabled: adminAlertsEnabled ?? this.adminAlertsEnabled,
      maintenanceBroadcastEnabled: maintenanceBroadcastEnabled ?? this.maintenanceBroadcastEnabled,
      sessionTimeoutMinutes: sessionTimeoutMinutes ?? this.sessionTimeoutMinutes,
      minSupportedAppVersion: minSupportedAppVersion ?? this.minSupportedAppVersion,
      emergencyPlatformLock: emergencyPlatformLock ?? this.emergencyPlatformLock,
    );
  }

  static GlobalSettingsModel get mock {
    return const GlobalSettingsModel(
      platformName: 'Mazi Mess',
      supportEmail: 'support@mazimess.com',
      supportPhone: '+91 98765 43210',
      currentAppVersion: '1.0.0',
      maintenanceMode: false,
      allowNewOwnerRegistrations: true,
      allowNewCustomerRegistrations: true,
      defaultMonthlySubscriptionPrice: 499.0,
      defaultYearlySubscriptionPrice: 4999.0,
      gracePeriodDays: 5,
      reminderBeforeExpiryDays: 3,
      autoSuspendExpiredOwners: true,
      minSubscriptionDaysToReview: 7,
      defaultAttendanceApprovalWindowMinutes: 30,
      maxLeaveDaysPerMonth: 5,
      reviewEditTimeLimitMinutes: 15,
      uniqueAmountOffsetEnabled: true,
      verificationTimeoutMinutes: 10,
      autoRetryEnabled: true,
      retryAttempts: 3,
      allowedVerificationTimeWindowMinutes: 1440,
      pushNotificationsEnabled: true,
      emailNotificationsEnabled: true,
      ownerAlertsEnabled: true,
      adminAlertsEnabled: true,
      maintenanceBroadcastEnabled: false,
      sessionTimeoutMinutes: 60,
      minSupportedAppVersion: '1.0.0',
      emergencyPlatformLock: false,
    );
  }
}
