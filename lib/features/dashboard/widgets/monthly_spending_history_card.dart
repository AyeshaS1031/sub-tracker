import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sub_tracker/theme.dart';

class MonthlySpendingHistoryCard extends StatelessWidget {
  const MonthlySpendingHistoryCard({
    super.key,
    required this.months,
    required this.amounts,
    required this.avgMonthly,
  });

  final List<DateTime> months;
  final List<double> amounts;
  final double avgMonthly;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final maxY = amounts.fold<double>(
      1,
      (m, v) => v > m ? v : m,
    );
    final cap = maxY <= 0 ? 100.0 : maxY * 1.15;

    final avgTxt = NumberFormat.currency(symbol: r'$', decimalDigits: 0)
        .format(avgMonthly);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Monthly Spending History',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                'AVG. $avgTxt/MO',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppTheme.outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 140,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: cap,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(
                  enabled: true,
                  handleBuiltInTouches: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    tooltipMargin: 8,
                    getTooltipColor: (_) => AppTheme.surfaceContainerHighest,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final amount = amounts[groupIndex];
                      final monthLabel =
                          DateFormat('MMMM').format(months[groupIndex]);
                      final cost = NumberFormat.currency(
                        symbol: r'$',
                        decimalDigits: 0,
                      ).format(amount);
                      return BarTooltipItem(
                        '$monthLabel · $cost',
                        GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < 0 || i >= months.length) {
                          return const SizedBox.shrink();
                        }
                        final d = months[i];
                        final label =
                            DateFormat('MMM').format(d).toUpperCase();
                        final isNow =
                            d.year == now.year && d.month == now.month;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            label,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isNow
                                  ? AppTheme.secondary
                                  : AppTheme.outline,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: [
                  for (var i = 0; i < amounts.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: amounts[i],
                          width: 18,
                          borderRadius: BorderRadius.circular(5),
                          color: amounts[i] > 0
                              ? AppTheme.surfaceBright
                              : AppTheme.surfaceContainer,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
