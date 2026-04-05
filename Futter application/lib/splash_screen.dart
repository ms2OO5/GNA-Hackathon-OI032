// lib/splash_screen.dart

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'localization/localization.dart';

class SplashScreen extends StatefulWidget {
  final AppLocalization loc;
  final VoidCallback onFinished;

  const SplashScreen({
    super.key,
    required this.loc,
    required this.onFinished,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // 2.5 sec ke baad main app open
    Timer(const Duration(milliseconds: 2500), () {
      widget.onFinished();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = widget.loc;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0C3C34),
            Color(0xFF03141D),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // EcoBuddy logo
                Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF39D98A),
                        Color(0xFF3CB371),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.recycling,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  loc.t(LocKeys.appName),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  loc.t(LocKeys.loading),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.75),
                  ),
                ),
                const SizedBox(height: 32),

                // animated eco ring loader
                SizedBox(
                  width: 72,
                  height: 72,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _controller.value * 2 * math.pi,
                        child: child,
                      );
                    },
                    child: CustomPaint(
                      painter: SplashRingPainter(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small fancy multi‑segment ring loader
class SplashRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 6;
    final rect = Rect.fromCircle(center: center, radius: radius);

    const strokeWidth = 7.0;
    const startAngle = -3.8; // almost top‑left
    const sweepTotal = 4.4;

    // dark background arc
    final bgPaint = Paint()
      ..color = const Color(0xFF0B2830)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, sweepTotal, false, bgPaint);

    final segments = <_RingSegment>[
      _RingSegment(
        color: const Color(0xFFF4A949), // orange-ish
        fraction: 0.22,
      ),
      _RingSegment(
        color: const Color(0xFF23B3A3), // teal
        fraction: 0.30,
      ),
      _RingSegment(
        color: const Color(0xFF39D98A), // green
        fraction: 0.46,
      ),
    ];

    const gapFraction = 0.03;
    double current = startAngle;

    for (final seg in segments) {
      final sweep = sweepTotal * seg.fraction;
      final paint = Paint()
        ..color = seg.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, current, sweep, false, paint);
      current += sweep + sweepTotal * gapFraction;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RingSegment {
  final Color color;
  final double fraction;

  const _RingSegment({
    required this.color,
    required this.fraction,
  });
}