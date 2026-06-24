import 'package:flutter/material.dart';
import '../../../models/owner_profile_model.dart';
import '../widgets/owner_verification_card.dart';

class OwnerVerificationScreen extends StatefulWidget {
  const OwnerVerificationScreen({super.key});

  @override
  State<OwnerVerificationScreen> createState() => _OwnerVerificationScreenState();
}

class _OwnerVerificationScreenState extends State<OwnerVerificationScreen> {
  // Mock list of owner profiles
  late List<OwnerProfile> _owners;

  // Search and Filter State
  String _searchQuery = '';
  String _selectedFilter = 'All'; // 'All', 'Pending', 'Approved', 'Rejected', 'Suspended'

  @override
  void initState() {
    super.initState();
    _owners = [
      OwnerProfile(
        ownerId: 'owner_1',
        fullName: 'Manoj Kumar',
        phoneNumber: '+91 98765 43210',
        email: 'manoj.kumar@gmail.com',
        messName: 'Swami Mess',
        businessName: 'Swami Mess Hospitality Ltd.',
        fssaiLicense: '22723000456123',
        panNumber: 'ABCPK1234F',
        address: 'Deccan Gymkhana, Pune, 411004',
        verificationStatus: OwnerVerificationStatus.pending,
        submissionDate: DateTime.now().subtract(const Duration(minutes: 10)),
        documentUrl: 'https://images.unsplash.com/photo-1554415707-6e8cfc93fe23?auto=format&fit=crop&q=80&w=600',
      ),
      OwnerProfile(
        ownerId: 'owner_2',
        fullName: 'Kedar Deshpande',
        phoneNumber: '+91 91234 56789',
        email: 'kedar.deshpande@outlook.com',
        messName: 'Annapurna Kitchen',
        businessName: 'Annapurna Catering Services',
        fssaiLicense: '11221000987321',
        panNumber: 'DEFPK5678G',
        address: 'Kothrud, Pune, 411038',
        verificationStatus: OwnerVerificationStatus.pending,
        submissionDate: DateTime.now().subtract(const Duration(hours: 3)),
        documentUrl: 'https://images.unsplash.com/photo-1543007630-9710e4a00a20?auto=format&fit=crop&q=80&w=600',
      ),
      OwnerProfile(
        ownerId: 'owner_3',
        fullName: 'Sunil Joshi',
        phoneNumber: '+91 94220 11223',
        email: 'sunil.joshi@gmail.com',
        messName: 'Gharoba Mess',
        businessName: 'Joshi Foods & Dining',
        fssaiLicense: '21522000554433',
        panNumber: 'GHIJP9012H',
        address: 'Karve Nagar, Pune, 411052',
        verificationStatus: OwnerVerificationStatus.approved,
        submissionDate: DateTime.now().subtract(const Duration(days: 15)),
        documentUrl: 'https://images.unsplash.com/photo-1568602471122-7832951cc4c5?auto=format&fit=crop&q=80&w=600',
      ),
      OwnerProfile(
        ownerId: 'owner_4',
        fullName: 'Rajesh Patil',
        phoneNumber: '+91 96550 44332',
        email: 'rajesh.patil@rediffmail.com',
        messName: 'Gurukrupa Annex',
        businessName: 'Gurukrupa Messes LLP',
        fssaiLicense: '11519000112233',
        panNumber: 'KLMNO3456I',
        address: 'Hadapsar, Pune, 411028',
        verificationStatus: OwnerVerificationStatus.suspended,
        submissionDate: DateTime.now().subtract(const Duration(days: 30)),
        documentUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&q=80&w=600',
      ),
      OwnerProfile(
        ownerId: 'owner_5',
        fullName: 'Neha Deshmukh',
        phoneNumber: '+91 93700 88990',
        email: 'neha.deshmukh@yahoo.com',
        messName: 'Mauli Mess',
        businessName: 'Mauli Eating House',
        fssaiLicense: '11520000778899',
        panNumber: 'PQRST7890J',
        address: 'Sinhagad Road, Pune, 411041',
        verificationStatus: OwnerVerificationStatus.rejected,
        submissionDate: DateTime.now().subtract(const Duration(days: 4)),
        rejectionReason: 'FSSAI License registration document is blurred and unreadable. Please upload a clear photo.',
        documentUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&q=80&w=600',
      ),
      OwnerProfile(
        ownerId: 'owner_6',
        fullName: 'Priyesh Shah',
        phoneNumber: '+91 98900 12345',
        email: 'priyesh.shah@gmail.com',
        messName: 'Royal Dining Hall',
        businessName: 'Shah Foods Private Ltd.',
        fssaiLicense: '11422000121212',
        panNumber: 'UVWXY1212K',
        address: 'Camp, Pune, 411001',
        verificationStatus: OwnerVerificationStatus.pending,
        submissionDate: DateTime.now().subtract(const Duration(hours: 18)),
        documentUrl: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&q=80&w=600',
      ),
    ];
  }

  // Statistics getters
  int get _totalCount => _owners.length;
  int get _pendingCount => _owners.where((o) => o.verificationStatus == OwnerVerificationStatus.pending).length;
  int get _approvedCount => _owners.where((o) => o.verificationStatus == OwnerVerificationStatus.approved).length;
  int get _suspendedCount => _owners.where((o) => o.verificationStatus == OwnerVerificationStatus.suspended).length;

  // Filter & Search List
  List<OwnerProfile> get _filteredOwners {
    return _owners.where((owner) {
      // 1. Status Filter
      if (_selectedFilter != 'All') {
        final matchesStatus = switch (_selectedFilter) {
          'Pending' => owner.verificationStatus == OwnerVerificationStatus.pending,
          'Approved' => owner.verificationStatus == OwnerVerificationStatus.approved,
          'Rejected' => owner.verificationStatus == OwnerVerificationStatus.rejected,
          'Suspended' => owner.verificationStatus == OwnerVerificationStatus.suspended,
          _ => true,
        };
        if (!matchesStatus) return false;
      }

      // 2. Search Query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesSearch = owner.fullName.toLowerCase().contains(query) ||
            owner.businessName.toLowerCase().contains(query) ||
            owner.messName.toLowerCase().contains(query) ||
            owner.fssaiLicense.contains(query) ||
            owner.panNumber.toLowerCase().contains(query) ||
            owner.phoneNumber.contains(query) ||
            owner.email.toLowerCase().contains(query);
        if (!matchesSearch) return false;
      }

      return true;
    }).toList();
  }

  void _showSnackBar(String message, {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error_outline,
              color: isSuccess ? Colors.green.shade100 : Colors.red.shade100,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Action: Approve
  void _approveOwner(OwnerProfile owner) {
    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          title: const Text('Approve Owner Application'),
          content: Text(
            'Are you sure you want to approve ${owner.fullName} for ${owner.messName}?\n\n'
            'This will enable their mess outlet to accept customer subscriptions and register meals.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  final idx = _owners.indexWhere((o) => o.ownerId == owner.ownerId);
                  if (idx != -1) {
                    _owners[idx] = owner.copyWith(
                      verificationStatus: OwnerVerificationStatus.approved,
                      rejectionReason: '',
                    );
                  }
                });
                Navigator.pop(context);
                _showSnackBar('${owner.fullName} has been approved successfully.');
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.green.shade700,
              ),
              child: const Text('Approve'),
            ),
          ],
        );
      },
    );
  }

  // Action: Reject (with reason text input)
  void _rejectOwner(OwnerProfile owner) {
    final reasonController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          title: const Text('Reject Owner Application'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Please specify the reason for rejecting ${owner.fullName}\'s application. '
                  'This reason will be visible to them in their registration screen.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: reasonController,
                  maxLines: 3,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Rejection Reason',
                    hintText: 'e.g. Unreadable documents, incomplete address, invalid FSSAI...',
                    alignLabelWithHint: true,
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Rejection reason is required';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  setState(() {
                    final idx = _owners.indexWhere((o) => o.ownerId == owner.ownerId);
                    if (idx != -1) {
                      _owners[idx] = owner.copyWith(
                        verificationStatus: OwnerVerificationStatus.rejected,
                        rejectionReason: reasonController.text.trim(),
                      );
                    }
                  });
                  Navigator.pop(context);
                  _showSnackBar('${owner.fullName}\'s application has been rejected.', isSuccess: false);
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
              ),
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );
  }

  // Action: Suspend (with confirmation)
  void _suspendOwner(OwnerProfile owner) {
    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: colorScheme.error),
              const SizedBox(width: 8),
              const Text('Suspend Owner Account'),
            ],
          ),
          content: Text(
            'Are you sure you want to suspend ${owner.fullName} (${owner.messName})?\n\n'
            'Suspended owners will be immediately locked out of the owner panel, '
            'and their active customer meals and subscription processing will be frozen.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  final idx = _owners.indexWhere((o) => o.ownerId == owner.ownerId);
                  if (idx != -1) {
                    _owners[idx] = owner.copyWith(
                      verificationStatus: OwnerVerificationStatus.suspended,
                    );
                  }
                });
                Navigator.pop(context);
                _showSnackBar('Owner ${owner.fullName} suspended.', isSuccess: false);
              },
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
              ),
              child: const Text('Suspend'),
            ),
          ],
        );
      },
    );
  }

  // Action: Reactivate
  void _reactivateOwner(OwnerProfile owner) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reactivate Owner Account'),
          content: Text(
            'Reactivate ${owner.fullName} (${owner.messName})?\n\n'
            'This will immediately restore their full operational access to the mess manager panel.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  final idx = _owners.indexWhere((o) => o.ownerId == owner.ownerId);
                  if (idx != -1) {
                    _owners[idx] = owner.copyWith(
                      verificationStatus: OwnerVerificationStatus.approved,
                      rejectionReason: '',
                    );
                  }
                });
                Navigator.pop(context);
                _showSnackBar('Owner account reactivated successfully.');
              },
              child: const Text('Reactivate'),
            ),
          ],
        );
      },
    );
  }

  // Dialog: Show Document Details
  void _viewOwnerDocuments(OwnerProfile owner) {
    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.badge_outlined, color: colorScheme.primary),
              const SizedBox(width: 8),
              const Expanded(child: Text('Verification Documents')),
            ],
          ),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(owner.fullName, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text(owner.businessName, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                  const Divider(height: 24),

                  // FSSAI Document Header
                  _buildDocHeader(context, 'FSSAI Food Safety License Registration', owner.fssaiLicense),
                  const SizedBox(height: 8),
                  _buildMockDocumentWidget(context, owner.documentUrl),

                  const SizedBox(height: 20),

                  // PAN Card Header
                  _buildDocHeader(context, 'PAN Card Business Registration', owner.panNumber),
                  const SizedBox(height: 8),
                  _buildMockDocumentWidget(context, null), // Generic PAN placeholder
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            if (owner.verificationStatus == OwnerVerificationStatus.pending) ...[
              FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _approveOwner(owner);
                },
                icon: const Icon(Icons.check, size: 16),
                label: const Text('Approve directly'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildDocHeader(BuildContext context, String title, String code) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Row(
          children: [
            const Icon(Icons.verified_outlined, size: 14, color: Colors.teal),
            const SizedBox(width: 4),
            Text(
              'Reg No: $code',
              style: textTheme.bodySmall?.copyWith(
                fontFamily: 'Courier',
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMockDocumentWidget(BuildContext context, String? imageUrl) {
    final colorScheme = Theme.of(context).colorScheme;

    if (imageUrl != null) {
      return Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
            ),
          ),
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.all(8),
          child: const Text(
            'Official Certificate',
            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    // fallback generic secure card layout
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant, style: BorderStyle.solid),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.security, color: colorScheme.primary.withOpacity(0.6), size: 36),
            const SizedBox(height: 6),
            Text(
              'Encrypted PAN Document Preview',
              style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 2),
            Text(
              'Filing validated on NSDL Registry',
              style: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.6), fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  // Grid/Row Responsive Stats Layout
  Widget _buildStatsWidget(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 800;

    final widgets = [
      _buildStatItem(context, 'Total Register', _totalCount, Icons.groups_outlined, Colors.indigo),
      _buildStatItem(context, 'Pending Queue', _pendingCount, Icons.hourglass_top_rounded, Colors.orange),
      _buildStatItem(context, 'Active Verified', _approvedCount, Icons.check_circle_outline_rounded, Colors.green),
      _buildStatItem(context, 'Suspended', _suspendedCount, Icons.block_flipped, Colors.red),
    ];

    if (isDesktop) {
      return Row(
        children: widgets.map((w) => Expanded(child: w)).toList(),
      );
    } else {
      // 2x2 grid for standard devices
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.2,
        children: widgets,
      );
    }
  }

  Widget _buildStatItem(BuildContext context, String label, int count, IconData icon, Color color) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  count.toString(),
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  label,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withOpacity(0.8),
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Owner Verification Portal',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            tooltip: 'Reload Portal Mock Data',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              initState();
              setState(() {});
              _showSnackBar('Verification state re-initialized.');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Statistics Section
              _buildStatsWidget(context),
              const SizedBox(height: 24),

              // Search & Filter header
              Row(
                children: [
                  Icon(Icons.search, color: colorScheme.primary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Search & Filters',
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Search Input Field
              TextField(
                decoration: InputDecoration(
                  labelText: 'Search Owner Profiles',
                  hintText: 'Search by owner name, mess, GST/FSSAI, PAN, phone...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                ),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
              ),
              const SizedBox(height: 12),

              // Filter Chips Scrollable Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Pending', 'Approved', 'Rejected', 'Suspended'].map((filter) {
                    final isSelected = _selectedFilter == filter;
                    final count = switch (filter) {
                      'All' => _totalCount,
                      'Pending' => _pendingCount,
                      'Approved' => _approvedCount,
                      'Rejected' => _owners.where((o) => o.verificationStatus == OwnerVerificationStatus.rejected).length,
                      'Suspended' => _suspendedCount,
                      _ => 0,
                    };

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text('$filter ($count)'),
                        selected: isSelected,
                        onSelected: (val) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),

              // Verification List Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Owner Registrations (${_filteredOwners.length})',
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (_searchQuery.isNotEmpty || _selectedFilter != 'All')
                    TextButton.icon(
                      icon: const Icon(Icons.filter_alt_off_outlined, size: 14),
                      label: const Text('Reset filters'),
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                          _selectedFilter = 'All';
                        });
                      },
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // The List / Empty state
              if (_filteredOwners.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.manage_accounts_outlined, size: 48, color: colorScheme.onSurfaceVariant.withOpacity(0.5)),
                      const SizedBox(height: 12),
                      Text(
                        'No Matching Registrations',
                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'No owner profiles match your current search and filter settings.',
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                )
              else
                ..._filteredOwners.map((owner) {
                  return OwnerVerificationCard(
                    owner: owner,
                    onApprove: () => _approveOwner(owner),
                    onReject: () => _rejectOwner(owner),
                    onSuspend: () => _suspendOwner(owner),
                    onReactivate: () => _reactivateOwner(owner),
                    onViewDocument: () => _viewOwnerDocuments(owner),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}
