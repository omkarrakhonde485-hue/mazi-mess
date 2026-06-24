import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/webhook_integration_model.dart';
import '../widgets/admin_stat_card.dart';
import '../widgets/webhook_integration_card.dart';

class WebhookManagementScreen extends StatefulWidget {
  const WebhookManagementScreen({super.key});

  @override
  State<WebhookManagementScreen> createState() => _WebhookManagementScreenState();
}

class _WebhookManagementScreenState extends State<WebhookManagementScreen> {
  late List<WebhookIntegration> _integrations;
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _integrations = [
      WebhookIntegration(
        id: '1',
        messName: 'Annapurna Mess',
        ownerName: 'Rahul Patil',
        verificationGmail: 'annapurna.verification@gmail.com',
        makeAccountEmail: 'annapurna.make@gmail.com',
        makeAccountPassword: 'annapurnaMakeSecretPass!98',
        webhookUrl: 'https://hook.us1.make.com/abc123xyz789',
        setupDate: DateTime.now().subtract(const Duration(days: 30)),
        configuredBy: 'Admin',
        status: WebhookIntegrationStatus.active,
      ),
      WebhookIntegration(
        id: '2',
        messName: 'Swami Mess',
        ownerName: 'Manoj Kumar',
        verificationGmail: 'swami.verification@gmail.com',
        makeAccountEmail: 'swami.make@gmail.com',
        makeAccountPassword: 'swamiSecurePass#2026',
        webhookUrl: 'https://hook.us1.make.com/mnj555pqr888',
        setupDate: DateTime.now().subtract(const Duration(days: 14)),
        configuredBy: 'Admin',
        status: WebhookIntegrationStatus.active,
      ),
      WebhookIntegration(
        id: '3',
        messName: 'Gurukrupa Annex',
        ownerName: 'Rajesh Patil',
        verificationGmail: 'gurukrupa.verification@gmail.com',
        makeAccountEmail: 'gurukrupa.make@gmail.com',
        makeAccountPassword: 'guruPassword@88',
        webhookUrl: 'https://hook.us1.make.com/gur777abc444',
        setupDate: DateTime.now().subtract(const Duration(days: 20)),
        configuredBy: 'Admin',
        status: WebhookIntegrationStatus.inactive,
      ),
      WebhookIntegration(
        id: '4',
        messName: 'Royal Mess',
        ownerName: 'Sunil Joshi',
        verificationGmail: 'royal.verification@gmail.com',
        makeAccountEmail: 'royal.make@gmail.com',
        makeAccountPassword: 'royalMessSecretKey',
        webhookUrl: 'https://hook.us1.make.com/roy111err999',
        setupDate: DateTime.now().subtract(const Duration(days: 5)),
        configuredBy: 'Admin',
        status: WebhookIntegrationStatus.error,
      ),
      WebhookIntegration(
        id: '5',
        messName: 'Jai Hind Mess',
        ownerName: 'Vikas Shinde',
        verificationGmail: '',
        makeAccountEmail: '',
        makeAccountPassword: '',
        webhookUrl: '',
        setupDate: DateTime.now(),
        configuredBy: 'N/A',
        status: WebhookIntegrationStatus.setupRequired,
      ),
    ];
  }

  // Statistics calculation based on real-time state
  int get _totalConfigured => _integrations.length;
  int get _activeCount => _integrations.where((i) => i.status == WebhookIntegrationStatus.active).length;
  int get _inactiveCount => _integrations.where((i) => i.status == WebhookIntegrationStatus.inactive).length;
  int get _setupRequiredCount => _integrations.where((i) => i.status == WebhookIntegrationStatus.setupRequired).length;

  List<WebhookIntegration> get _filteredIntegrations {
    return _integrations.where((item) {
      final matchesSearch = item.messName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.ownerName.toLowerCase().contains(_searchQuery.toLowerCase());

      if (!matchesSearch) return false;

      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Active') return item.status == WebhookIntegrationStatus.active;
      if (_selectedFilter == 'Inactive') return item.status == WebhookIntegrationStatus.inactive;
      if (_selectedFilter == 'Setup Required') return item.status == WebhookIntegrationStatus.setupRequired;
      if (_selectedFilter == 'Error') return item.status == WebhookIntegrationStatus.error;

      return true;
    }).toList();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Theme.of(context).colorScheme.onInverseSurface,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _toggleStatus(WebhookIntegration integration, bool activate) {
    setState(() {
      final idx = _integrations.indexWhere((i) => i.id == integration.id);
      if (idx != -1) {
        final newStatus = activate ? WebhookIntegrationStatus.active : WebhookIntegrationStatus.inactive;
        _integrations[idx] = _integrations[idx].copyWith(status: newStatus);
      }
    });
    _showSnackBar(
      activate ? '${integration.messName} activated!' : '${integration.messName} deactivated.',
    );
  }

  void _openCreateDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final formKey = GlobalKey<FormState>();
        final messNameController = TextEditingController();
        final ownerNameController = TextEditingController();
        final verificationGmailController = TextEditingController();
        final makeEmailController = TextEditingController();
        final makePasswordController = TextEditingController();
        final webhookUrlController = TextEditingController();
        WebhookIntegrationStatus selectedStatus = WebhookIntegrationStatus.setupRequired;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.add_link_outlined, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Create Integration'),
                ],
              ),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: messNameController,
                          decoration: const InputDecoration(
                            labelText: 'Mess Name *',
                            prefixIcon: Icon(Icons.restaurant_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: ownerNameController,
                          decoration: const InputDecoration(
                            labelText: 'Owner Name *',
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<WebhookIntegrationStatus>(
                          value: selectedStatus,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            prefixIcon: Icon(Icons.info_outline),
                            border: OutlineInputBorder(),
                          ),
                          items: WebhookIntegrationStatus.values
                              .map((s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s.label),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() {
                                selectedStatus = val;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        // Only require credentials if not setupRequired
                        TextFormField(
                          controller: verificationGmailController,
                          decoration: InputDecoration(
                            labelText: selectedStatus == WebhookIntegrationStatus.setupRequired
                                ? 'Verification Gmail (Optional)'
                                : 'Verification Gmail *',
                            prefixIcon: const Icon(Icons.mail_outline),
                            border: const OutlineInputBorder(),
                            helperText: 'Dedicated Gmail for this mess',
                          ),
                          validator: (v) {
                            if (selectedStatus != WebhookIntegrationStatus.setupRequired) {
                              if (v == null || v.trim().isEmpty) return 'Required';
                              if (!v.contains('@')) return 'Invalid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: makeEmailController,
                          decoration: InputDecoration(
                            labelText: selectedStatus == WebhookIntegrationStatus.setupRequired
                                ? 'Make Account Email (Optional)'
                                : 'Make Account Email *',
                            prefixIcon: const Icon(Icons.account_circle_outlined),
                            border: const OutlineInputBorder(),
                            helperText: 'Make.com login email for this mess',
                          ),
                          validator: (v) {
                            if (selectedStatus != WebhookIntegrationStatus.setupRequired) {
                              if (v == null || v.trim().isEmpty) return 'Required';
                              if (!v.contains('@')) return 'Invalid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: makePasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: selectedStatus == WebhookIntegrationStatus.setupRequired
                                ? 'Make Password (Optional)'
                                : 'Make Password *',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: const OutlineInputBorder(),
                            helperText: 'Make.com login password',
                          ),
                          validator: (v) {
                            if (selectedStatus != WebhookIntegrationStatus.setupRequired &&
                                (v == null || v.trim().isEmpty)) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: webhookUrlController,
                          decoration: InputDecoration(
                            labelText: selectedStatus == WebhookIntegrationStatus.setupRequired
                                ? 'Webhook URL (Optional)'
                                : 'Webhook URL *',
                            prefixIcon: const Icon(Icons.link_outlined),
                            border: const OutlineInputBorder(),
                            helperText: 'Unique webhook URL from Make.com scenario',
                          ),
                          validator: (v) {
                            if (selectedStatus != WebhookIntegrationStatus.setupRequired) {
                              if (v == null || v.trim().isEmpty) return 'Required';
                              if (!v.startsWith('http')) return 'Invalid URL';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() == true) {
                      final newIntegration = WebhookIntegration(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        messName: messNameController.text.trim(),
                        ownerName: ownerNameController.text.trim(),
                        verificationGmail: verificationGmailController.text.trim(),
                        makeAccountEmail: makeEmailController.text.trim(),
                        makeAccountPassword: makePasswordController.text.trim(),
                        webhookUrl: webhookUrlController.text.trim(),
                        setupDate: DateTime.now(),
                        configuredBy: 'Admin',
                        status: selectedStatus,
                      );
                      setState(() {
                        _integrations.add(newIntegration);
                      });
                      Navigator.pop(context);
                      _showSnackBar('New integration created for ${newIntegration.messName}!');
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _openEditDialog(WebhookIntegration integration) {
    showDialog(
      context: context,
      builder: (context) {
        final formKey = GlobalKey<FormState>();
        final verificationGmailController = TextEditingController(text: integration.verificationGmail);
        final makeEmailController = TextEditingController(text: integration.makeAccountEmail);
        final makePasswordController = TextEditingController(text: integration.makeAccountPassword);
        final webhookUrlController = TextEditingController(text: integration.webhookUrl);
        WebhookIntegrationStatus selectedStatus = integration.status;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.edit_note_outlined, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Edit ${integration.messName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DropdownButtonFormField<WebhookIntegrationStatus>(
                          value: selectedStatus,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            prefixIcon: Icon(Icons.info_outline),
                            border: OutlineInputBorder(),
                          ),
                          items: WebhookIntegrationStatus.values
                              .map((s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s.label),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() {
                                selectedStatus = val;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: verificationGmailController,
                          decoration: InputDecoration(
                            labelText: selectedStatus == WebhookIntegrationStatus.setupRequired
                                ? 'Verification Gmail (Optional)'
                                : 'Verification Gmail *',
                            prefixIcon: const Icon(Icons.mail_outline),
                            border: const OutlineInputBorder(),
                            helperText: 'Dedicated Gmail for this mess',
                          ),
                          validator: (v) {
                            if (selectedStatus != WebhookIntegrationStatus.setupRequired) {
                              if (v == null || v.trim().isEmpty) return 'Required';
                              if (!v.contains('@')) return 'Invalid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: makeEmailController,
                          decoration: InputDecoration(
                            labelText: selectedStatus == WebhookIntegrationStatus.setupRequired
                                ? 'Make Account Email (Optional)'
                                : 'Make Account Email *',
                            prefixIcon: const Icon(Icons.account_circle_outlined),
                            border: const OutlineInputBorder(),
                            helperText: 'Make.com login email for this mess',
                          ),
                          validator: (v) {
                            if (selectedStatus != WebhookIntegrationStatus.setupRequired) {
                              if (v == null || v.trim().isEmpty) return 'Required';
                              if (!v.contains('@')) return 'Invalid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: makePasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: selectedStatus == WebhookIntegrationStatus.setupRequired
                                ? 'Make Password (Optional)'
                                : 'Make Password *',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: const OutlineInputBorder(),
                            helperText: 'Make.com login password',
                          ),
                          validator: (v) {
                            if (selectedStatus != WebhookIntegrationStatus.setupRequired &&
                                (v == null || v.trim().isEmpty)) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: webhookUrlController,
                          decoration: InputDecoration(
                            labelText: selectedStatus == WebhookIntegrationStatus.setupRequired
                                ? 'Webhook URL (Optional)'
                                : 'Webhook URL *',
                            prefixIcon: const Icon(Icons.link_outlined),
                            border: const OutlineInputBorder(),
                            helperText: 'Unique webhook URL from Make.com scenario',
                          ),
                          validator: (v) {
                            if (selectedStatus != WebhookIntegrationStatus.setupRequired) {
                              if (v == null || v.trim().isEmpty) return 'Required';
                              if (!v.startsWith('http')) return 'Invalid URL';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() == true) {
                      setState(() {
                        final idx = _integrations.indexWhere((i) => i.id == integration.id);
                        if (idx != -1) {
                          _integrations[idx] = integration.copyWith(
                            verificationGmail: verificationGmailController.text.trim(),
                            makeAccountEmail: makeEmailController.text.trim(),
                            makeAccountPassword: makePasswordController.text.trim(),
                            webhookUrl: webhookUrlController.text.trim(),
                            status: selectedStatus,
                            setupDate: DateTime.now(), // update setup date on configuration change
                          );
                        }
                      });
                      Navigator.pop(context);
                      _showSnackBar('Integration details updated successfully!');
                    }
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildResponsiveStatsGrid() {
    final width = MediaQuery.of(context).size.width;

    final List<Widget> stats = [
      AdminStatCard(
        title: 'Configured Messes',
        value: _totalConfigured.toString(),
        icon: Icons.restaurant_menu,
        subtitle: 'Total integrated outlets',
      ),
      AdminStatCard(
        title: 'Active Integrations',
        value: _activeCount.toString(),
        icon: Icons.check_circle,
        iconColor: Colors.green,
        valueColor: Colors.green.shade700,
        subtitle: 'Routing payment webhooks',
      ),
      AdminStatCard(
        title: 'Inactive Integrations',
        value: _inactiveCount.toString(),
        icon: Icons.pause_circle_filled,
        iconColor: Colors.grey,
        valueColor: Colors.grey.shade700,
        subtitle: 'Manually paused pipelines',
      ),
      AdminStatCard(
        title: 'Setup Required',
        value: _setupRequiredCount.toString(),
        icon: Icons.warning_amber_rounded,
        iconColor: Colors.orange,
        valueColor: Colors.orange.shade700,
        isCritical: _setupRequiredCount > 0,
        subtitle: 'Awaiting webhook endpoints',
      ),
    ];

    if (width >= 900) {
      // Wide desktop: Row of 4 cards
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(stats.length, (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index < stats.length - 1 ? 12 : 0,
              ),
              child: stats[index],
            ),
          );
        }),
      );
    } else if (width >= 550) {
      // Tablet: 2x2 Grid using columns of rows
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: stats[0]),
              const SizedBox(width: 12),
              Expanded(child: stats[1]),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: stats[2]),
              const SizedBox(width: 12),
              Expanded(child: stats[3]),
            ],
          ),
        ],
      );
    } else {
      // Mobile: Single column
      return Column(
        children: stats
            .map((card) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: card,
                ))
            .toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final filteredList = _filteredIntegrations;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Webhook Management',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Webhook Pipeline Overview'),
                  content: const Text(
                    'For each mess outlet, payment verification runs automatically through a dedicated pipeline:\n\n'
                    '1 Mess → 1 Verification Gmail → 1 Make.com Account → 1 Scenario → 1 Webhook URL → Payment Auto-Verification.\n\n'
                    'Note: These integrations are highly sensitive and visible to Admin only. Mess Owners do not have access to these credentials.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Integration'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Warning Banner about Admin Only access
                    Card(
                      color: colorScheme.surfaceContainerHighest.withOpacity(0.4),
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(Icons.security, color: colorScheme.primary, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'ADMIN ONLY CONTROL • Verification credentials and Make.com account pipelines are hidden from mess owners.',
                                style: textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 1. Statistics Section
                    _buildResponsiveStatsGrid(),
                    const SizedBox(height: 24),

                    // 2. Search & Filter Bar
                    Card(
                      elevation: 0,
                      color: colorScheme.surfaceContainerHigh.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'Search by mess name or owner name...',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
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
                            // Filter chips wrapping automatically to fit any screen sizes nicely
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                'All',
                                'Active',
                                'Inactive',
                                'Setup Required',
                                'Error',
                              ].map((filter) {
                                final isSelected = _selectedFilter == filter;
                                return FilterChip(
                                  label: Text(filter),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _selectedFilter = filter;
                                      });
                                    }
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 3. Integration List
                    if (filteredList.isEmpty)
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.3)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.hourglass_empty,
                                size: 48,
                                color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No Integrations Found',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Try refining your search query or modifying the status filters.',
                                textAlign: TextAlign.center,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final item = filteredList[index];
                          return WebhookIntegrationCard(
                            integration: item,
                            onEdit: () => _openEditDialog(item),
                            onActivate: () => _toggleStatus(item, true),
                            onDeactivate: () => _toggleStatus(item, false),
                          );
                        },
                      ),
                    const SizedBox(height: 80), // extra padding for fab
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
