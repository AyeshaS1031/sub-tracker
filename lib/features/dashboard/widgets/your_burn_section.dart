import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_tracker/theme.dart';

class YourBurnSection extends StatelessWidget {
  const YourBurnSection({
    super.key,
    required this.monthlyTotal,
    required this.currencySymbol,
    this.showPlaceholderWhenEmpty = true,
  });

  final double monthlyTotal;
  final String currencySymbol;
  final bool showPlaceholderWhenEmpty;

  @override
  Widget build(BuildContext context) {
    final empty = monthlyTotal <= 0 && showPlaceholderWhenEmpty;
    final display =
        empty ? '--' : '$currencySymbol${monthlyTotal.toStringAsFixed(2)}';

    return Column(
      children: [
        Text(
          'YOUR BURN',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
            color: AppTheme.secondary,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 260,
                height: 140,
                decoration: BoxDecoration(
                  color: AppTheme.secondary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              Text(
                display,
                textAlign: TextAlign.center,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 72,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                  letterSpacing: -1.5,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'MONTHLY BURN RATE',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
            color: AppTheme.outlineVariant,
          ),
        ),
      ],
    );
  }
}
