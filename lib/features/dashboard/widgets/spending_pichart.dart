import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sub_tracker/data/models/subscription.dart';
import 'package:sub_tracker/theme.dart';

const _chartSize = 240.0;
const _ringStroke = 18.0;
const _ringInset = 18.0;

class SpendingPichart extends StatefulWidget {
  const SpendingPichart({
    super.key,
    required this.totals,
    required this.serviceCount,
    required this.currencySymbol,
  });

  final Map<SpendCategory, double> totals;
  final int serviceCount;
  final String currencySymbol;

  @override
  State<SpendingPichart> createState() => _SpendingPichartState();
}

class _SpendingPichartState extends State<SpendingPichart> {
  int? _hoveredSegmentIndex;

  List<_PichartSegment> _segments() {
    final subs = widget.totals[SpendCategory.subscriptions] ?? 0;
    final util = widget.totals[SpendCategory.utilities] ?? 0;
    final ent = widget.totals[SpendCategory.entertainment] ?? 0;
    final sum = subs + util + ent;

    double norm(double v) => sum > 0 ? v / sum : 0.0;

    return [
      _PichartSegment(
        label: 'Subscriptions',
        amount: subs,
        fraction: norm(subs),
        color: AppTheme.secondary.withValues(alpha: 0.40),
      ),
      _PichartSegment(
        label: 'Utilities',
        amount: util,
        fraction: norm(util),
        color: AppTheme.primaryContainer,
      ),
      _PichartSegment(
        label: 'Entertainment',
        amount: ent,
        fraction: norm(ent),
        color: AppTheme.tertiary.withValues(alpha: 0.60),
      ),
    ];
  }

  void _updateHover(Offset localPosition) {
    final segments = _segments();
    final index = _PichartHitTest.segmentAt(
      localPosition,
      const Size(_chartSize, _chartSize),
      segments,
    );
    if (index != _hoveredSegmentIndex) {
      setState(() => _hoveredSegmentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final segments = _segments();

    return Column(
      children: [
        Center(
          child: SizedBox(
            width: _chartSize,
            height: _chartSize,
            child: MouseRegion(
              onHover: (event) => _updateHover(event.localPosition),
              onExit: (_) {
                if (_hoveredSegmentIndex != null) {
                  setState(() => _hoveredSegmentIndex = null);
                }
              },
              child: Listener(
                onPointerDown: (event) => _updateHover(event.localPosition),
                onPointerMove: (event) => _updateHover(event.localPosition),
                onPointerUp: (_) {
                  if (_hoveredSegmentIndex != null) {
                    setState(() => _hoveredSegmentIndex = null);
                  }
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CustomPaint(
                      size: const Size(_chartSize, _chartSize),
                      painter: _PichartPainter(
                        segments: segments,
                        hoveredIndex: _hoveredSegmentIndex,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${widget.serviceCount}',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'SERVICES',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.6,
                                color: AppTheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_hoveredSegmentIndex != null)
                      _PichartHoverTooltip(
                        segment: segments[_hoveredSegmentIndex!],
                        segmentIndex: _hoveredSegmentIndex!,
                        allSegments: segments,
                        currencySymbol: widget.currencySymbol,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _LegendDot(label: 'Subscr.', color: AppTheme.secondary),
            _LegendDot(label: 'Utilities', color: AppTheme.primaryContainer),
            _LegendDot(label: 'Ent.', color: AppTheme.tertiary),
          ],
        ),
      ],
    );
  }
}

class _PichartSegment {
  const _PichartSegment({
    required this.label,
    required this.amount,
    required this.fraction,
    required this.color,
  });

  final String label;
  final double amount;
  final double fraction;
  final Color color;
}

class _PichartHitTest {
  static int? segmentAt(
    Offset localPosition,
    Size size,
    List<_PichartSegment> segments,
  ) {
    final center = Offset(size.width / 2, size.height / 2);
    final dx = localPosition.dx - center.dx;
    final dy = localPosition.dy - center.dy;
    final dist = math.sqrt(dx * dx + dy * dy);

    final radius = math.min(size.width, size.height) / 2 - _ringInset;
    final inner = radius - _ringStroke / 2 - 6;
    final outer = radius + _ringStroke / 2 + 6;
    if (dist < inner || dist > outer) return null;

    final totalFraction =
        segments.fold<double>(0, (a, s) => a + s.fraction.clamp(0, 1));
    if (totalFraction < 0.001) return null;

    var t = math.atan2(dy, dx) + math.pi / 2;
    if (t < 0) t += 2 * math.pi;

    var cursor = 0.0;
    for (var i = 0; i < segments.length; i++) {
      final sweep = segments[i].fraction.clamp(0, 1) * 2 * math.pi;
      if (sweep <= 0) continue;
      if (t >= cursor && t < cursor + sweep) return i;
      cursor += sweep;
    }
    return null;
  }
}

class _PichartHoverTooltip extends StatelessWidget {
  const _PichartHoverTooltip({
    required this.segment,
    required this.segmentIndex,
    required this.allSegments,
    required this.currencySymbol,
  });

  final _PichartSegment segment;
  final int segmentIndex;
  final List<_PichartSegment> allSegments;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    var start = -math.pi / 2;
    for (var i = 0; i < segmentIndex; i++) {
      start += allSegments[i].fraction.clamp(0, 1) * 2 * math.pi;
    }
    final sweep = segment.fraction.clamp(0, 1) * 2 * math.pi;
    final mid = start + sweep / 2;

    final radius = _chartSize / 2 - _ringInset;
    final cx = _chartSize / 2;
    final cy = _chartSize / 2;
    final tipX = cx + radius * 0.92 * math.cos(mid);
    final tipY = cy + radius * 0.92 * math.sin(mid);

    final cost = NumberFormat.currency(
      symbol: currencySymbol,
      decimalDigits: 0,
    ).format(segment.amount);

    return Positioned(
      left: (tipX - 56).clamp(4, _chartSize - 112),
      top: (tipY - 36).clamp(4, _chartSize - 32),
      child: IgnorePointer(
        child: Material(
          color: AppTheme.surfaceContainerHighest,
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              '${segment.label} · $cost',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppTheme.onSurface.withValues(alpha: 0.75),
          ),
        ),
      ],
    );
  }
}

class _PichartPainter extends CustomPainter {
  _PichartPainter({
    required this.segments,
    this.hoveredIndex,
  });

  final List<_PichartSegment> segments;
  final int? hoveredIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - _ringInset;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _ringStroke
      ..strokeCap = StrokeCap.butt;

    final totalSweep = segments.fold<double>(
      0,
      (a, s) => a + (s.fraction.clamp(0, 1) * math.pi * 2),
    );
    if (totalSweep < 0.001) {
      paint.color = AppTheme.primaryContainer.withValues(alpha: 0.25);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        0,
        math.pi * 2,
        false,
        paint,
      );
      return;
    }

    var start = -math.pi / 2;
    for (var i = 0; i < segments.length; i++) {
      final seg = segments[i];
      final sweep = seg.fraction.clamp(0, 1) * math.pi * 2;
      if (sweep <= 0) continue;

      var color = seg.color;
      if (hoveredIndex == i) {
        color = Color.lerp(color, Colors.white, 0.18) ?? color;
      }

      paint.color = color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        false,
        paint,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _PichartPainter oldDelegate) {
    if (hoveredIndex != oldDelegate.hoveredIndex) return true;
    if (segments.length != oldDelegate.segments.length) return true;
    for (var i = 0; i < segments.length; i++) {
      if (segments[i].fraction != oldDelegate.segments[i].fraction) {
        return true;
      }
    }
    return false;
  }
}
