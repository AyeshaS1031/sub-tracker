import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_tracker/data/subscription_repository.dart';
import 'package:sub_tracker/features/navigation/screens/app_shell_screen.dart';
import 'package:sub_tracker/theme.dart';

const Duration _kSplashNavigateDelay = Duration(seconds: 3);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.repo});

  final SubscriptionRepository repo;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_kSplashNavigateDelay, _goMain);
  }

  void _goMain() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => AppShellScreen(repo: widget.repo),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            const _SplashBackdrop(),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'SUBTRACKR',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'THE DE-INFLUENCING FINANCIAL WELLNESS TOOL.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.1,
                        color: const Color(0xFF9A9A9A),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SplashBackdrop extends StatelessWidget {
  const _SplashBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.surfaceContainerLow.withValues(alpha: 0.95),
                AppTheme.background,
                const Color.fromARGB(255, 21, 21, 33).withValues(alpha: 0.9),
              ],
              stops: const [0.0, 0.52, 1.0],
            ),
          ),
        ),
        Positioned(
          left: -40,
          top: -30,
          child: Transform.rotate(
            angle: -0.12,
            child: Container(
              width: 180,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.surfaceBright.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        Positioned(
          right: -50,
          bottom: -40,
          child: Transform.rotate(
            angle: 0.1,
            child: Container(
              width: 200,
              height: 140,
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
