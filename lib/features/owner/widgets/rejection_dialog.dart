import 'package:flutter/material.dart';

class RejectionDialog extends StatefulWidget {
  final String customerName;
  final ValueChanged<String> onReject;

  const RejectionDialog({
    super.key,
    required this.customerName,
    required this.onReject,
  });

  @override
  State<RejectionDialog> createState() => _RejectionDialogState();
}

class _RejectionDialogState extends State<RejectionDialog> {
  String? _selectedReason;
  final TextEditingController _customReasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<String> _predefinedReasons = [
    'Capacity Full',
    'Not Eligible',
    'Incomplete Information',
    'Other',
  ];

  @override
  void dispose() {
    _customReasonController.dispose();
    super.dispose();
  }

  bool get _isReasonValid {
    if (_selectedReason == null) return false;
    if (_selectedReason == 'Other') {
      return _customReasonController.text.trim().isNotEmpty;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Reject Join Request',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.error,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Provide a reason for rejecting the requested subscription from ${widget.customerName}.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._predefinedReasons.map((reason) {
                      final isSelected = _selectedReason == reason;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          reason,
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                          ),
                        ),
                        leading: Radio<String>(
                          value: reason,
                          groupValue: _selectedReason,
                          activeColor: colorScheme.primary,
                          onChanged: (value) {
                            setState(() {
                              _selectedReason = value;
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            _selectedReason = reason;
                          });
                        },
                      );
                    }),
                    if (_selectedReason == 'Other') ...[
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _customReasonController,
                        autofocus: true,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'Enter rejection reason...',
                          helperText: 'Reason is required',
                          alignLabelWithHint: true,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a rejection reason';
                          }
                          return null;
                        },
                        onChanged: (_) {
                          setState(() {}); // Trigger refresh to re-evaluate button activation
                        },
                      ),
                    ],
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            foregroundColor: colorScheme.onSurfaceVariant,
                          ),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _isReasonValid
                              ? () {
                                  final finalReason = _selectedReason == 'Other'
                                      ? _customReasonController.text.trim()
                                      : _selectedReason!;
                                  widget.onReject(finalReason);
                                  Navigator.pop(context);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.error,
                            foregroundColor: colorScheme.onError,
                            disabledBackgroundColor: colorScheme.error.withAlpha(50),
                            disabledForegroundColor: colorScheme.onError.withAlpha(150),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Reject',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
