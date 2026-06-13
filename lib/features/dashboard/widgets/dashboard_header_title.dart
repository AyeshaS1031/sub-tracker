import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_tracker/theme.dart';

class DashboardHeaderTitle extends StatelessWidget {
  const DashboardHeaderTitle({
    super.key,
    this.title = 'SUBTRACKR',
    this.onMenuPressed,
  });

  final String title;
  final VoidCallback? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: Color(0xE60E0E0E),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onMenuPressed,
            icon: Icon(Icons.grid_view_rounded, color: AppTheme.primary),
          ),
          Text(
            title,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 3.2,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
