import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/mess_repository_provider.dart';
import '../../../models/mess_model.dart';
import '../../../models/plan_model.dart';
import '../widgets/plan_card.dart';

class MessDetailsScreen extends ConsumerStatefulWidget {
  const MessDetailsScreen({
    super.key,
    required this.messId,
  });

  final String messId;

  @override
  ConsumerState<MessDetailsScreen> createState() => _MessDetailsScreenState();
}

class _MessDetailsScreenState extends ConsumerState<MessDetailsScreen> {
  late final Future<Mess?> _messFuture;
  late final Future<List<Plan>> _plansFuture;

  @override
  void initState() {
    super.initState();
    final repository = ref.read(messRepositoryProvider);
    _messFuture = repository.getMessById(widget.messId);
    _plansFuture = repository.getPlansByMessId(widget.messId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Mess?>(
      future: _messFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final mess = snapshot.data;
        if (mess == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Mess Details')),
            body: const Center(child: Text('Mess not found')),
          );
        }

        return _MessDetailsContent(
          mess: mess,
          plansFuture: _plansFuture,
        );
      },
    );
  }
}

class _MessDetailsContent extends StatelessWidget {
  const _MessDetailsContent({
    required this.mess,
    required this.plansFuture,
  });

  final Mess mess;
  final Future<List<Plan>> plansFuture;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final galleryImages = [mess.coverImageUrl, ...mess.galleryImages];

    return Scaffold(
      appBar: AppBar(
        title: Text(mess.messName),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 220,
                    child: PageView.builder(
                      itemCount: galleryImages.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          galleryImages[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return ColoredBox(
                              color: colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: 48,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                mess.messName,
                                style: textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            if (mess.verified) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.verified,
                                color: colorScheme.primary,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 20,
                              color: colorScheme.tertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${mess.averageRating.toStringAsFixed(1)} (${mess.totalRatings} reviews)',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                mess.address,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _DetailChip(
                              label: mess.foodType.label,
                              icon: Icons.restaurant_outlined,
                            ),
                            _DetailChip(
                              label: '${mess.distanceKm.toStringAsFixed(1)} km away',
                              icon: Icons.near_me_outlined,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          mess.description,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Plans',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        FutureBuilder<List<Plan>>(
                          future: plansFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final plans = snapshot.data ?? [];
                            if (plans.isEmpty) {
                              return Text(
                                'No plans available',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              );
                            }

                            return Column(
                              children: [
                                for (var i = 0; i < plans.length; i++) ...[
                                  PlanCard(plan: plans[i]),
                                  if (i < plans.length - 1)
                                    const SizedBox(height: 12),
                                ],
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 88),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Join flow coming soon'),
                    ),
                  );
                },
                child: const Text('Join Mess'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
    );
  }
}
