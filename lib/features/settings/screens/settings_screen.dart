import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_tracker/data/subscription_repository.dart';
import 'package:sub_tracker/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.repo});

  final SubscriptionRepository repo;

  Future<void> _confirmClearAll(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceContainer,
        title: Text(
          'Clear all subscriptions?',
          style: GoogleFonts.inter(color: AppTheme.onSurface),
        ),
        content: Text(
          'This removes every saved subscription. This cannot be undone.',
          style: GoogleFonts.inter(color: AppTheme.outline),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Clear',
              style: GoogleFonts.inter(
                color: AppTheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      repo.clearAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: repo,
          builder: (context, _) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              children: [
                Text(
                  'SETTINGS',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 28),
                _sectionTitle('DATA'),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _confirmClearAll(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.error,
                      side: const BorderSide(color: AppTheme.error),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Clear all subscriptions',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                _sectionTitle('PREFERENCES'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.outlineVariant),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Currency',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: AppTheme.onSurface,
                        ),
                      ),
                      const Spacer(),
                      DropdownButton<String>(
                        value: repo.currencySymbol,
                        dropdownColor: AppTheme.surfaceContainer,
                        underline: const SizedBox.shrink(),
                        items: [
                          for (final symbol in SubscriptionRepository.currencyOptions)
                            DropdownMenuItem(
                              value: symbol,
                              child: Text(symbol),
                            ),
                        ],
                        onChanged: (value) {
                          if (value != null) repo.setCurrency(value);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                _sectionTitle('ABOUT'),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.outlineVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Subtrackr v1.0',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Offline subscription tracker.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppTheme.outline,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'All data stored on this device.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppTheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: AppTheme.secondary,
      ),
    );
  }
}
