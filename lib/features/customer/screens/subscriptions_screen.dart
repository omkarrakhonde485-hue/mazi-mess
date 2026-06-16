import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/subscription_repository_provider.dart';
import '../../../models/subscription_model.dart';
import '../widgets/subscription_card.dart';

class SubscriptionsScreen extends ConsumerStatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  ConsumerState<SubscriptionsScreen> createState() =>
      _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends ConsumerState<SubscriptionsScreen> {
  late final Future<List<Subscription>> _subscriptionsFuture;

  @override
  void initState() {
    super.initState();
    _subscriptionsFuture =
        ref.read(subscriptionRepositoryProvider).getSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Subscriptions'),
      ),
      body: FutureBuilder<List<Subscription>>(
        future: _subscriptionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Unable to load subscriptions',
                style: textTheme.bodyLarge,
              ),
            );
          }

          final subscriptions = snapshot.data ?? [];
          final active = subscriptions
              .where((subscription) => subscription.status.isActive)
              .toList();
          final expired = subscriptions
              .where((subscription) => !subscription.status.isActive)
              .toList();

          if (subscriptions.isEmpty) {
            return Center(
              child: Text(
                'No subscriptions yet',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _SubscriptionSection(
                  title: 'Active Subscriptions',
                  subscriptions: active,
                  emptyMessage: 'No active subscriptions',
                ),
                const SizedBox(height: 24),
                _SubscriptionSection(
                  title: 'Expired Subscriptions',
                  subscriptions: expired,
                  emptyMessage: 'No expired subscriptions',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SubscriptionSection extends StatelessWidget {
  const _SubscriptionSection({
    required this.title,
    required this.subscriptions,
    required this.emptyMessage,
  });

  final String title;
  final List<Subscription> subscriptions;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        if (subscriptions.isEmpty)
          Text(
            emptyMessage,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          )
        else
          ...subscriptions.map(
            (subscription) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SubscriptionCard(subscription: subscription),
            ),
          ),
      ],
    );
  }
}
