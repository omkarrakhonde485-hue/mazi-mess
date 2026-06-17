import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/notification_item.dart';
import '../providers/notifications_provider.dart';
import '../widgets/notification_card.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  String _searchQuery = '';
  NotificationCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Retrieve notifications from Riverpod
    final notificationsList = ref.watch(notificationsProvider);

    // Apply filtering based on search query and category
    final filteredNotifications = notificationsList.where((notif) {
      final matchesSearch =
          notif.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              notif.message.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == null || notif.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    // Count unread notifications
    final unreadCount = notificationsList.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          if (unreadCount > 0)
            IconButton(
              tooltip: 'Mark all as read',
              icon: const Icon(Icons.done_all_outlined),
              onPressed: () {
                ref.read(notificationsProvider.notifier).markAllAsRead();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All notifications marked as read'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input Field
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search notifications...',
                  prefixIcon: Icon(Icons.search_outlined, color: colorScheme.onSurfaceVariant),
                  filled: true,
                  fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            // Category filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: _selectedCategory == null,
                    onSelected: () => setState(() => _selectedCategory = null),
                  ),
                  _FilterChip(
                    label: 'Payment',
                    isSelected: _selectedCategory == NotificationCategory.payment,
                    onSelected: () => setState(() => _selectedCategory = NotificationCategory.payment),
                  ),
                  _FilterChip(
                    label: 'Subscription',
                    isSelected: _selectedCategory == NotificationCategory.subscription,
                    onSelected: () => setState(() => _selectedCategory = NotificationCategory.subscription),
                  ),
                  _FilterChip(
                    label: 'Notice',
                    isSelected: _selectedCategory == NotificationCategory.notice,
                    onSelected: () => setState(() => _selectedCategory = NotificationCategory.notice),
                  ),
                  _FilterChip(
                    label: 'System',
                    isSelected: _selectedCategory == NotificationCategory.system,
                    onSelected: () => setState(() => _selectedCategory = NotificationCategory.system),
                  ),
                ],
              ),
            ),
            // Dynamic Notification list or Empty state
            Expanded(
              child: filteredNotifications.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceVariant.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _selectedCategory == null && _searchQuery.isEmpty
                                    ? Icons.notifications_off_outlined
                                    : Icons.search_off_outlined,
                                size: 48,
                                color: colorScheme.outline,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              _selectedCategory == null && _searchQuery.isEmpty
                                  ? 'All caught up!'
                                  : 'No results found',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _selectedCategory == null && _searchQuery.isEmpty
                                  ? 'You have no notifications at the moment.'
                                  : 'Try adjusting your search query or category filters.',
                              textAlign: TextAlign.center,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            if (_searchQuery.isNotEmpty || _selectedCategory != null) ...[
                              const SizedBox(height: 16),
                              TextButton.icon(
                                icon: const Icon(Icons.refresh),
                                label: const Text('Clear Filter'),
                                onPressed: () {
                                  setState(() {
                                    _searchQuery = '';
                                    _selectedCategory = null;
                                  });
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: filteredNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = filteredNotifications[index];
                        return NotificationCard(
                          notification: notification,
                          onTap: () {
                            // Mark notification as read on click
                            ref.read(notificationsProvider.notifier).markAsRead(notification.id);
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onSelected(),
        selectedColor: colorScheme.primaryContainer,
        labelStyle: TextStyle(
          color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
