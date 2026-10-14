# ============================================================
#  Smart Kids Learning — newui3.ps1
#  Home + Alphabet screens + bottom nav + main.dart update.
# ============================================================

$ErrorActionPreference = "Stop"
Write-Host "==> Smart Kids Learning newui3.ps1" -ForegroundColor Cyan

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

# --- 1. Letter detail bottom sheet --------------------------
Write-Host "==> Writing LetterDetailSheet" -ForegroundColor Cyan
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
    // Speak shortly after open so animation doesn't fight audio.
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
              '\${letter.exampleEmoji}  \${letter.exampleWord}',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: Color(0xFF222222),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'রোমান: \${letter.romanized}',
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

# --- 2. Alphabet screen -------------------------------------
Write-Host "==> Writing AlphabetScreen" -ForegroundColor Cyan
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
            // Header
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
            // Tabs
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
            // Grids
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
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

# --- 3. New home screen -------------------------------------
Write-Host "==> Writing new HomeScreen" -ForegroundColor Cyan
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
            // Top mascot + title
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
            // Cards
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
        content: Text('\$label শীঘ্রই আসছে!'),
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

# --- 4. main.dart (init TTS) --------------------------------
Write-Host "==> Updating main.dart" -ForegroundColor Cyan
Write-File -Path "lib/main.dart" -Content @'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_kids_learning/app/app.dart';
import 'package:smart_kids_learning/core/services/tts_service.dart';
import 'package:smart_kids_learning/features/progress/services/progress_service.dart';
import 'package:smart_kids_learning/features/settings/services/settings_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsService = SettingsService();
  final progressService = ProgressService();
  await settingsService.init();
  await progressService.init();
  // Warm up TTS in the background (won't block startup).
  TtsService.instance.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsService>.value(value: settingsService),
        ChangeNotifierProvider<ProgressService>.value(value: progressService),
      ],
      child: const SmartKidsApp(),
    ),
  );
}
'@

Write-Host ""
Write-Host "==> Part 3 done" -ForegroundColor Green
Write-Host "Next: flutter analyze, then git push." -ForegroundColor Yellow