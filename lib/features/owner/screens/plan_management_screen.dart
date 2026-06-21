import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/plan_card.dart';
import '../widgets/delete_plan_dialog.dart';

class Plan {
  final String id;
  final String name;
  final String description;
  final double price;
  final int durationDays;
  final bool hasBreakfast;
  final bool hasLunch;
  final bool hasDinner;
  final String? customNote;
  final bool isActive;
  final int subscriberCount;

  Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationDays,
    required this.hasBreakfast,
    required this.hasLunch,
    required this.hasDinner,
    this.customNote,
    required this.isActive,
    required this.subscriberCount,
  });

  Plan copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? durationDays,
    bool? hasBreakfast,
    bool? hasLunch,
    bool? hasDinner,
    String? customNote,
    bool? isActive,
    int? subscriberCount,
  }) {
    return Plan(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      durationDays: durationDays ?? this.durationDays,
      hasBreakfast: hasBreakfast ?? this.hasBreakfast,
      hasLunch: hasLunch ?? this.hasLunch,
      hasDinner: hasDinner ?? this.hasDinner,
      customNote: customNote ?? this.customNote,
      isActive: isActive ?? this.isActive,
      subscriberCount: subscriberCount ?? this.subscriberCount,
    );
  }
}

class PlanManagementScreen extends StatefulWidget {
  const PlanManagementScreen({super.key});

  @override
  State<PlanManagementScreen> createState() => _PlanManagementScreenState();
}

class _PlanManagementScreenState extends State<PlanManagementScreen> {
  // 1. STATEFUL MOCK DATA STORE
  final List<Plan> _plans = [
    Plan(
      id: 'plan_1',
      name: 'Standard Unlimited Plan',
      description: 'Your wholesome daily choice covering premium home-cooked meals.',
      price: 3200,
      durationDays: 30,
      hasBreakfast: true,
      hasLunch: true,
      hasDinner: true,
      customNote: 'Festival Holidays Applicable',
      isActive: true,
      subscriberCount: 42,
    ),
    Plan(
      id: 'plan_2',
      name: 'Lunch + Dinner Special',
      description: 'Perfect package for working professional people or college students.',
      price: 2500,
      durationDays: 30,
      hasBreakfast: false,
      hasLunch: true,
      hasDinner: true,
      customNote: 'Sunday Dinner Off',
      isActive: true,
      subscriberCount: 28,
    ),
    Plan(
      id: 'plan_3',
      name: 'Lunch Only Combo',
      description: 'Healthy and portion-controlled lunch directly delivered to key workspaces.',
      price: 1500,
      durationDays: 30,
      hasBreakfast: false,
      hasLunch: true,
      hasDinner: false,
      customNote: 'No Lunch on Saturday & Sunday',
      isActive: true,
      subscriberCount: 15,
    ),
    Plan(
      id: 'plan_4',
      name: 'Breakfast Only Pack',
      description: 'Quick early morning breakfast to boost up energy levels.',
      price: 800,
      durationDays: 30,
      hasBreakfast: true,
      hasLunch: false,
      hasDinner: false,
      customNote: 'Sunday Closed',
      isActive: false,
      subscriberCount: 0,
    ),
  ];

  String _searchQuery = '';
  String _selectedFilter = 'All'; // 'All', 'Active', 'Inactive'

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Filter calculations
    final totalPlans = _plans.length;
    final activePlans = _plans.where((p) => p.isActive).length;
    final inactivePlans = _plans.where((p) => !p.isActive).length;
    final totalSubscribers = _plans.where((p) => p.isActive).fold<int>(0, (sum, p) => sum + p.subscriberCount);

    // List filtration
    final filteredPlans = _plans.where((plan) {
      final matchesSearch = plan.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedFilter == 'All' ||
          (_selectedFilter == 'Active' && plan.isActive) ||
          (_selectedFilter == 'Inactive' && !plan.isActive);
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Manage Plans'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create Plan',
            onPressed: () => _navigateToForm(null),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 2. STATISTICS HEADER CARD BLOCK
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DashboardStatCard(
                          title: 'Total Plans',
                          value: '$totalPlans',
                          icon: Icons.restaurant_menu,
                          backgroundColor: colorScheme.surfaceContainerLow,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DashboardStatCard(
                          title: 'Active Plans',
                          value: '$activePlans',
                          icon: Icons.check_circle_outline,
                          iconColor: Colors.green,
                          backgroundColor: colorScheme.surfaceContainerLow,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DashboardStatCard(
                          title: 'Inactive Plans',
                          value: '$inactivePlans',
                          icon: Icons.block_flipped,
                          iconColor: Colors.redAccent,
                          backgroundColor: colorScheme.surfaceContainerLow,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DashboardStatCard(
                          title: 'Total Subscribers',
                          value: '$totalSubscribers',
                          icon: Icons.group_outlined,
                          iconColor: colorScheme.primary,
                          backgroundColor: colorScheme.surfaceContainerLow,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 3. FILTER & SEARCH BLOCK
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Search Field
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by plan name...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest.withAlpha(120),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  // Filter chip row
                  Row(
                    children: [
                      _FilterChip(
                        label: 'All',
                        isSelected: _selectedFilter == 'All',
                        onSelected: () => setState(() => _selectedFilter = 'All'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Active',
                        isSelected: _selectedFilter == 'Active',
                        onSelected: () => setState(() => _selectedFilter = 'Active'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Inactive',
                        isSelected: _selectedFilter == 'Inactive',
                        onSelected: () => setState(() => _selectedFilter = 'Inactive'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // 4. PLAN CARD GRID / SEQUENCE list
          if (filteredPlans.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.no_meals_outlined,
                      size: 64,
                      color: colorScheme.onSurfaceVariant.withAlpha(120),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No subscription plans found',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Try tweaking search query or filters',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withAlpha(180),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final plan = filteredPlans[index];
                    return PlanCard(
                      plan: plan,
                      onView: () => _viewPlanDetails(plan),
                      onEdit: () => _navigateToForm(plan),
                      onToggleStatus: () => _togglePlanStatus(plan),
                      onDelete: () => _handleDeletePlan(plan),
                    );
                  },
                  childCount: filteredPlans.length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(null),
        tooltip: 'Create New Plan',
        child: const Icon(Icons.add),
      ),
    );
  }

  // --- ACTIONS LOGIC ---

  void _viewPlanDetails(Plan plan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final textTheme = theme.textTheme;

        final meals = <String>[];
        if (plan.hasBreakfast) meals.add('Breakfast');
        if (plan.hasLunch) meals.add('Lunch');
        if (plan.hasDinner) meals.add('Dinner');

        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.85,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 48,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          plan.name,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: plan.isActive ? Colors.green.withAlpha(20) : Colors.grey.withAlpha(20),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          plan.isActive ? 'Active' : 'Inactive',
                          style: textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: plan.isActive ? Colors.green : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    plan.description.isNotEmpty ? plan.description : 'No description provided.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Info cards grid or detail boxes
                  Row(
                    children: [
                      Expanded(
                        child: _DetailBox(
                          label: 'Price',
                          value: '₹${plan.price.toStringAsFixed(0)}',
                          subtitle: 'Inc. Taxes',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DetailBox(
                          label: 'Validity',
                          value: '${plan.durationDays} Days',
                          subtitle: 'Duration period',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _DetailBox(
                          label: 'Subscriber Count',
                          value: plan.isActive ? '${plan.subscriberCount}' : 'N/A',
                          subtitle: plan.isActive ? 'Active Customers' : 'Inactive Plan',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DetailBox(
                          label: 'Configured Meals',
                          value: meals.isEmpty ? 'None' : '${meals.length} Meals',
                          subtitle: meals.isEmpty ? 'No meal types' : meals.join(', '),
                        ),
                      ),
                    ],
                  ),

                  if (plan.customNote != null && plan.customNote!.trim().isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      'Term / Custom Note',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.outlineVariant,
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        plan.customNote!,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],

                  if (!plan.isActive) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber.withAlpha(60)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'This package plan is deactivated. Safe Mode ensures existing customers can continue until natural expiry, but no new subscriptions are accepted.',
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.amber[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToForm(Plan? plan) async {
    final result = await context.push<Plan>(AppRoute.planForm.path, extra: plan);
    if (result != null) {
      setState(() {
        if (plan == null) {
          // Add new plan
          _plans.add(result);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Subscription Plan "${result.name}" created successfully!')),
          );
        } else {
          // Edit existing
          final idx = _plans.indexWhere((p) => p.id == plan.id);
          if (idx != -1) {
            _plans[idx] = result;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Plan "${result.name}" updated successfully!')),
            );
          }
        }
      });
    }
  }

  void _togglePlanStatus(Plan plan) {
    setState(() {
      final idx = _plans.indexWhere((p) => p.id == plan.id);
      if (idx != -1) {
        final currentActivity = _plans[idx].isActive;
        _plans[idx] = _plans[idx].copyWith(isActive: !currentActivity);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              currentActivity
                  ? 'Plan deactivated. No new orders accepted.'
                  : 'Plan activated successfully.',
            ),
          ),
        );
      }
    });
  }

  void _handleDeletePlan(Plan plan) {
    showDialog(
      context: context,
      builder: (context) => DeletePlanDialog(
        planName: plan.name,
        subscriberCount: plan.subscriberCount,
        onDelete: () {
          setState(() {
            _plans.removeWhere((p) => p.id == plan.id);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Subscription plan "${plan.name}" deleted permanently.')),
          );
        },
        onDeactivateInstead: () {
          _togglePlanStatus(plan);
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: colorScheme.primaryContainer,
      labelStyle: TextStyle(
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
      ),
    );
  }
}

class _DetailBox extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;

  const _DetailBox({
    required this.label,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: textTheme.bodySmall?.copyWith(
              fontSize: 10,
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
