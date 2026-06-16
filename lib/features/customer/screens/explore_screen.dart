import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/mess_repository_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../models/mess_model.dart';
import '../widgets/mess_card.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  late final Future<List<Mess>> _messesFuture;

  @override
  void initState() {
    super.initState();
    _messesFuture = ref.read(messRepositoryProvider).getMesses();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Messes'),
        actions: [
          IconButton(
            tooltip: 'Home',
            icon: const Icon(Icons.home_outlined),
            onPressed: () => context.push(AppRoute.home.path),
          ),
          IconButton(
            tooltip: 'Subscriptions',
            icon: const Icon(Icons.card_membership_outlined),
            onPressed: () => context.push(AppRoute.subscriptions.path),
          ),
          IconButton(
            tooltip: 'Profile',
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push(AppRoute.profile.path),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search messes...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Mess>>(
                future: _messesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Unable to load messes',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  }

                  final messes = snapshot.data ?? [];
                  if (messes.isEmpty) {
                    return Center(
                      child: Text(
                        'No messes found',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    itemCount: messes.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final mess = messes[index];
                      return MessCard(
                        mess: mess,
                        onTap: () => context.push(
                          AppRoute.messDetails.pathForMess(mess.messId),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
