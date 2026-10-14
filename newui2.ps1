# ============================================================
#  Smart Kids Learning — newui2.ps1
#  Cloud/star background + animated widgets.
# ============================================================

$ErrorActionPreference = "Stop"
Write-Host "==> Smart Kids Learning newui2.ps1" -ForegroundColor Cyan

function Write-File {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Content
    )
    $full = Join-Path (Get-Location) $Path
    $dir  = Split-Path -Parent $full
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($full, $Content, $utf8NoBom)
    Write-Host "  OK  $Path"
}

# --- 1. Cloud background painter ----------------------------
Write-Host "==> Writing CloudBackground" -ForegroundColor Cyan
Write-File -Path "lib/core/widgets/cloud_background.dart" -Content @'
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
        // Sky gradient
        Positioned.fill(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF7FD3F7), // light blue
                  Color(0xFFB6E9FF), // sky
                  Color(0xFFE4F6FF),
                ],
              ),
            ),
          ),
        ),
        // Painted clouds, sun, grass, stars
        Positioned.fill(
          child: CustomPaint(
            painter: _SkyPainter(showSun: showSun, showStars: showStars),
          ),
        ),
        // Foreground content
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
    // --- Sun (top-right) ---
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
        final start = sunCenter +
            Offset(math.cos(angle), math.sin(angle)) * 42;
        final end = sunCenter +
            Offset(math.cos(angle), math.sin(angle)) * 54;
        canvas.drawLine(start, end, rayPaint);
      }
    }

    // --- Stars (for night mode / quiz) ---
    if (showStars) {
      final starPaint = Paint()..color = Colors.white.withValues(alpha: 0.9);
      for (var i = 0; i < 20; i++) {
        final dx = (i * 137.5) % size.width;
        final dy = (i * 89.3) % (size.height * 0.5);
        canvas.drawCircle(Offset(dx, dy), 2, starPaint);
      }
    }

    // --- Clouds ---
    _drawCloud(canvas, Offset(size.width * 0.15, size.height * 0.18), 1.0);
    _drawCloud(canvas, Offset(size.width * 0.55, size.height * 0.10), 0.75);
    _drawCloud(canvas, Offset(size.width * 0.85, size.height * 0.25), 0.9);
    _drawCloud(canvas, Offset(size.width * 0.30, size.height * 0.35), 0.65);

    // --- Grass hill at bottom ---
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
    canvas.drawPath(
      hillPath,
      Paint()..color = const Color(0xFF7CC576),
    );

    // second hill darker
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
    canvas.drawPath(
      hill2,
      Paint()..color = const Color(0xFF5BB05B),
    );
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
'@

# --- 2. BouncyCard widget -----------------------------------
Write-Host "==> Writing BouncyCard" -ForegroundColor Cyan
Write-File -Path "lib/core/widgets/bouncy_card.dart" -Content @'
import 'package:flutter/material.dart';

/// A card that bounces (scales down then up) when tapped.
class BouncyCard extends StatefulWidget {
  const BouncyCard({
    super.key,
    required this.child,
    this.onTap,
    this.color,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 24,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  @override
  State<BouncyCard> createState() => _BouncyCardState();
}

class _BouncyCardState extends State<BouncyCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 140),
    lowerBound: 0.0,
    upperBound: 0.08,
  );

  late final Animation<double> _scale = Tween<double>(begin: 1.0, end: 1.0)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (widget.onTap == null) return;
    await _controller.forward();
    await _controller.reverse();
    widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    final scale = 1.0 - _controller.value;
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) async {
        await _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.color ?? Colors.white,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
'@

# --- 3. LetterTile widget -----------------------------------
Write-Host "==> Writing LetterTile" -ForegroundColor Cyan
Write-File -Path "lib/core/widgets/letter_tile.dart" -Content @'
import 'package:flutter/material.dart';

/// A colorful tile showing a Bangla letter.
class LetterTile extends StatefulWidget {
  const LetterTile({
    super.key,
    required this.letter,
    required this.color,
    this.onTap,
    this.size = 96,
  });

  final String letter;
  final Color color;
  final VoidCallback? onTap;
  final double size;

  @override
  State<LetterTile> createState() => _LetterTileState();
}

class _LetterTileState extends State<LetterTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
    lowerBound: 0,
    upperBound: 0.12,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) async {
        await _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = 1.0 - _controller.value;
          return Transform.scale(scale: scale, child: child);
        },
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.8),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.55),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.letter,
            style: const TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.1,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(1, 2),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
'@

Write-Host ""
Write-Host "==> Part 2 done" -ForegroundColor Green
Write-Host "Next: create newui3.ps1 for the home + alphabet screens." -ForegroundColor Yellow