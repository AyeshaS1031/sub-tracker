import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_tracker/data/models/subscription.dart';
import 'package:sub_tracker/data/subscription_repository.dart';
import 'package:sub_tracker/theme.dart';

/// Lists every subscription saved in Hive.
class ViewSubscriptionScreen extends StatelessWidget {
  const ViewSubscriptionScreen({super.key, required this.repo});

  final SubscriptionRepository repo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: repo,
          builder: (context, _) {
            final subs = repo.allSubscriptions();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Text(
                    'YOUR SUBSCRIPTIONS',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    '${subs.length} total',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.outline,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (subs.isEmpty)
                  const Expanded(child: _EmptyState())
                else
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      itemCount: subs.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return _SubscriptionTile(
                          sub: subs[index],
                          amountLabel:
                              '${repo.formatMoney(subs[index].monthlyAmount)}/mo',
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_outlined, size: 48, color: AppTheme.outline),
            const SizedBox(height: 16),
            Text(
              'Nothing here yet',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + on the Dashboard to add one.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, color: AppTheme.outline),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionTile extends StatelessWidget {
  const _SubscriptionTile({
    required this.sub,
    required this.amountLabel,
  });

  final Subscription sub;
  final String amountLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sub.name,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  sub.categoryLabel,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.outline,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amountLabel,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
