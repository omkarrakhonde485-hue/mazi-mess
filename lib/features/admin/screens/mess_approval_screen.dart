import 'package:flutter/material.dart';
import '../../../models/mess_approval_model.dart';
import '../widgets/mess_approval_card.dart';

class MessApprovalScreen extends StatefulWidget {
  const MessApprovalScreen({super.key});

  @override
  State<MessApprovalScreen> createState() => _MessApprovalScreenState();
}

class _MessApprovalScreenState extends State<MessApprovalScreen> {
  late List<MessApproval> _messes;

  String _searchQuery = '';
  String _selectedFilter = 'All'; // 'All', 'Pending', 'Approved', 'Rejected', 'Suspended'

  @override
  void initState() {
    super.initState();
    _messes = [
      MessApproval(
        messId: 'mess_1',
        messName: 'Annapurna Dining Hall',
        ownerName: 'Manoj Kumar',
        ownerId: 'owner_1',
        description: 'Specializes in authentic Maharashtrian thali with unlimited chapatis, premium quality basmati rice, and homemade sweets.',
        address: 'Deccan Gymkhana, Pune, 411004',
        foodType: 'Veg',
        startingPrice: 2200,
        fssaiLicense: '12723000456123',
        submissionDate: DateTime.now().subtract(const Duration(minutes: 15)),
        status: MessApprovalStatus.pending,
        fssaiDocumentUrl: 'https://images.unsplash.com/photo-1554415707-6e8cfc93fe23?auto=format&fit=crop&q=80&w=600',
        menuDocumentUrl: 'https://images.unsplash.com/photo-1534080564583-6be75777b70a?auto=format&fit=crop&q=80&w=600',
        contactNumber: '+91 98765 43210',
        email: 'annapurna.dining@gmail.com',
      ),
      MessApproval(
        messId: 'mess_2',
        messName: 'Royal Spice Mess',
        ownerName: 'Kedar Deshpande',
        ownerId: 'owner_2',
        description: 'Offering high-protein north Indian and south Indian meal options. Perfect for gym goers and working professionals.',
        address: 'Kothrud, Pune, 411038',
        foodType: 'Veg & Non-Veg',
        startingPrice: 2800,
        fssaiLicense: '11221000987321',
        submissionDate: DateTime.now().subtract(const Duration(hours: 4)),
        status: MessApprovalStatus.pending,
        fssaiDocumentUrl: 'https://images.unsplash.com/photo-1543007630-9710e4a00a20?auto=format&fit=crop&q=80&w=600',
        menuDocumentUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&q=80&w=600',
        contactNumber: '+91 91234 56789',
        email: 'royalspice.kothrud@gmail.com',
      ),
      MessApproval(
        messId: 'mess_3',
        messName: 'Janta Bhojnalaya',
        ownerName: 'Sunil Joshi',
        ownerId: 'owner_3',
        description: 'Pocket-friendly clean family dining since 1998. Healthy daily meals cooked with minimal oil and standard spices.',
        address: 'Karve Nagar, Pune, 411052',
        foodType: 'Veg',
        startingPrice: 1800,
        fssaiLicense: '21522000554433',
        submissionDate: DateTime.now().subtract(const Duration(days: 8)),
        status: MessApprovalStatus.approved,
        fssaiDocumentUrl: 'https://images.unsplash.com/photo-1568602471122-7832951cc4c5?auto=format&fit=crop&q=80&w=600',
        contactNumber: '+91 94220 11223',
        email: 'jantabhoj@gmail.com',
      ),
      MessApproval(
        messId: 'mess_4',
        messName: 'Sai Suman Food Court',
        ownerName: 'Rajesh Patil',
        ownerId: 'owner_4',
        description: 'Delicious heavy thalis and custom Chinese/Indian menu plans for engineering students with daily door delivery.',
        address: 'Hadapsar, Pune, 411028',
        foodType: 'Veg & Non-Veg',
        startingPrice: 2500,
        fssaiLicense: '11519000112233',
        submissionDate: DateTime.now().subtract(const Duration(days: 20)),
        status: MessApprovalStatus.suspended,
        fssaiDocumentUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&q=80&w=600',
        contactNumber: '+91 96550 44332',
        email: 'saisuman.food@yahoo.com',
      ),
      MessApproval(
        messId: 'mess_5',
        messName: 'Maratha Mess',
        ownerName: 'Neha Deshmukh',
        ownerId: 'owner_5',
        description: 'Home-style Kolhapuri and Malvani non-veg special dining. Traditional recipes using genuine homemade spices.',
        address: 'Sinhagad Road, Pune, 411041',
        foodType: 'Non-Veg',
        startingPrice: 3000,
        fssaiLicense: '11520000778899',
        submissionDate: DateTime.now().subtract(const Duration(days: 3)),
        status: MessApprovalStatus.rejected,
        rejectionReasonType: MessRejectionReasonType.invalidFssai,
        rejectionReasonDetails: 'FSSAI License registration document is invalid or expired. Please upload an active certificate.',
        fssaiDocumentUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&q=80&w=600',
        contactNumber: '+91 93700 88990',
        email: 'maratha.mess@outlook.com',
      ),
      MessApproval(
        messId: 'mess_6',
        messName: 'Elite Tiffin Services',
        ownerName: 'Priyesh Shah',
        ownerId: 'owner_6',
        description: 'Premium organic meals with zero preservatives, customized macros for diet-conscious techies, and eco-friendly packing.',
        address: 'Camp, Pune, 411001',
        foodType: 'Veg',
        startingPrice: 3500,
        fssaiLicense: '11422000121212',
        submissionDate: DateTime.now().subtract(const Duration(hours: 12)),
        status: MessApprovalStatus.pending,
        fssaiDocumentUrl: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&q=80&w=600',
        contactNumber: '+91 98900 12345',
        email: 'elitetiffin@gmail.com',
      ),
    ];
  }

  // Count Getters
  int get _totalCount => _messes.length;
  int get _pendingCount => _messes.where((m) => m.status == MessApprovalStatus.pending).length;
  int get _approvedCount => _messes.where((m) => m.status == MessApprovalStatus.approved).length;
  int get _rejectedCount => _messes.where((m) => m.status == MessApprovalStatus.rejected).length;
  int get _suspendedCount => _messes.where((m) => m.status == MessApprovalStatus.suspended).length;

  List<MessApproval> get _filteredMesses {
    return _messes.where((mess) {
      if (_selectedFilter != 'All') {
        final matchesStatus = switch (_selectedFilter) {
          'Pending' => mess.status == MessApprovalStatus.pending,
          'Approved' => mess.status == MessApprovalStatus.approved,
          'Rejected' => mess.status == MessApprovalStatus.rejected,
          'Suspended' => mess.status == MessApprovalStatus.suspended,
          _ => true,
        };
        if (!matchesStatus) return false;
      }

      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesSearch = mess.messName.toLowerCase().contains(query) ||
            mess.ownerName.toLowerCase().contains(query) ||
            mess.address.toLowerCase().contains(query) ||
            mess.fssaiLicense.contains(query) ||
            mess.foodType.toLowerCase().contains(query) ||
            mess.contactNumber.contains(query) ||
            mess.email.toLowerCase().contains(query);
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

  void _approveMess(MessApproval mess) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Approve Mess Outlet'),
          content: Text(
            'Are you sure you want to approve "${mess.messName}" owned by ${mess.ownerName}?\n\n'
            'Once approved, this mess will go live on the customer app, and users will be able to purchase meal plans.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  final idx = _messes.indexWhere((m) => m.messId == mess.messId);
                  if (idx != -1) {
                    _messes[idx] = mess.copyWith(
                      status: MessApprovalStatus.approved,
                      rejectionReasonType: null,
                      rejectionReasonDetails: '',
                    );
                  }
                });
                Navigator.pop(context);
                _showSnackBar('"${mess.messName}" has been successfully approved.');
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

  void _rejectMess(MessApproval mess) {
    MessRejectionReasonType selectedType = MessRejectionReasonType.invalidFssai;
    final reasonController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Reject Mess Application'),
              content: SizedBox(
                width: 450,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Specify the rejection category and provide details for "${mess.messName}".',
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<MessRejectionReasonType>(
                          value: selectedType,
                          decoration: const InputDecoration(
                            labelText: 'Rejection Category',
                            border: OutlineInputBorder(),
                          ),
                          items: MessRejectionReasonType.values.map((type) {
                            return DropdownMenuItem<MessRejectionReasonType>(
                              value: type,
                              child: Text(type.label),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() {
                                selectedType = val;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: reasonController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Rejection Details / Comments',
                            hintText: 'Provide detailed instructions for the owner to correct and re-apply...',
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Details are required to help the owner correct documents';
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
                    if (formKey.currentState?.validate() ?? false) {
                      setState(() {
                        final idx = _messes.indexWhere((m) => m.messId == mess.messId);
                        if (idx != -1) {
                          _messes[idx] = mess.copyWith(
                            status: MessApprovalStatus.rejected,
                            rejectionReasonType: selectedType,
                            rejectionReasonDetails: reasonController.text.trim(),
                          );
                        }
                      });
                      Navigator.pop(context);
                      _showSnackBar('"${mess.messName}" application has been rejected.', isSuccess: false);
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.error,
                  ),
                  child: const Text('Submit Rejection'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _suspendMess(MessApproval mess) {
    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: colorScheme.error),
              const SizedBox(width: 8),
              const Text('Suspend Mess Listing'),
            ],
          ),
          content: Text(
            'Are you sure you want to suspend "${mess.messName}"?\n\n'
            'Suspension will immediately hide the mess from the customer app and freeze any active user operations.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  final idx = _messes.indexWhere((m) => m.messId == mess.messId);
                  if (idx != -1) {
                    _messes[idx] = mess.copyWith(
                      status: MessApprovalStatus.suspended,
                    );
                  }
                });
                Navigator.pop(context);
                _showSnackBar('"${mess.messName}" listing has been suspended.', isSuccess: false);
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

  void _reactivateMess(MessApproval mess) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reactivate Mess Listing'),
          content: Text(
            'Reactivate "${mess.messName}" listing and restore full active operations?\n\n'
            'This will make the mess visible to hungry subscribers again.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  final idx = _messes.indexWhere((m) => m.messId == mess.messId);
                  if (idx != -1) {
                    _messes[idx] = mess.copyWith(
                      status: MessApprovalStatus.approved,
                      rejectionReasonType: null,
                      rejectionReasonDetails: '',
                    );
                  }
                });
                Navigator.pop(context);
                _showSnackBar('"${mess.messName}" has been successfully reactivated.');
              },
              child: const Text('Reactivate'),
            ),
          ],
        );
      },
    );
  }

  void _viewMessDocuments(MessApproval mess) {
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
                  Text(mess.messName, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text('Owner: ${mess.ownerName}', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                  const Divider(height: 24),

                  // FSSAI Header
                  _buildDocHeader(context, 'FSSAI License Registration', mess.fssaiLicense),
                  const SizedBox(height: 8),
                  _buildMockDocumentWidget(context, mess.fssaiDocumentUrl, 'Official FSSAI Certificate'),

                  const SizedBox(height: 20),

                  // Menu Document Header
                  _buildDocHeader(context, 'Proposed Meal Plans & Menu Card', 'PLAN-MENU-${mess.messId.toUpperCase()}'),
                  const SizedBox(height: 8),
                  _buildMockDocumentWidget(context, mess.menuDocumentUrl, 'Proposed Mess Menu'),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            if (mess.status == MessApprovalStatus.pending) ...[
              FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _approveMess(mess);
                },
                icon: const Icon(Icons.check, size: 16),
                label: const Text('Approve direct'),
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
              'ID: $code',
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

  Widget _buildMockDocumentWidget(BuildContext context, String? imageUrl, String label) {
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
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, color: colorScheme.primary.withOpacity(0.6), size: 36),
            const SizedBox(height: 6),
            Text(
              'Proposed Food Menu Details',
              style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 2),
            Text(
              'Validated by Mazi Mess Standards',
              style: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.6), fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsWidget(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 800;

    final widgets = [
      _buildStatItem(context, 'Total Messes', _totalCount, Icons.restaurant_menu_outlined, Colors.indigo),
      _buildStatItem(context, 'Pending Appr', _pendingCount, Icons.hourglass_top_rounded, Colors.orange),
      _buildStatItem(context, 'Live Outlets', _approvedCount, Icons.verified_outlined, Colors.green),
      _buildStatItem(context, 'Suspended', _suspendedCount, Icons.block_flipped, Colors.red),
    ];

    if (isDesktop) {
      return Row(
        children: widgets.map((w) => Expanded(child: w)).toList(),
      );
    } else {
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
          'Mess Approval Portal',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            tooltip: 'Reload Mess Mock Data',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              initState();
              setState(() {});
              _showSnackBar('Mess listings state re-initialized.');
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
              _buildStatsWidget(context),
              const SizedBox(height: 24),

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

              TextField(
                decoration: InputDecoration(
                  labelText: 'Search Mess Outlets',
                  hintText: 'Search by mess name, owner, license, contact...',
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

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Pending', 'Approved', 'Rejected', 'Suspended'].map((filter) {
                    final isSelected = _selectedFilter == filter;
                    final count = switch (filter) {
                      'All' => _totalCount,
                      'Pending' => _pendingCount,
                      'Approved' => _approvedCount,
                      'Rejected' => _rejectedCount,
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mess Outlets (${_filteredMesses.length})',
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

              if (_filteredMesses.isEmpty)
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
                      Icon(Icons.restaurant_outlined, size: 48, color: colorScheme.onSurfaceVariant.withOpacity(0.5)),
                      const SizedBox(height: 12),
                      Text(
                        'No Matching Outlets',
                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'No mess applications match your current search or filter query.',
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                )
              else
                ..._filteredMesses.map((mess) {
                  return MessApprovalCard(
                    mess: mess,
                    onApprove: () => _approveMess(mess),
                    onReject: () => _rejectMess(mess),
                    onSuspend: () => _suspendMess(mess),
                    onReactivate: () => _reactivateMess(mess),
                    onViewDocuments: () => _viewMessDocuments(mess),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}
