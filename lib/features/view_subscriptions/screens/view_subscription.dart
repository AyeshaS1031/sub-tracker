import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
            final activeCount = subs.where((s) => s.isActive).length;

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
                    '$activeCount active · ${subs.length} total',
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
                          repo: repo,
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
    required this.repo,
    required this.amountLabel,
  });

  final Subscription sub;
  final SubscriptionRepository repo;
  final String amountLabel;

  @override
  Widget build(BuildContext context) {
    final opacity = sub.isActive ? 1.0 : 0.55;
    final deadlineText = sub.deadline != null
        ? DateFormat.yMMMd().format(sub.deadline!)
        : null;

    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: sub.isOverdue ? AppTheme.error : AppTheme.outlineVariant,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          sub.name,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.onSurface,
                            decoration: sub.isActive
                                ? null
                                : TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                      if (!sub.isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Inactive',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.outline,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sub.categoryLabel,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.outline,
                    ),
                  ),
                  if (deadlineText != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      sub.isOverdue
                          ? 'Overdue · $deadlineText'
                          : 'Due $deadlineText',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: sub.isOverdue ? AppTheme.error : AppTheme.secondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amountLabel,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: sub.isActive ? AppTheme.secondary : AppTheme.outline,
                  ),
                ),
                Switch(
                  value: sub.isActive,
                  activeThumbColor: AppTheme.secondary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (v) => repo.setActive(sub.id, v),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
