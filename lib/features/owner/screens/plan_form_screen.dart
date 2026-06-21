import 'package:flutter/material.dart';

import 'plan_management_screen.dart'; // To get the Plan model import

class PlanFormScreen extends StatefulWidget {
  final Plan? initialPlan;

  const PlanFormScreen({
    super.key,
    this.initialPlan,
  });

  @override
  State<PlanFormScreen> createState() => _PlanFormScreenState();
}

class _PlanFormScreenState extends State<PlanFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _durationDaysController;
  late final TextEditingController _customNoteController;

  bool _hasBreakfast = true;
  bool _hasLunch = true;
  bool _hasDinner = true;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    final p = widget.initialPlan;

    _nameController = TextEditingController(text: p?.name ?? '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _priceController = TextEditingController(text: p != null ? p.price.toStringAsFixed(0) : '3000');
    _durationDaysController = TextEditingController(text: p != null ? p.durationDays.toString() : '30');
    _customNoteController = TextEditingController(text: p?.customNote ?? '');

    _hasBreakfast = p?.hasBreakfast ?? true;
    _hasLunch = p?.hasLunch ?? true;
    _hasDinner = p?.hasDinner ?? true;
    _isActive = p?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationDaysController.dispose();
    _customNoteController.dispose();
    super.dispose();
  }

  bool get _isEditMode => widget.initialPlan != null;

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Custom check: must select at least one meal
    if (!_hasBreakfast && !_hasLunch && !_hasDinner) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one meal (Breakfast, Lunch, or Dinner).'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final double price = double.tryParse(_priceController.text) ?? 0.0;
    final int duration = int.tryParse(_durationDaysController.text) ?? 30;

    final updatedPlan = Plan(
      id: widget.initialPlan?.id ?? 'plan_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      price: price,
      durationDays: duration,
      hasBreakfast: _hasBreakfast,
      hasLunch: _hasLunch,
      hasDinner: _hasDinner,
      customNote: _customNoteController.text.trim().isEmpty ? null : _customNoteController.text.trim(),
      isActive: _isActive,
      subscriberCount: widget.initialPlan?.subscriberCount ?? 0,
    );

    Navigator.pop(context, updatedPlan);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Plan' : 'Create Subscription Plan'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Section Title - Details
                Text(
                  'Plan Details',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),

                // Name Input
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Plan Name*',
                    hintText: 'e.g. Premium Unlimited Combo',
                    prefixIcon: const Icon(Icons.title),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter plan name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description Input
                TextFormField(
                  controller: _descriptionController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Describe details like meal quantities or specific limits...',
                    prefixIcon: const Icon(Icons.description_outlined),
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Pricing Row
                Row(
                  children: [
                    // Price
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Price (₹)*',
                          hintText: '3000',
                          prefixIcon: const Icon(Icons.currency_rupee),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required';
                          }
                          final p = double.tryParse(value);
                          if (p == null || p <= 0) {
                            return 'Invalid price';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Duration Days
                    Expanded(
                      child: TextFormField(
                        controller: _durationDaysController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Validity (Days)*',
                          hintText: '30',
                          prefixIcon: const Icon(Icons.calendar_today_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required';
                          }
                          final d = int.tryParse(value);
                          if (d == null || d <= 0) {
                            return 'Invalid days';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // MEAL COMBINATIONS SECTION
                Text(
                  'Meal Configuration*',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Select meal types available in this subscription plan.',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),

                // Meals Card
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        value: _hasBreakfast,
                        onChanged: (val) => setState(() => _hasBreakfast = val),
                        title: const Text('Breakfast'),
                        subtitle: const Text('Include early morning breakfast meals'),
                        secondary: const Icon(Icons.wb_twilight_outlined),
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        value: _hasLunch,
                        onChanged: (val) => setState(() => _hasLunch = val),
                        title: const Text('Lunch'),
                        subtitle: const Text('Include afternoon lunch meals'),
                        secondary: const Icon(Icons.wb_sunny_outlined),
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        value: _hasDinner,
                        onChanged: (val) => setState(() => _hasDinner = val),
                        title: const Text('Dinner'),
                        subtitle: const Text('Include evening dinner meals'),
                        secondary: const Icon(Icons.nights_stay_outlined),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // OPTIONAL DETAILS & NOTES SECTION
                Text(
                  'Policy / Notes',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _customNoteController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Custom Note (Optional)',
                    hintText: 'e.g. Sunday Off, No Dinner on Festivals',
                    prefixIcon: const Icon(Icons.bookmark_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // STATUS TOGGLE SECTION
                Text(
                  'Publish Status',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),

                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  child: SwitchListTile(
                    value: _isActive,
                    onChanged: (val) => setState(() => _isActive = val),
                    title: const Text('Active'),
                    subtitle: const Text('If inactive, users cannot choose or renew this plan'),
                    secondary: Icon(
                      _isActive ? Icons.check_circle_outlined : Icons.block_flipped,
                      color: _isActive ? Colors.green : Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Form submission buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton(
                        onPressed: _submitForm,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(_isEditMode ? 'Update Plan' : 'Create Plan'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
