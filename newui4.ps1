# ============================================================
#  Smart Kids Learning — newui4.ps1
#  Clean up warnings and infos from Part 2 & 3.
# ============================================================

$ErrorActionPreference = "Stop"
Write-Host "==> Smart Kids Learning newui4.ps1 (cleanup)" -ForegroundColor Cyan

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

# --- 1. bouncy_card.dart (remove unused) --------------------
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

# --- 2. cloud_background.dart (const fixes) -----------------
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
'@

# --- 3. alphabet_screen.dart (const fixes) ------------------
Write-File -Path "lib/features/alphabet/presentation/alphabet_screen.dart" -Content @'
import 'package:flutter/material.dart';
import 'package:smart_kids_learning/core/widgets/cloud_background.dart';
import 'package:smart_kids_learning/core/widgets/letter_tile.dart';
import 'package:smart_kids_learning/features/alphabet/data/bangla_alphabet.dart';
import 'package:smart_kids_learning/features/alphabet/models/bangla_letter.dart';
import 'package:smart_kids_learning/features/alphabet/presentation/letter_detail_sheet.dart';

class AlphabetScreen extends StatefulWidget {
  const AlphabetScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<AlphabetScreen> createState() => _AlphabetScreenState();
}

class _AlphabetScreenState extends State<AlphabetScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(
    length: 2,
    vsync: this,
    initialIndex: widget.initialTab,
  );

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CloudBackground(
      showSun: true,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  if (Navigator.of(context).canPop())
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 30),
                    ),
                  const Expanded(
                    child: Text(
                      'বর্ণ শিখি',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black38,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (Navigator.of(context).canPop())
                    const SizedBox(width: 40),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TabBar(
                controller: _tab,
                labelColor: const Color(0xFF1E88E5),
                unselectedLabelColor: Colors.black54,
                labelStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
                indicator: BoxDecoration(
                  color: const Color(0xFF1E88E5).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(24),
                ),
                tabs: const [
                  Tab(text: 'স্বরবর্ণ'),
                  Tab(text: 'ব্যঞ্জনবর্ণ'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: const [
                  _LetterGrid(letters: BanglaAlphabet.vowels),
                  _LetterGrid(letters: BanglaAlphabet.consonants),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LetterGrid extends StatelessWidget {
  const _LetterGrid({required this.letters});

  final List<BanglaLetter> letters;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: letters.length,
      itemBuilder: (context, index) {
        final letter = letters[index];
        return LetterTile(
          letter: letter.letter,
          color: letter.color,
          size: 120,
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => LetterDetailSheet(letter: letter),
            );
          },
        );
      },
    );
  }
}
'@

# --- 4. letter_detail_sheet.dart (const fixes) --------------
Write-File -Path "lib/features/alphabet/presentation/letter_detail_sheet.dart" -Content @'
import 'package:flutter/material.dart';
import 'package:smart_kids_learning/core/services/tts_service.dart';
import 'package:smart_kids_learning/features/alphabet/models/bangla_letter.dart';

/// A big, cheerful popup that shows a letter, its example word/emoji,
/// and speaks it when opened.
class LetterDetailSheet extends StatefulWidget {
  const LetterDetailSheet({super.key, required this.letter});

  final BanglaLetter letter;

  @override
  State<LetterDetailSheet> createState() => _LetterDetailSheetState();
}

class _LetterDetailSheetState extends State<LetterDetailSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TtsService.instance.speak(widget.letter.letter);
    });
  }

  @override
  Widget build(BuildContext context) {
    final letter = widget.letter;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: letter.color,
                borderRadius: BorderRadius.circular(36),
                boxShadow: [
                  BoxShadow(
                    color: letter.color.withValues(alpha: 0.5),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                letter.letter,
                style: const TextStyle(
                  fontSize: 84,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${letter.exampleEmoji}  ${letter.exampleWord}',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: Color(0xFF222222),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'রোমান: ${letter.romanized}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: letter.color,
                      minimumSize: const Size.fromHeight(60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => TtsService.instance.speak(letter.letter),
                    icon: const Icon(Icons.volume_up, size: 28),
                    label: const Text(
                      'আবার শুনুন',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
'@

# --- 5. home_screen.dart (const fixes) ----------------------
Write-File -Path "lib/features/home/presentation/home_screen.dart" -Content @'
import 'package:flutter/material.dart';
import 'package:smart_kids_learning/core/widgets/bouncy_card.dart';
import 'package:smart_kids_learning/core/widgets/cloud_background.dart';
import 'package:smart_kids_learning/features/alphabet/presentation/alphabet_screen.dart';
import 'package:smart_kids_learning/features/progress/presentation/progress_screen.dart';
import 'package:smart_kids_learning/features/quiz/presentation/quiz_screen.dart';
import 'package:smart_kids_learning/features/settings/presentation/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CloudBackground(
      showSun: true,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text('👦', style: TextStyle(fontSize: 40)),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'গানে গানে শিখি',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black38,
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'বাচ্চাদের মজাদার ছড়া গান',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black38,
                                offset: Offset(1, 1),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                children: [
                  _MenuCard(
                    emoji: '🔤',
                    title: 'বর্ণ শিখি',
                    subtitle: 'অ, আ, ই, ঈ...',
                    color: const Color(0xFFE53935),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AlphabetScreen(initialTab: 0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _MenuCard(
                    emoji: '🔢',
                    title: 'সংখ্যা শিখি',
                    subtitle: '১, ২, ৩...',
                    color: const Color(0xFF1E88E5),
                    onTap: () => _comingSoon(context, 'সংখ্যা শিখি'),
                  ),
                  const SizedBox(height: 14),
                  _MenuCard(
                    emoji: '❓',
                    title: 'কুইজ খেলি',
                    subtitle: 'মজার প্রশ্ন',
                    color: const Color(0xFF43A047),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QuizScreen()),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _MenuCard(
                    emoji: '🏆',
                    title: 'আমার অগ্রগতি',
                    subtitle: 'কতটুকু শিখেছি',
                    color: const Color(0xFFFB8C00),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ProgressScreen()),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _MenuCard(
                    emoji: '⚙️',
                    title: 'সেটিংস',
                    subtitle: 'ভাষা ও থিম',
                    color: const Color(0xFF8E24AA),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SettingsScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _comingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label শীঘ্রই আসছে!'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BouncyCard(
      color: Colors.white,
      padding: const EdgeInsets.all(14),
      borderRadius: 28,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 34)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF222222),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: color, size: 32),
        ],
      ),
    );
  }
}
'@

Write-Host ""
Write-Host "==> Cleanup done" -ForegroundColor Green
Write-Host "Next: flutter analyze, then commit + push." -ForegroundColor Yellow