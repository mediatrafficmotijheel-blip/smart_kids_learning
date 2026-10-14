import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A cheerful sky background with clouds, sun, stars, and a grassy hill.
class CloudBackground extends StatelessWidget {
  const CloudBackground({
    super.key,
    required this.child,
    this.showSun = true,
    this.showStars = false,
  });

  final Widget child;
  final bool showSun;
  final bool showStars;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF7FD3F7),
                  Color(0xFFB6E9FF),
                  Color(0xFFE4F6FF),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: _SkyPainter(showSun: showSun, showStars: showStars),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}

class _SkyPainter extends CustomPainter {
  _SkyPainter({required this.showSun, required this.showStars});

  final bool showSun;
  final bool showStars;

  @override
  void paint(Canvas canvas, Size size) {
    if (showSun) {
      final sunCenter = Offset(size.width * 0.85, size.height * 0.12);
      final sunPaint = Paint()..color = const Color(0xFFFFD54F);
      canvas.drawCircle(sunCenter, 34, sunPaint);
      final rayPaint = Paint()
        ..color = const Color(0xFFFFEB3B)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round;
      for (var i = 0; i < 8; i++) {
        final angle = i * math.pi / 4;
        final start =
            sunCenter + Offset(math.cos(angle), math.sin(angle)) * 42;
        final end =
            sunCenter + Offset(math.cos(angle), math.sin(angle)) * 54;
        canvas.drawLine(start, end, rayPaint);
      }
    }

    if (showStars) {
      final starPaint = Paint()..color = Colors.white.withValues(alpha: 0.9);
      for (var i = 0; i < 20; i++) {
        final dx = (i * 137.5) % size.width;
        final dy = (i * 89.3) % (size.height * 0.5);
        canvas.drawCircle(Offset(dx, dy), 2, starPaint);
      }
    }

    _drawCloud(canvas, Offset(size.width * 0.15, size.height * 0.18), 1.0);
    _drawCloud(canvas, Offset(size.width * 0.55, size.height * 0.10), 0.75);
    _drawCloud(canvas, Offset(size.width * 0.85, size.height * 0.25), 0.9);
    _drawCloud(canvas, Offset(size.width * 0.30, size.height * 0.35), 0.65);

    final hillPath = Path()
      ..moveTo(0, size.height * 0.88)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.82,
        size.width * 0.5,
        size.height * 0.87,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.92,
        size.width,
        size.height * 0.85,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hillPath, Paint()..color = const Color(0xFF7CC576));

    final hill2 = Path()
      ..moveTo(0, size.height * 0.93)
      ..quadraticBezierTo(
        size.width * 0.4,
        size.height * 0.88,
        size.width * 0.8,
        size.height * 0.94,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hill2, Paint()..color = const Color(0xFF5BB05B));
  }

  void _drawCloud(Canvas canvas, Offset center, double scale) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.95);
    final r = 24.0 * scale;
    canvas.drawCircle(center, r, paint);
    canvas.drawCircle(center + Offset(r * 0.9, r * 0.1), r * 0.85, paint);
    canvas.drawCircle(center + Offset(-r * 0.9, r * 0.15), r * 0.75, paint);
    canvas.drawCircle(center + Offset(r * 0.3, -r * 0.6), r * 0.7, paint);
  }

  @override
  bool shouldRepaint(covariant _SkyPainter old) =>
      old.showSun != showSun || old.showStars != showStars;
}