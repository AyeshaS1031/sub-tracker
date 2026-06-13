import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_tracker/theme.dart';

const String kDefaultTipImageUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuD4hQls5l1OaNqkk4Wsv_E8Wu93QkWte54ykLka-UCzgQBU6LXmriIdDx2JKiqrdGULRILY6P9rdXaZB2hbPuPko2Gt07dVaVLqGjLvlk94pyPfysyXxlm9ck1pn6dsXP1LWBnopvWukqCtmZvShNbZuvPkU_wQN7NP06lJR053LB-puRPtxm6V7_1K4hOTiQtlgeaNYF8Iq0Pj40P71wqxlHnMWq2t4rx18ulSuBoG428FCJIJqhYkPCIwX12tPFy2xiNV-ou6ltY';

class DeInfluencingTip {
  const DeInfluencingTip({
    required this.kicker,
    required this.title,
    required this.body,
    this.imageUrl,
  });

  final String kicker;
  final String title;
  final String body;
  final String? imageUrl;
}

const DeInfluencingTip kDefaultDeInfluencingTip = DeInfluencingTip(
  kicker: 'De-influencing tip',
  title: "Stop the 'Auto-Renew' Trap",
  body:
      'Most users forget 2.4 services every year. Set Subtrackr to '
      'auto-alert you 3 days before renewal.',
  imageUrl: kDefaultTipImageUrl,
);

class DeinfluencingTipCard extends StatelessWidget {
  const DeinfluencingTipCard({super.key, this.tip});

  final DeInfluencingTip? tip;

  @override
  Widget build(BuildContext context) {
    return _TipCard(tip: tip ?? kDefaultDeInfluencingTip);
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip});

  final DeInfluencingTip tip;

  bool get _hasImage =>
      tip.imageUrl != null && tip.imageUrl!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final titleColor = _hasImage ? Colors.white : AppTheme.onSurface;
    final bodyColor = _hasImage
        ? Colors.white.withValues(alpha: 0.85)
        : AppTheme.onSurface.withValues(alpha: 0.75);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 190,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_hasImage)
              Image.network(
                tip.imageUrl!.trim(),
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const _TipImageFallbackBg();
                },
                errorBuilder: (context, error, stackTrace) =>
                    const _TipImageFallbackBg(),
              )
            else
              const _TipImageFallbackBg(),
            if (_hasImage)
              Container(color: Colors.black.withValues(alpha: 0.55)),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppTheme.surface,
                    Color(0x990E0E0E),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tip.kicker.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 3.4,
                        color: AppTheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      tip.title,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      tip.body,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        height: 1.35,
                        fontWeight: FontWeight.w400,
                        color: bodyColor,
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

class _TipImageFallbackBg extends StatelessWidget {
  const _TipImageFallbackBg();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF3D2520),
            Color(0xFF2A1815),
          ],
        ),
      ),
    );
  }
}
