import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/mock_data/fake_home_state.dart';
import '../../../core/mock_data/fake_notices.dart';
import '../../../core/providers/subscription_repository_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../models/subscription_model.dart';
import '../widgets/notice_card.dart';
import '../widgets/quick_action_card.dart';

class CustomerHomeScreen extends ConsumerStatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  ConsumerState<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends ConsumerState<CustomerHomeScreen> {
  late final Future<List<Subscription>> _subscriptionsFuture;

  @override
  void initState() {
    super.initState();
    _subscriptionsFuture =
        ref.read(subscriptionRepositoryProvider).getSubscriptions();
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: 'Explore',
            icon: const Icon(Icons.explore_outlined),
            onPressed: () => context.push(AppRoute.explore.path),
          ),
        ],
      ),
      body: FutureBuilder<List<Subscription>>(
        future: _subscriptionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final subscriptions = snapshot.data ?? [];
          final activeSubscriptions =
              subscriptions.where((s) => s.status.isActive).toList();
          final currentSubscription =
              activeSubscriptions.isEmpty ? null : activeSubscriptions.first;

          final qrStatus = currentSubscription == null
              ? QrStatus.noActiveSubscription
              : fakeHomeQrStatus;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _CurrentSubscriptionCard(
                    subscription: currentSubscription,
                  ),
                  const SizedBox(height: 16),
                  _QrStatusCard(status: qrStatus),
                  const SizedBox(height: 24),
                  _SectionHeader(title: 'Latest Notices'),
                  const SizedBox(height: 12),
                  ...fakeNotices.map(
                    (notice) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: NoticeCard(notice: notice),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SectionHeader(title: 'Quick Actions'),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.1,
                    children: [
                      QuickActionCard(
                        icon: Icons.card_membership_outlined,
                        label: 'Subscriptions',
                        onTap: () =>
                            context.push(AppRoute.subscriptions.path),
                      ),
                      QuickActionCard(
                        icon: Icons.event_busy_outlined,
                        label: 'Leave Management',
                        onTap: () =>
                            context.push(AppRoute.leaveManagement.path),
                      ),
                      QuickActionCard(
                        icon: Icons.receipt_long_outlined,
                        label: 'Payment History',
                        onTap: () => _showComingSoon('Payment History'),
                      ),
                      QuickActionCard(
                        icon: Icons.person_outline,
                        label: 'Profile',
                        onTap: () => context.push(AppRoute.profile.path),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _CurrentSubscriptionCard extends StatelessWidget {
  const _CurrentSubscriptionCard({required this.subscription});

  final Subscription? subscription;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Subscription',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            if (subscription == null)
              Text(
                'No active subscription',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              )
            else ...[
              _InfoRow(
                icon: Icons.storefront_outlined,
                label: 'Mess',
                value: subscription!.messName,
              ),
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.restaurant_menu_outlined,
                label: 'Plan',
                value: subscription!.planName,
              ),
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.timelapse_outlined,
                label: 'Days remaining',
                value: '${subscription!.daysRemaining} days',
                valueColor: colorScheme.primary,
              ),
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.info_outline,
                label: 'Status',
                value: subscription!.status.label,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _QrStatusCard extends StatelessWidget {
  const _QrStatusCard({required this.status});

  final QrStatus status;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final containerColor = switch (status) {
      QrStatus.qrAvailable => colorScheme.primaryContainer,
      QrStatus.alreadyUsed => colorScheme.secondaryContainer,
      QrStatus.leaveDay => colorScheme.tertiaryContainer,
      QrStatus.noActiveSubscription => colorScheme.surfaceContainerHighest,
    };
    final foregroundColor = switch (status) {
      QrStatus.qrAvailable => colorScheme.onPrimaryContainer,
      QrStatus.alreadyUsed => colorScheme.onSecondaryContainer,
      QrStatus.leaveDay => colorScheme.onTertiaryContainer,
      QrStatus.noActiveSubscription => colorScheme.onSurfaceVariant,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                status.icon,
                size: 32,
                color: foregroundColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's QR Status",
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status.label,
                    style: textTheme.bodyLarge?.copyWith(
                      color: foregroundColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}
