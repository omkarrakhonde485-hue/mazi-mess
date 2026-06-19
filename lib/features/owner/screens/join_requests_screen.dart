import 'package:flutter/material.dart';

import '../widgets/approval_bottom_sheet.dart';
import '../widgets/join_request_card.dart';
import '../widgets/rejection_dialog.dart';

class MockJoinRequest {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String mobileNumber;
  final String requestedPlan;
  final double planPrice;
  final String requestTime;
  final String avatarUrl;
  String status; // 'Pending', 'Approved', 'Rejected'
  String? rejectionReason;

  MockJoinRequest({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.mobileNumber,
    required this.requestedPlan,
    required this.planPrice,
    required this.requestTime,
    required this.avatarUrl,
    this.status = 'Pending',
    this.rejectionReason,
  });
}

class JoinRequestsScreen extends StatefulWidget {
  const JoinRequestsScreen({super.key});

  @override
  State<JoinRequestsScreen> createState() => _JoinRequestsScreenState();
}

class _JoinRequestsScreenState extends State<JoinRequestsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'Pending'; // Default starting category is 'Pending' requested

  // 12 mock join requests as requested in SPEC
  late List<MockJoinRequest> _allRequests;

  @override
  void initState() {
    super.initState();
    _allRequests = [
      MockJoinRequest(
        id: '1',
        name: 'Rahul Patil',
        age: 20,
        gender: 'Male',
        mobileNumber: '9876543210',
        requestedPlan: 'Monthly Veg Plan',
        planPrice: 3000,
        requestTime: 'Requested 2 hours ago',
        avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80',
      ),
      MockJoinRequest(
        id: '2',
        name: 'Sneha Sharma',
        age: 22,
        gender: 'Female',
        mobileNumber: '9765432109',
        requestedPlan: 'Premium Unlimited L&D',
        planPrice: 4500,
        requestTime: 'Requested 10 mins ago',
        avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150&q=80',
      ),
      MockJoinRequest(
        id: '3',
        name: 'Rohan Gaikwad',
        age: 21,
        gender: 'Male',
        mobileNumber: '9654321098',
        requestedPlan: 'Standard 2 Meals/Day',
        planPrice: 3500,
        requestTime: 'Requested 1 hour ago',
        avatarUrl: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&w=150&q=80',
      ),
      MockJoinRequest(
        id: '4',
        name: 'Kajal Patel',
        age: 19,
        gender: 'Female',
        mobileNumber: '9543210987',
        requestedPlan: 'Monthly Basic Plan',
        planPrice: 2800,
        requestTime: 'Requested 4 hours ago',
        avatarUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=150&q=80',
      ),
      MockJoinRequest(
        id: '5',
        name: 'Tanmay Deshmukh',
        age: 23,
        gender: 'Male',
        mobileNumber: '9432109876',
        requestedPlan: 'Premium Unlimited L&D',
        planPrice: 4500,
        requestTime: 'Requested 5 hours ago',
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=150&q=80',
      ),
      MockJoinRequest(
        id: '6',
        name: 'Preeti Verma',
        age: 24,
        gender: 'Female',
        mobileNumber: '9321098765',
        requestedPlan: 'Monthly Veg Plan',
        planPrice: 3000,
        requestTime: 'Requested Yesterday',
        avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=150&q=80',
      ),
      MockJoinRequest(
        id: '7',
        name: 'Amit Kulkarni',
        age: 25,
        gender: 'Male',
        mobileNumber: '9210987654',
        requestedPlan: 'Standard 2 Meals/Day',
        planPrice: 3500,
        requestTime: 'Requested 1 day ago',
        avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=150&q=80',
      ),
      MockJoinRequest(
        id: '8',
        name: 'Shweta Singh',
        age: 20,
        gender: 'Female',
        mobileNumber: '9109876543',
        requestedPlan: 'Monthly Basic Plan',
        planPrice: 2800,
        requestTime: 'Requested 2 days ago',
        avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80',
      ),
      MockJoinRequest(
        id: '9',
        name: 'Manoj Nair',
        age: 22,
        gender: 'Male',
        mobileNumber: '9098765432',
        requestedPlan: 'Monthly Veg Plan',
        planPrice: 3000,
        requestTime: 'Requested 2 days ago',
        avatarUrl: 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?auto=format&fit=crop&w=150&q=80',
      ),
      MockJoinRequest(
        id: '10',
        name: 'Neha Joshi',
        age: 21,
        gender: 'Female',
        mobileNumber: '8987654321',
        requestedPlan: 'Premium Unlimited L&D',
        planPrice: 4500,
        requestTime: 'Requested 3 days ago',
        avatarUrl: 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?auto=format&fit=crop&w=150&q=80',
      ),
      MockJoinRequest(
        id: '11',
        name: 'Vinay Shinde',
        age: 23,
        gender: 'Male',
        mobileNumber: '8876543210',
        requestedPlan: 'Standard 2 Meals/Day',
        planPrice: 3500,
        requestTime: 'Requested 3 days ago',
        avatarUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=150&q=80',
      ),
      MockJoinRequest(
        id: '12',
        name: 'Aditya Rao',
        age: 22,
        gender: 'Male',
        mobileNumber: '8765432109',
        requestedPlan: 'Monthly Basic Plan',
        planPrice: 2800,
        requestTime: 'Requested 4 days ago',
        avatarUrl: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&w=150&q=80',
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter current requests based on query and selected tab
  List<MockJoinRequest> get _filteredRequests {
    return _allRequests.where((req) {
      // 1. Tab segment filter
      if (_selectedFilter != 'All' && req.status != _selectedFilter) {
        return false;
      }
      // 2. Search query filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final nameMatches = req.name.toLowerCase().contains(query);
        final phoneMatches = req.mobileNumber.contains(query);
        return nameMatches || phoneMatches;
      }
      return true;
    }).toList();
  }

  int get _pendingCount => _allRequests.where((r) => r.status == 'Pending').length;
  int get _approvedCount => _allRequests.where((r) => r.status == 'Approved').length;
  int get _rejectedCount => _allRequests.where((r) => r.status == 'Rejected').length;

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  void _showProfileBottomSheet(MockJoinRequest request) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(request.avatarUrl),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.name,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Age ${request.age} • ${request.gender}',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),
              Text(
                'Verification Documents',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildDocumentRow(context, 'Primary ID Card (Aadhaar/PAN)', 'Verified ✅'),
              _buildDocumentRow(context, 'College ID or Work Email', 'Verified ✅'),
              const Divider(height: 32),
              _buildDocumentRow(context, 'Registered Address', 'Hostel A, Near Symbiosis, Pune'),
              _buildDocumentRow(context, 'Diet Preference', 'Vegetarian (No Onion-Garlic option)'),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDocumentRow(BuildContext context, String title, String val) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
          Text(val, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _approveJoinRequest(MockJoinRequest request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ApprovalBottomSheet(
          customerName: request.name,
          mobileNumber: request.mobileNumber,
          planName: request.requestedPlan,
          planPrice: '₹${request.planPrice.toStringAsFixed(0)}',
          requestDate: 'Requested ${request.requestTime.replaceAll("Requested ", "")}',
          onApprove: () {
            setState(() {
              request.status = 'Approved';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Request approved for ${request.name} successfully!'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
          },
        );
      },
    );
  }

  void _rejectJoinRequest(MockJoinRequest request) {
    showDialog(
      context: context,
      builder: (context) {
        return RejectionDialog(
          customerName: request.name,
          onReject: (reason) {
            setState(() {
              request.status = 'Rejected';
              request.rejectionReason = reason;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Request from ${request.name} rejected: $reason'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Theme.of(context).colorScheme.error,
                duration: const Duration(seconds: 3),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final filtered = _filteredRequests;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Join Requests',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: colorScheme.surface,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Search Box Component
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _clearSearch,
                        )
                      : null,
                  hintText: 'Search by Name or Mobile number...',
                  hintStyle: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant.withAlpha(180),
                  ),
                ),
              ),
            ),

            // 2. Filter Category Chips Scroll
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  _buildFilterTab('All', _allRequests.length),
                  const SizedBox(width: 8),
                  _buildFilterTab('Pending', _pendingCount),
                  const SizedBox(width: 8),
                  _buildFilterTab('Approved', _approvedCount),
                  const SizedBox(width: 8),
                  _buildFilterTab('Rejected', _rejectedCount),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 3. Pending Requests Dynamic Header (Mandatory Requirement)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pending Requests ($_pendingCount)',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  if (filtered.length != _allRequests.length)
                    Text(
                      'Filtered: ${filtered.length}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),

            // 4. Request Listing / Empty state mapping
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final req = filtered[index];
                        return JoinRequestCard(
                          request: req,
                          onViewProfile: () => _showProfileBottomSheet(req),
                          onReject: () => _rejectJoinRequest(req),
                          onApprove: () => _approveJoinRequest(req),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(String label, int count) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = _selectedFilter == label;

    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.onPrimary
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedFilter = label;
          });
        }
      },
      selectedColor: colorScheme.primary,
      backgroundColor: colorScheme.surfaceContainerLow,
      labelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? Colors.transparent : colorScheme.outlineVariant,
        ),
      ),
      showCheckmark: false,
    );
  }

  Widget _buildEmptyState() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.error.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.people_outline,
                size: 64,
                color: colorScheme.primary.withAlpha(150),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Join Requests Found',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filter options or search term to discover other subscription requests.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (_searchQuery.isNotEmpty || _selectedFilter != 'Pending')
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedFilter = 'All';
                    _searchController.clear();
                    _searchQuery = '';
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reset Search & Filters'),
              ),
          ],
        ),
      ),
    );
  }
}
