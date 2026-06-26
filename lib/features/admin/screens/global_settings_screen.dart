import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/global_settings_model.dart';
import '../widgets/settings_section_card.dart';
import '../widgets/settings_tile.dart';

class GlobalSettingsScreen extends StatefulWidget {
  const GlobalSettingsScreen({super.key});

  @override
  State<GlobalSettingsScreen> createState() => _GlobalSettingsScreenState();
}

class _GlobalSettingsScreenState extends State<GlobalSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late GlobalSettingsModel _settings;
  bool _isSaving = false;

  // Controllers for text/numeric inputs
  late TextEditingController _platformNameController;
  late TextEditingController _supportEmailController;
  late TextEditingController _supportPhoneController;
  late TextEditingController _currentVersionController;
  late TextEditingController _minSupportedVersionController;

  late TextEditingController _monthlyPriceController;
  late TextEditingController _yearlyPriceController;
  late TextEditingController _gracePeriodController;
  late TextEditingController _reminderBeforeController;

  late TextEditingController _minSubDaysToReviewController;
  late TextEditingController _attendanceApprovalWindowController;
  late TextEditingController _maxLeaveDaysController;
  late TextEditingController _reviewEditTimeLimitController;

  late TextEditingController _verificationTimeoutController;
  late TextEditingController _retryAttemptsController;
  late TextEditingController _allowedTimeWindowController;
  late TextEditingController _sessionTimeoutController;

  @override
  void initState() {
    super.initState();
    _settings = GlobalSettingsModel.mock;

    // Initialize text controllers
    _platformNameController = TextEditingController(text: _settings.platformName);
    _supportEmailController = TextEditingController(text: _settings.supportEmail);
    _supportPhoneController = TextEditingController(text: _settings.supportPhone);
    _currentVersionController = TextEditingController(text: _settings.currentAppVersion);
    _minSupportedVersionController = TextEditingController(text: _settings.minSupportedAppVersion);

    _monthlyPriceController = TextEditingController(text: _settings.defaultMonthlySubscriptionPrice.toStringAsFixed(0));
    _yearlyPriceController = TextEditingController(text: _settings.defaultYearlySubscriptionPrice.toStringAsFixed(0));
    _gracePeriodController = TextEditingController(text: _settings.gracePeriodDays.toString());
    _reminderBeforeController = TextEditingController(text: _settings.reminderBeforeExpiryDays.toString());

    _minSubDaysToReviewController = TextEditingController(text: _settings.minSubscriptionDaysToReview.toString());
    _attendanceApprovalWindowController = TextEditingController(text: _settings.defaultAttendanceApprovalWindowMinutes.toString());
    _maxLeaveDaysController = TextEditingController(text: _settings.maxLeaveDaysPerMonth.toString());
    _reviewEditTimeLimitController = TextEditingController(text: _settings.reviewEditTimeLimitMinutes.toString());

    _verificationTimeoutController = TextEditingController(text: _settings.verificationTimeoutMinutes.toString());
    _retryAttemptsController = TextEditingController(text: _settings.retryAttempts.toString());
    _allowedTimeWindowController = TextEditingController(text: _settings.allowedVerificationTimeWindowMinutes.toString());
    _sessionTimeoutController = TextEditingController(text: _settings.sessionTimeoutMinutes.toString());
  }

  @override
  void dispose() {
    _platformNameController.dispose();
    _supportEmailController.dispose();
    _supportPhoneController.dispose();
    _currentVersionController.dispose();
    _minSupportedVersionController.dispose();
    _monthlyPriceController.dispose();
    _yearlyPriceController.dispose();
    _gracePeriodController.dispose();
    _reminderBeforeController.dispose();
    _minSubDaysToReviewController.dispose();
    _attendanceApprovalWindowController.dispose();
    _maxLeaveDaysController.dispose();
    _reviewEditTimeLimitController.dispose();
    _verificationTimeoutController.dispose();
    _retryAttemptsController.dispose();
    _allowedTimeWindowController.dispose();
    _sessionTimeoutController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSaving = true;
      });

      // Simulating network delay
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        setState(() {
          _isSaving = false;
          _settings = _settings.copyWith(
            platformName: _platformNameController.text,
            supportEmail: _supportEmailController.text,
            supportPhone: _supportPhoneController.text,
            currentAppVersion: _currentVersionController.text,
            minSupportedAppVersion: _minSupportedVersionController.text,
            defaultMonthlySubscriptionPrice: double.tryParse(_monthlyPriceController.text) ?? _settings.defaultMonthlySubscriptionPrice,
            defaultYearlySubscriptionPrice: double.tryParse(_yearlyPriceController.text) ?? _settings.defaultYearlySubscriptionPrice,
            gracePeriodDays: int.tryParse(_gracePeriodController.text) ?? _settings.gracePeriodDays,
            reminderBeforeExpiryDays: int.tryParse(_reminderBeforeController.text) ?? _settings.reminderBeforeExpiryDays,
            minSubscriptionDaysToReview: int.tryParse(_minSubDaysToReviewController.text) ?? _settings.minSubscriptionDaysToReview,
            defaultAttendanceApprovalWindowMinutes: int.tryParse(_attendanceApprovalWindowController.text) ?? _settings.defaultAttendanceApprovalWindowMinutes,
            maxLeaveDaysPerMonth: int.tryParse(_maxLeaveDaysController.text) ?? _settings.maxLeaveDaysPerMonth,
            reviewEditTimeLimitMinutes: int.tryParse(_reviewEditTimeLimitController.text) ?? _settings.reviewEditTimeLimitMinutes,
            verificationTimeoutMinutes: int.tryParse(_verificationTimeoutController.text) ?? _settings.verificationTimeoutMinutes,
            retryAttempts: int.tryParse(_retryAttemptsController.text) ?? _settings.retryAttempts,
            allowedVerificationTimeWindowMinutes: int.tryParse(_allowedTimeWindowController.text) ?? _settings.allowedVerificationTimeWindowMinutes,
            sessionTimeoutMinutes: int.tryParse(_sessionTimeoutController.text) ?? _settings.sessionTimeoutMinutes,
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: 8),
                Text('Platform configurations updated successfully for ${_settings.platformName}!'),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
    }
  }

  void _showPolicyDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Text(
              content,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Dismiss'),
            ),
          ],
        );
      },
    );
  }

  void _triggerForceLogout() {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: colorScheme.error),
              const SizedBox(width: 8),
              const Text('Force Logout All Users?'),
            ],
          ),
          content: const Text(
            'This security action will invalidate all active login sessions for owners and customers. '
            'Admins are exempt. Users will be required to authenticate again on their next request. '
            'Do you wish to proceed?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('All active sessions invalidated. Force logout broadcast issued.'),
                    backgroundColor: colorScheme.error,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Force Logout'),
            ),
          ],
        );
      },
    );
  }

  void _toggleEmergencyLock(bool val) {
    if (val) {
      showDialog(
        context: context,
        builder: (context) {
          final theme = Theme.of(context);
          final colorScheme = theme.colorScheme;
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.gavel_rounded, color: colorScheme.error),
                const SizedBox(width: 8),
                const Text('Emergency Lockout?'),
              ],
            ),
            content: const Text(
              'WARNING: Enabling Emergency Platform Lock will instantly block all APIs, '
              'shutting down customer, owner, and delivery operations immediately. '
              'Only platform system administrators can override this lock.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                ),
                onPressed: () {
                  setState(() {
                    _settings = _settings.copyWith(emergencyPlatformLock: true);
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('EMERGENCY LOCKOUT ENGAGED. Platform is now offline.'),
                      backgroundColor: colorScheme.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text('Engage Lock'),
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        _settings = _settings.copyWith(emergencyPlatformLock: false);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Emergency lockout disengaged. Services resumed.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Global Settings',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
            Text(
              'Platform-wide parameters & security controls',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: _isSaving
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : FilledButton.icon(
                    onPressed: _saveSettings,
                    icon: const Icon(Icons.save_rounded, size: 16),
                    label: const Text('Save Changes'),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: isDesktop ? _buildResponsiveGrid() : _buildSingleColumnList(),
            ),
          ),
        ),
      ),
    );
  }

  // Dual column layout for wide screens (Tablet, Desktop, Web)
  Widget _buildResponsiveGrid() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPlatformSettingsCard(),
              _buildOwnerSubscriptionSettingsCard(),
              _buildPaymentVerificationCard(),
              _buildSecurityCard(),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildRegistrationControlCard(),
              _buildCustomerRulesCard(),
              _buildNotificationSettingsCard(),
              _buildPlatformPoliciesCard(),
              _buildFooterCard(),
            ],
          ),
        ),
      ],
    );
  }

  // Single column layout for mobile screens
  Widget _buildSingleColumnList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPlatformSettingsCard(),
        _buildRegistrationControlCard(),
        _buildOwnerSubscriptionSettingsCard(),
        _buildCustomerRulesCard(),
        _buildPaymentVerificationCard(),
        _buildNotificationSettingsCard(),
        _buildPlatformPoliciesCard(),
        _buildSecurityCard(),
        _buildFooterCard(),
      ],
    );
  }

  // SECTION 1: PLATFORM SETTINGS CARD
  Widget _buildPlatformSettingsCard() {
    return SettingsSectionCard(
      title: 'Platform Settings',
      icon: Icons.dns_rounded,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              _buildTextField(
                controller: _platformNameController,
                labelText: 'Platform Name',
                icon: Icons.business_rounded,
                validator: (val) => val == null || val.isEmpty ? 'Platform name required' : null,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _supportEmailController,
                labelText: 'Support Email Address',
                icon: Icons.email_rounded,
                keyboardType: TextInputType.emailAddress,
                validator: (val) => val == null || !val.contains('@') ? 'Enter a valid email' : null,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _supportPhoneController,
                labelText: 'Support Phone Line',
                icon: Icons.phone_rounded,
                keyboardType: TextInputType.phone,
                validator: (val) => val == null || val.isEmpty ? 'Support phone required' : null,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _currentVersionController,
                labelText: 'Platform App Version',
                icon: Icons.info_outline_rounded,
                validator: (val) => val == null || val.isEmpty ? 'App version required' : null,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        const Divider(height: 24),
        SettingsTile(
          title: 'Maintenance Mode',
          subtitle: 'Renders system unavailable to Customers. Admins and Owners retain platform access.',
          leadingIcon: Icons.handyman_rounded,
          leadingIconColor: Colors.amber.shade800,
          trailing: Switch.adaptive(
            value: _settings.maintenanceMode,
            onChanged: (val) {
              setState(() {
                _settings = _settings.copyWith(maintenanceMode: val);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Maintenance Mode ${val ? "Activated" : "Deactivated"}'),
                  backgroundColor: val ? Colors.amber.shade900 : Colors.green.shade800,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.security, color: Theme.of(context).colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Rule: Maintenance is bypass-authorized for owners & admins to keep backend operational.',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  // SECTION 2: REGISTRATION CONTROL CARD
  Widget _buildRegistrationControlCard() {
    return SettingsSectionCard(
      title: 'Registration Control',
      icon: Icons.how_to_reg_rounded,
      children: [
        SettingsTile(
          title: 'Allow New Owner Registrations',
          subtitle: 'When turned off, new mess owners are blocked from signing up.',
          leadingIcon: Icons.storefront_rounded,
          trailing: Switch.adaptive(
            value: _settings.allowNewOwnerRegistrations,
            onChanged: (val) {
              setState(() {
                _settings = _settings.copyWith(allowNewOwnerRegistrations: val);
              });
            },
          ),
        ),
        const Divider(indent: 12, endIndent: 12),
        SettingsTile(
          title: 'Allow New Customer Registrations',
          subtitle: 'When turned off, new students/customers cannot register an account.',
          leadingIcon: Icons.people_outline_rounded,
          trailing: Switch.adaptive(
            value: _settings.allowNewCustomerRegistrations,
            onChanged: (val) {
              setState(() {
                _settings = _settings.copyWith(allowNewCustomerRegistrations: val);
              });
            },
          ),
        ),
      ],
    );
  }

  // SECTION 3: OWNER SUBSCRIPTION SETTINGS CARD
  Widget _buildOwnerSubscriptionSettingsCard() {
    return SettingsSectionCard(
      title: 'Owner Subscription Settings',
      icon: Icons.card_membership_rounded,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _monthlyPriceController,
                      labelText: 'Monthly Price (₹)',
                      icon: Icons.currency_rupee_rounded,
                      keyboardType: TextInputType.number,
                      validator: (val) => val == null || double.tryParse(val) == null ? 'Invalid price' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _yearlyPriceController,
                      labelText: 'Yearly Price (₹)',
                      icon: Icons.currency_rupee_rounded,
                      keyboardType: TextInputType.number,
                      validator: (val) => val == null || double.tryParse(val) == null ? 'Invalid price' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _gracePeriodController,
                      labelText: 'Grace Period (Days)',
                      icon: Icons.timelapse_rounded,
                      keyboardType: TextInputType.number,
                      validator: (val) => val == null || int.tryParse(val) == null ? 'Enter whole number' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _reminderBeforeController,
                      labelText: 'Expiry Notification (Days)',
                      icon: Icons.calendar_today_rounded,
                      keyboardType: TextInputType.number,
                      validator: (val) => val == null || int.tryParse(val) == null ? 'Enter whole number' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        const Divider(height: 24),
        SettingsTile(
          title: 'Auto Suspend Expired Owners',
          subtitle: 'Instantly suspends owner console and locks public mess page upon subscription lapse.',
          leadingIcon: Icons.auto_delete_rounded,
          leadingIconColor: Colors.red.shade800,
          trailing: Switch.adaptive(
            value: _settings.autoSuspendExpiredOwners,
            onChanged: (val) {
              setState(() {
                _settings = _settings.copyWith(autoSuspendExpiredOwners: val);
              });
            },
          ),
        ),
      ],
    );
  }

  // SECTION 4: CUSTOMER RULES CARD
  Widget _buildCustomerRulesCard() {
    return SettingsSectionCard(
      title: 'Customer Rules',
      icon: Icons.gavel_rounded,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              const SizedBox(height: 8),
              _buildTextField(
                controller: _minSubDaysToReviewController,
                labelText: 'Minimum Active Days Required to Review',
                icon: Icons.rate_review_rounded,
                keyboardType: TextInputType.number,
                validator: (val) => val == null || int.tryParse(val) == null ? 'Enter whole number' : null,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _attendanceApprovalWindowController,
                labelText: 'Default Attendance Window (Minutes)',
                icon: Icons.access_time_rounded,
                keyboardType: TextInputType.number,
                validator: (val) => val == null || int.tryParse(val) == null ? 'Enter minutes' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _maxLeaveDaysController,
                      labelText: 'Max Leave Days/Month',
                      icon: Icons.beach_access_rounded,
                      keyboardType: TextInputType.number,
                      validator: (val) => val == null || int.tryParse(val) == null ? 'Enter number' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _reviewEditTimeLimitController,
                      labelText: 'Review Edit Limit (Mins)',
                      icon: Icons.edit_attributes_rounded,
                      keyboardType: TextInputType.number,
                      validator: (val) => val == null || int.tryParse(val) == null ? 'Enter minutes' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  // SECTION 5: PAYMENT VERIFICATION CARD
  Widget _buildPaymentVerificationCard() {
    return SettingsSectionCard(
      title: 'Payment Verification Settings',
      icon: Icons.verified_user_rounded,
      children: [
        SettingsTile(
          title: 'Unique Amount Offset',
          subtitle: 'Applies minor fractions to subscription rates to facilitate matching bank receipts.',
          leadingIcon: Icons.price_change_rounded,
          trailing: Switch.adaptive(
            value: _settings.uniqueAmountOffsetEnabled,
            onChanged: (val) {
              setState(() {
                _settings = _settings.copyWith(uniqueAmountOffsetEnabled: val);
              });
            },
          ),
        ),
        const Divider(indent: 12, endIndent: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Column(
            children: [
              _buildTextField(
                controller: _verificationTimeoutController,
                labelText: 'Verification Timeout (Minutes)',
                icon: Icons.hourglass_bottom_rounded,
                keyboardType: TextInputType.number,
                validator: (val) => val == null || int.tryParse(val) == null ? 'Enter minutes' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildTextField(
                      controller: _retryAttemptsController,
                      labelText: 'Verification Retry Attempts',
                      icon: Icons.replay_rounded,
                      keyboardType: TextInputType.number,
                      validator: (val) => val == null || int.tryParse(val) == null ? 'Enter attempts' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 4,
                    child: _buildTextField(
                      controller: _allowedTimeWindowController,
                      labelText: 'Allowed Check Window (Mins)',
                      icon: Icons.calendar_view_day_rounded,
                      keyboardType: TextInputType.number,
                      validator: (val) => val == null || int.tryParse(val) == null ? 'Enter window' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        SettingsTile(
          title: 'Auto Retry Verification',
          subtitle: 'System automatically attempts secondary bank lookups if first attempt is inconclusive.',
          leadingIcon: Icons.sync_problem_rounded,
          trailing: Switch.adaptive(
            value: _settings.autoRetryEnabled,
            onChanged: (val) {
              setState(() {
                _settings = _settings.copyWith(autoRetryEnabled: val);
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50.withValues(alpha: 0.5),
              border: Border.all(color: Colors.amber.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_rounded, color: Colors.amber.shade900, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Notice: Outbound Webhook parameters and API keys are isolated in the Webhook Management panel to preserve vault security.',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.brown),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  // SECTION 6: NOTIFICATION SETTINGS CARD
  Widget _buildNotificationSettingsCard() {
    return SettingsSectionCard(
      title: 'Notification Routing Rules',
      icon: Icons.notifications_active_rounded,
      children: [
        SettingsTile(
          title: 'Push Notifications',
          subtitle: 'Route critical real-time triggers to Android/iOS users.',
          leadingIcon: Icons.app_settings_alt_rounded,
          trailing: Switch.adaptive(
            value: _settings.pushNotificationsEnabled,
            onChanged: (val) {
              setState(() {
                _settings = _settings.copyWith(pushNotificationsEnabled: val);
              });
            },
          ),
        ),
        const Divider(indent: 12, endIndent: 12),
        SettingsTile(
          title: 'Email Notifications',
          subtitle: 'Dispatch transactional receipts and weekly summaries via support pipeline.',
          leadingIcon: Icons.alternate_email_rounded,
          trailing: Switch.adaptive(
            value: _settings.emailNotificationsEnabled,
            onChanged: (val) {
              setState(() {
                _settings = _settings.copyWith(emailNotificationsEnabled: val);
              });
            },
          ),
        ),
        const Divider(indent: 12, endIndent: 12),
        SettingsTile(
          title: 'Owner Alerts',
          subtitle: 'Broadcast platform policy, pricing shifts, or billing adjustments to owners.',
          leadingIcon: Icons.campaign_rounded,
          trailing: Switch.adaptive(
            value: _settings.ownerAlertsEnabled,
            onChanged: (val) {
              setState(() {
                _settings = _settings.copyWith(ownerAlertsEnabled: val);
              });
            },
          ),
        ),
        const Divider(indent: 12, endIndent: 12),
        SettingsTile(
          title: 'Admin Alerts',
          subtitle: 'Dispatch email logs for registration surges or payment system latency.',
          leadingIcon: Icons.admin_panel_settings_rounded,
          trailing: Switch.adaptive(
            value: _settings.adminAlertsEnabled,
            onChanged: (val) {
              setState(() {
                _settings = _settings.copyWith(adminAlertsEnabled: val);
              });
            },
          ),
        ),
        const Divider(indent: 12, endIndent: 12),
        SettingsTile(
          title: 'Maintenance Broadcast',
          subtitle: 'Push immediate notification regarding Scheduled System Downtime to active nodes.',
          leadingIcon: Icons.contact_mail_rounded,
          trailing: Switch.adaptive(
            value: _settings.maintenanceBroadcastEnabled,
            onChanged: (val) {
              setState(() {
                _settings = _settings.copyWith(maintenanceBroadcastEnabled: val);
              });
            },
          ),
        ),
      ],
    );
  }

  // SECTION 7: PLATFORM POLICIES CARD
  Widget _buildPlatformPoliciesCard() {
    return SettingsSectionCard(
      title: 'Platform Legal Policies',
      icon: Icons.policy_rounded,
      children: [
        SettingsTile(
          title: 'Privacy Policy',
          subtitle: 'Review personal information handling guidelines and student security compliance.',
          leadingIcon: Icons.privacy_tip_rounded,
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
          onTap: () => _showPolicyDialog(
            'Privacy Policy',
            'This Privacy Policy describes our guidelines on the collection, usage, and security of student, customer, and owner profiles. '
            'We strictly keep user logins and transactional receipt references safe. Under no scenario do we share private database entries with third-party vendors. '
            '\n\nLast updated: June 2026.',
          ),
        ),
        const Divider(indent: 12, endIndent: 12),
        SettingsTile(
          title: 'Terms & Conditions',
          subtitle: 'Platform utility licensing terms, subscription agreement rules, and user conduct.',
          leadingIcon: Icons.gavel_rounded,
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
          onTap: () => _showPolicyDialog(
            'Terms & Conditions',
            'Welcome to Mazi Mess. By deploying this SaaS utility or registering an account, you agree to respect the billing timelines, '
            'subscription models, and attendance validation structures. Abuse of unique amount offsets or spoofing payment credentials will result in instant account ban.'
            '\n\nLast updated: June 2026.',
          ),
        ),
        const Divider(indent: 12, endIndent: 12),
        SettingsTile(
          title: 'Refund Policy',
          subtitle: 'Dispute timelines and subscription cancellations guidelines for owners.',
          leadingIcon: Icons.money_off_rounded,
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
          onTap: () => _showPolicyDialog(
            'Refund Policy',
            'Owner subscription billing operates on pre-paid cycles. Refunds are authorized exclusively within a 7-day grace window starting from subscription date. '
            'Customer food subscriptions are managed under individual mess refund clauses; Mazi Mess operates strictly as a platform coordinator.',
          ),
        ),
        const Divider(indent: 12, endIndent: 12),
        SettingsTile(
          title: 'About Mazi Mess',
          subtitle: 'Platform overview, technical dependencies, and developer attributes.',
          leadingIcon: Icons.help_outline_rounded,
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
          onTap: () => _showPolicyDialog(
            'About Mazi Mess',
            'Mazi Mess represents a comprehensive, cloud-native mess coordination and payment verification framework. '
            'Designed to bridge local kitchen operators with active university student clusters, maximizing attendance efficiency and subscription tracking. '
            '\n\nDeveloped with precision by Omkar Rakhonde.',
          ),
        ),
      ],
    );
  }

  // SECTION 8: SECURITY CARD
  Widget _buildSecurityCard() {
    return SettingsSectionCard(
      title: 'Security & Integrity',
      icon: Icons.security_rounded,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Invalidate All Active Sessions',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Terminates all customer and owner logins immediately.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                  foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                  elevation: 0,
                ),
                onPressed: _triggerForceLogout,
                icon: const Icon(Icons.logout_rounded, size: 16),
                label: const Text('Force Logout'),
              ),
            ],
          ),
        ),
        const Divider(indent: 12, endIndent: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              const SizedBox(height: 8),
              _buildTextField(
                controller: _sessionTimeoutController,
                labelText: 'Session Expiry (Minutes)',
                icon: Icons.timer_rounded,
                keyboardType: TextInputType.number,
                validator: (val) => val == null || int.tryParse(val) == null ? 'Enter minutes' : null,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _minSupportedVersionController,
                labelText: 'Minimum Supported App Version',
                icon: Icons.system_update_rounded,
                validator: (val) => val == null || val.isEmpty ? 'Version label required' : null,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        const Divider(height: 24),
        SettingsTile(
          title: 'Emergency Platform Lock',
          subtitle: 'Instantly lock out all API entrypoints and disable platform interactions.',
          leadingIcon: Icons.lock_reset_rounded,
          leadingIconColor: Colors.red.shade900,
          trailing: Switch.adaptive(
            value: _settings.emergencyPlatformLock,
            onChanged: _toggleEmergencyLock,
            activeColor: Colors.red.shade900,
          ),
        ),
      ],
    );
  }

  // FOOTER CARD
  Widget _buildFooterCard() {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.restaurant_menu_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Mazi Mess',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Version 1.0.0 • Build: Frontend MVP',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Developed by ',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  'Omkar Rakhonde',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '© 2026 Mazi Mess. All administrative rights reserved.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // Beautiful reusable TextFormField generator
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, size: 18),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}
