import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../widgets/owner_notification_card.dart';

class OwnerNotificationItem {
  final String id;
  final String title;
  final String description;
  final String category; // 'Join Requests', 'Payments', 'Subscriptions', 'Attendance', 'System'
  final String timestamp;
  final bool isRead;

  OwnerNotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.timestamp,
    required this.isRead,
  });

  OwnerNotificationItem copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? timestamp,
    bool? isRead,
  }) {
    return OwnerNotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}

class OwnerNotificationsScreen extends StatefulWidget {
  const OwnerNotificationsScreen({super.key});

  @override
  State<OwnerNotificationsScreen> createState() => _OwnerNotificationsScreenState();
}

class _OwnerNotificationsScreenState extends State<OwnerNotificationsScreen> {
  // Stateful simulation of Mazi Mess Owner notifications
  final List<OwnerNotificationItem> _notifications = [
    OwnerNotificationItem(
      id: 'notif_1',
      title: 'New Join Request',
      description: 'Rahul Patil requested to join Premium Monthly Plan.',
      category: 'Join Requests',
      timestamp: 'Just now',
      isRead: false,
    ),
    OwnerNotificationItem(
      id: 'notif_2',
      title: 'Payment Verified',
      description: "Priya Sharma's payment of ₹3000.04 was verified.",
      category: 'Payments',
      timestamp: '15 mins ago',
      isRead: false,
    ),
    OwnerNotificationItem(
      id: 'notif_3',
      title: 'Verification Failed',
      description: 'Payment ₹2500.17 could not be verified automatically.',
      category: 'Payments',
      timestamp: '1 hour ago',
      isRead: false,
    ),
    OwnerNotificationItem(
      id: 'notif_4',
      title: 'Subscription Expiring',
      description: "Amit Patil's subscription expires tomorrow.",
      category: 'Subscriptions',
      timestamp: '2 hours ago',
      isRead: true,
    ),
    OwnerNotificationItem(
      id: 'notif_5',
      title: 'Attendance Approved',
      description: 'Rahul approved attendance for Dinner.',
      category: 'Attendance',
      timestamp: '5 hours ago',
      isRead: true,
    ),
    OwnerNotificationItem(
      id: 'notif_6',
      title: 'System Alert',
      description: 'Payment verification configuration inactive.',
      category: 'System',
      timestamp: 'Yesterday',
      isRead: true,
    ),
    OwnerNotificationItem(
      id: 'notif_7',
      title: 'Urgent Attendance Request',
      description: 'Sneha Kulkarni registered oral attendance dispute for Breakfast.',
      category: 'Attendance',
      timestamp: '2 days ago',
      isRead: true,
    ),
  ];

  late List<OwnerNotificationItem> _currentList;

  // Search query
  String _searchQuery = '';

  // Active Category Filter
  String _selectedCategory = 'All'; // 'All', 'Join Requests', 'Payments', 'Subscriptions', 'Attendance', 'System'

  final List<String> _categories = const [
    'All',
    'Join Requests',
    'Payments',
    'Subscriptions',
    'Attendance',
    'System',
  ];

  @override
  void initState() {
    super.initState();
    _currentList = List.from(_notifications);
  }

  void _markAsRead(String id) {
    setState(() {
      final index = _currentList.indexWhere((n) => n.id == id);
      if (index != -1) {
        _currentList[index] = _currentList[index].copyWith(isRead: true);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification marked as read.'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (int i = 0; i < _currentList.length; i++) {
        _currentList[i] = _currentList[i].copyWith(isRead: true);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Notifications'),
        content: const Text('Are you sure you want to clear all current notifications? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _currentList.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications cleared.')),
              );
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Handle route redirection simulate or push routes
  void _handleViewCustomer(String description) {
    // Attempt extract name like 'Priya Sharma' or 'Amit Patil'
    String customerId = 'cust_1'; // default fallback mock id
    if (description.contains('Priya Sharma')) {
      customerId = 'cust_2';
    } else if (description.contains('Amit Patil')) {
      customerId = 'cust_3';
    } else if (description.contains('Sneha Kulkarni')) {
      customerId = 'cust_4';
    }

    try {
      context.push('/owner-dashboard/customers/$customerId');
    } catch (_) {
      // Fallback dialog if routing isn't configured for that customer id or we are in preview
      _showDetailDialog('Customer Detail Info', 'Customer Record details extracted from: "$description".');
    }
  }

  void _handleViewRequest(String category, String description) {
    if (category == 'Join Requests') {
      try {
        context.push(AppRoute.joinRequests.path);
      } catch (_) {
        _showDetailDialog('Join Request Profile', description);
      }
    } else if (category == 'Attendance') {
      try {
        context.push(AppRoute.attendanceDashboard.path);
      } catch (_) {
        _showDetailDialog('Attendance Request Log', description);
      }
    } else {
      _showDetailDialog('Request Details', 'Description: $description\nCategory: $category');
    }
  }

  void _showDetailDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Filter list according to search queries and tags
    final filteredNotifications = _currentList.where((item) {
      final matchesSearch = item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    final unreadCount = _currentList.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Owner Alerts'),
            if (unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$unreadCount Unread',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onError,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (unreadCount > 0)
            IconButton(
              icon: const Icon(Icons.mark_chat_read_outlined),
              tooltip: 'Mark All as Read',
              onPressed: _markAllAsRead,
            ),
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Clear All',
            onPressed: _currentList.isNotEmpty ? _clearAllNotifications : null,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search Bar Section
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search alerts & system log messages...',
                hintStyle: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withAlpha(150),
                ),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: colorScheme.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.outlineVariant.withAlpha(120),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Categories filtering
          SizedBox(
            height: 52,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(
                      category,
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: colorScheme.primary,
                    showCheckmark: false,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Notification List
          Expanded(
            child: filteredNotifications.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.notifications_none_outlined,
                            size: 64,
                            color: colorScheme.onSurfaceVariant.withAlpha(100),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isNotEmpty || _selectedCategory != 'All'
                                ? 'No results found'
                                : 'All Caught Up!',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _searchQuery.isNotEmpty || _selectedCategory != 'All'
                                ? 'Try clearing your active filters or query.'
                                : 'You do not have any notifications right now.',
                            textAlign: TextAlign.center,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant.withAlpha(180),
                            ),
                          ),
                          if (_searchQuery.isNotEmpty || _selectedCategory != 'All') ...[
                            const SizedBox(height: 16),
                            TextButton.icon(
                              icon: const Icon(Icons.refresh_outlined),
                              label: const Text('Reset filters'),
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                  _selectedCategory = 'All';
                                });
                              },
                            )
                          ]
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final item = filteredNotifications[index];
                      return Dismissible(
                        key: Key(item.id),
                        background: Container(
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: Icon(Icons.delete_outline, color: Colors.red.shade900),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            _currentList.removeWhere((e) => e.id == item.id);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Dismissed: "${item.title}"'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {
                                  setState(() {
                                    _currentList.insert(index, item);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        child: OwnerNotificationCard(
                          title: item.title,
                          description: item.description,
                          category: item.category,
                          timestamp: item.timestamp,
                          isRead: item.isRead,
                          onMarkAsRead: !item.isRead ? () => _markAsRead(item.id) : null,
                          onViewCustomer: item.category == 'Payments' || item.category == 'Subscriptions'
                              ? () => _handleViewCustomer(item.description)
                              : null,
                          onViewRequest: item.category == 'Join Requests' || item.category == 'Attendance'
                              ? () => _handleViewRequest(item.category, item.description)
                              : null,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
