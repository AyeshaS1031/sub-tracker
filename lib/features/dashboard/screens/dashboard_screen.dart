import 'package:flutter/material.dart';
import 'package:sub_tracker/data/subscription_repository.dart';
import 'package:sub_tracker/features/dashboard/widgets/dashboard_header_title.dart';
import 'package:sub_tracker/features/dashboard/widgets/deinfluencing_tip_card.dart';
import 'package:sub_tracker/features/dashboard/widgets/monthly_spending_history_card.dart';
import 'package:sub_tracker/features/dashboard/widgets/spending_pichart.dart';
import 'package:sub_tracker/features/dashboard/widgets/your_burn_section.dart';
import 'package:sub_tracker/theme.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key, required this.repo, this.onMenuPressed});

  final SubscriptionRepository repo;
  final VoidCallback? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: repo,
          builder: (context, _) {
            final burn = repo.monthlyBurnTotal();
            final totals = repo.totalsByCategory();
            final svcCount = repo.serviceCount();
            final hist = repo.spendingLastSixMonths();
            final avg = repo.averageFromBars(hist.amounts);

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: DashboardHeaderTitle(
                    onMenuPressed: onMenuPressed,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      YourBurnSection(
                        monthlyTotal: burn,
                        currencySymbol: repo.currencySymbol,
                        showPlaceholderWhenEmpty: svcCount == 0,
                      ),
                      const SizedBox(height: 32),
                      SpendingPichart(
                        totals: totals,
                        serviceCount: svcCount,
                        currencySymbol: repo.currencySymbol,
                      ),
                      const SizedBox(height: 24),
                      MonthlySpendingHistoryCard(
                        months: hist.months,
                        amounts: hist.amounts,
                        avgMonthly: avg,
                        currencySymbol: repo.currencySymbol,
                      ),
                      const SizedBox(height: 20),
                      const DeinfluencingTipCard(),
                      const SizedBox(height: 24),
                    ]),
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
