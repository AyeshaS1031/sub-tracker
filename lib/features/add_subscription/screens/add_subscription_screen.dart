import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sub_tracker/data/models/subscription.dart';
import 'package:sub_tracker/data/subscription_repository.dart';
import 'package:sub_tracker/theme.dart';

class AddSubscriptionScreen extends StatefulWidget {
  const AddSubscriptionScreen({super.key, required this.repo});

  final SubscriptionRepository repo;

  @override
  State<AddSubscriptionScreen> createState() => _AddSubscriptionScreenState();
}

class _AddSubscriptionScreenState extends State<AddSubscriptionScreen> {
  final _nameCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  SpendCategory _cat = SpendCategory.subscriptions;
  bool _isActive = true;
  DateTime? _deadline;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.secondary,
              onPrimary: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _deadline = picked);
    }
  }

  void _save() {
    final name = _nameCtrl.text.trim();
    final raw = double.tryParse(_amountCtrl.text.trim());

    if (name.isEmpty || raw == null || raw <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Need a name and a positive amount')),
      );
      return;
    }

    widget.repo.addSubscription(
      name: name,
      monthlyAmount: raw,
      category: _cat,
      isActive: _isActive,
      deadline: _deadline,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final deadlineLabel = _deadline == null
        ? 'No deadline set'
        : DateFormat.yMMMd().format(_deadline!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add subscription'),
        backgroundColor: AppTheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Monthly cost (${widget.repo.currencySymbol})',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text('Category', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 6),
            DropdownButton<SpendCategory>(
              value: _cat,
              isExpanded: true,
              dropdownColor: AppTheme.surfaceContainer,
              items: const [
                DropdownMenuItem(
                  value: SpendCategory.subscriptions,
                  child: Text('Subscriptions'),
                ),
                DropdownMenuItem(
                  value: SpendCategory.utilities,
                  child: Text('Utilities'),
                ),
                DropdownMenuItem(
                  value: SpendCategory.entertainment,
                  child: Text('Entertainment'),
                ),
              ],
              onChanged: (v) {
                if (v != null) {
                  setState(() {
                    _cat = v;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Active'),
              subtitle: Text(
                _isActive
                    ? 'Counts toward monthly burn'
                    : 'Paused — excluded from totals',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.outline,
                ),
              ),
              value: _isActive,
              activeThumbColor: AppTheme.secondary,
              onChanged: (v) => setState(() => _isActive = v),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Renewal deadline'),
              subtitle: Text(
                deadlineLabel,
                style: TextStyle(
                  color: _deadline == null ? AppTheme.outline : AppTheme.onSurface,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_deadline != null)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      color: AppTheme.outline,
                      tooltip: 'Clear deadline',
                      onPressed: () => setState(() => _deadline = null),
                    ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    color: AppTheme.secondary,
                    tooltip: 'Pick date',
                    onPressed: _pickDeadline,
                  ),
                ],
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.secondary,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
