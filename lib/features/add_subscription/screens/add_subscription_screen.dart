import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
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
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
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
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Monthly cost (\$)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Category',
              style: Theme.of(context).textTheme.labelLarge,
            ),
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
