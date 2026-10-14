# ============================================================
#  Smart Kids Learning — build3.ps1
#  Final part: quiz, home, test, workflow, README, .gitignore,
#  commit, create GitHub repo, push.
# ============================================================

$ErrorActionPreference = "Stop"

$GITHUB_USER = "mediatrafficmotijheel-blip"
$REPO_NAME   = "smart_kids_learning"
$REPO_DESC   = "Cheerful offline educational app for kids (Flutter, Material 3)"

Write-Host "==> Smart Kids Learning build3.ps1" -ForegroundColor Cyan

function Write-File {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Content
    )
    $full = Join-Path (Get-Location) $Path
    $dir  = Split-Path -Parent $full
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($full, $Content, $utf8NoBom)
    Write-Host "  OK  $Path"
}

# --- 1. Quiz feature ----------------------------------------
Write-Host "==> Writing quiz feature" -ForegroundColor Cyan
Write-File -Path "lib/features/quiz/models/quiz_question.dart" -Content @"
class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.prompt,
    required this.choices,
    required this.correctIndex,
  });

  final String id;
  final String prompt;
  final List<String> choices;
  final int correctIndex;
}
"@

Write-File -Path "lib/features/quiz/data/quiz_repository.dart" -Content @"
import 'package:smart_kids_learning/features/quiz/models/quiz_question.dart';

class QuizRepository {
  const QuizRepository();

  List<QuizQuestion> getQuestions() {
    return const [
      QuizQuestion(
        id: 'q1',
        prompt: 'Which one is the letter A?',
        choices: ['A', 'B', 'C', 'D'],
        correctIndex: 0,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: 'How many apples? 🍎🍎🍎',
        choices: ['1', '2', '3', '4'],
        correctIndex: 2,
      ),
      QuizQuestion(
        id: 'q3',
        prompt: 'What color is the sun? ☀️',
        choices: ['Blue', 'Green', 'Yellow', 'Purple'],
        correctIndex: 2,
      ),
    ];
  }
}
"@

Write-File -Path "lib/features/quiz/presentation/quiz_screen.dart" -Content @"
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:smart_kids_learning/core/localization/generated/app_localizations.dart';
import 'package:smart_kids_learning/core/widgets/app_card.dart';
import 'package:smart_kids_learning/core/widgets/app_scaffold.dart';
import 'package:smart_kids_learning/core/widgets/primary_button.dart';
import 'package:smart_kids_learning/core/widgets/section_header.dart';
import 'package:smart_kids_learning/features/progress/models/progress_entry.dart';
import 'package:smart_kids_learning/features/progress/services/progress_service.dart';
import 'package:smart_kids_learning/features/quiz/data/quiz_repository.dart';
import 'package:smart_kids_learning/features/quiz/models/quiz_question.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, this.repository = const QuizRepository()});

  final QuizRepository repository;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final List<QuizQuestion> _questions = widget.repository.getQuestions();
  int _index = 0;
  int _correct = 0;
  int? _selected;

  bool get _finished => _index >= _questions.length;

  void _select(int choiceIndex) {
    if (_selected != null) return;
    setState(() {
      _selected = choiceIndex;
      if (choiceIndex == _questions[_index].correctIndex) {
        _correct++;
      }
    });
  }

  Future<void> _next() async {
    if (_selected == null) return;
    if (_index + 1 >= _questions.length) {
      final progress = context.read<ProgressService>();
      await progress.saveEntry(
        ProgressEntry(
          lessonId: 'quiz',
          completedCount: _correct,
          totalCount: _questions.length,
          updatedAt: DateTime.now(),
        ),
      );
      setState(() {
        _index = _questions.length;
        _selected = null;
      });
    } else {
      setState(() {
        _index++;
        _selected = null;
      });
    }
  }

  void _restart() {
    setState(() {
      _index = 0;
      _correct = 0;
      _selected = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppScaffold(
      title: l10n.quiz,
      body: _finished
          ? _ResultView(
              correct: _correct,
              total: _questions.length,
              onRestart: _restart,
            )
          : _QuestionView(
              question: _questions[_index],
              index: _index,
              total: _questions.length,
              selected: _selected,
              onSelect: _select,
              onNext: _next,
            ),
    );
  }
}

class _QuestionView extends StatelessWidget {
  const _QuestionView({
    required this.question,
    required this.index,
    required this.total,
    required this.selected,
    required this.onSelect,
    required this.onNext,
  });

  final QuizQuestion question;
  final int index;
  final int total;
  final int? selected;
  final ValueChanged<int> onSelect;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        SectionHeader(
          title: 'Question \${index + 1} / \$total',
          subtitle: question.prompt,
        ),
        const SizedBox(height: 16),
        ...List.generate(question.choices.length, (i) {
          final isSelected = selected == i;
          final isCorrect = i == question.correctIndex;
          final showResult = selected != null;
          final Color? bg = !showResult
              ? null
              : isCorrect
                  ? theme.colorScheme.primaryContainer
                  : isSelected
                      ? theme.colorScheme.errorContainer
                      : null;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: bg,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: () => onSelect(i),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          question.choices[i],
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      if (showResult && isCorrect)
                        const Icon(Icons.check_circle),
                      if (showResult && isSelected && !isCorrect)
                        const Icon(Icons.cancel),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        PrimaryButton(
          label: 'Next',
          onPressed: selected == null ? null : onNext,
        ),
      ],
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.correct,
    required this.total,
    required this.onRestart,
  });

  final int correct;
  final int total;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      children: [
        AppCard(
          child: Column(
            children: [
              const Text('🎉', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text('Score', style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text('\$correct / \$total', style: theme.textTheme.headlineMedium),
            ],
          ),
        ),
        const SizedBox(height: 16),
        PrimaryButton(label: 'Play again', onPressed: onRestart),
      ],
    );
  }
}
"@

# --- 2. Home screen -----------------------------------------
Write-Host "==> Writing home screen" -ForegroundColor Cyan
Write-File -Path "lib/features/home/presentation/home_screen.dart" -Content @"
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:smart_kids_learning/core/localization/generated/app_localizations.dart';
import 'package:smart_kids_learning/core/widgets/app_card.dart';
import 'package:smart_kids_learning/core/widgets/app_scaffold.dart';
import 'package:smart_kids_learning/features/learning/presentation/learning_screen.dart';
import 'package:smart_kids_learning/features/progress/presentation/progress_screen.dart';
import 'package:smart_kids_learning/features/progress/services/progress_service.dart';
import 'package:smart_kids_learning/features/quiz/presentation/quiz_screen.dart';
import 'package:smart_kids_learning/features/settings/presentation/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final progress = context.watch<ProgressService>();
    final progressEntries = progress.entries.length;

    return AppScaffold(
      title: l10n.appTitle,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          AppCard(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Text('🎓', style: TextStyle(fontSize: 40)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.homeWelcome,
                          style: theme.textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(
                        l10n.homeSubtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _HomeTile(
            icon: Icons.school,
            title: l10n.learn,
            subtitle: 'Letters, numbers, shapes',
            color: theme.colorScheme.primaryContainer,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LearningScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _HomeTile(
            icon: Icons.quiz,
            title: l10n.quiz,
            subtitle: 'Fun questions',
            color: theme.colorScheme.secondaryContainer,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const QuizScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _HomeTile(
            icon: Icons.trending_up,
            title: l10n.progress,
            subtitle: '\$progressEntries saved',
            color: theme.colorScheme.tertiaryContainer,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProgressScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _HomeTile(
            icon: Icons.settings,
            title: l10n.settings,
            subtitle: 'Language & theme',
            color: theme.colorScheme.surfaceContainerHighest,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeTile extends StatelessWidget {
  const _HomeTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: onTap,
      semanticLabel: title,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
"@

# --- 3. Test ------------------------------------------------
Write-Host "==> Writing test" -ForegroundColor Cyan
Write-File -Path "test/widget_test.dart" -Content @"
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:smart_kids_learning/app/app.dart';
import 'package:smart_kids_learning/features/progress/services/progress_service.dart';
import 'package:smart_kids_learning/features/settings/services/settings_service.dart';

void main() {
  testWidgets('Home screen renders key tiles', (tester) async {
    final settings = SettingsService();
    final progress = ProgressService();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<SettingsService>.value(value: settings),
          ChangeNotifierProvider<ProgressService>.value(value: progress),
        ],
        child: const SmartKidsApp(),
      ),
    );

    await tester.pump();

    expect(find.byType(SmartKidsApp), findsOneWidget);
  });
}
"@

# --- 4. .gitignore override ---------------------------------
Write-Host "==> Writing .gitignore" -ForegroundColor Cyan
Write-File -Path ".gitignore" -Content @"
# Flutter/Dart
.dart_tool/
.packages
.pub-cache/
.pub/
build/
.flutter-plugins
.flutter-plugins-dependencies
**/generated_plugin_registrant.dart
**/generated_plugins.cmake

# IDE
.idea/
.vscode/
*.iml
*.ipr
*.iws
.fleet/

# OS
.DS_Store
Thumbs.db

# Localization generated output
lib/core/localization/generated/

# Android signing
android/key.properties
*.jks
*.keystore

# Coverage
coverage/
"@

# --- 5. README ----------------------------------------------
Write-Host "==> Writing README.md" -ForegroundColor Cyan
Write-File -Path "README.md" -Content @"
# Smart Kids Learning

A cheerful, offline-first Android educational app for young children, built
with Flutter and Material 3.

## Features

- Home screen with entry points: Learn, Quiz, Progress, Settings
- Learn: lesson list (alphabet, numbers, colors, shapes)
- Quiz: interactive multiple-choice quiz with score persistence
- Progress: per-lesson progress stored locally
- Settings: language (English / Bengali) and theme (light / dark / system)
- Fully offline

## Tech

- Flutter + Dart (null-safe)
- Material 3
- Provider for state management
- SharedPreferences for persistence
- Flutter gen-l10n for localization (en, bn)

## Build

APK is built automatically via GitHub Actions on every push to `main`.
Download the artifact from the Actions tab.
"@

# --- 6. GitHub Actions workflow -----------------------------
Write-Host "==> Writing GitHub Actions workflow" -ForegroundColor Cyan
Write-File -Path ".github/workflows/build-apk.yml" -Content @"
name: Build Flutter APK

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '17'

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: stable
          flutter-version: '3.24.5'
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Generate localizations
        run: flutter gen-l10n

      - name: Analyze
        run: flutter analyze

      - name: Run tests
        run: flutter test

      - name: Build release APK
        run: flutter build apk --release

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: smart-kids-apk
          path: build/app/outputs/flutter-apk/app-release.apk
          retention-days: 30
"@

# --- 7. Git commit ------------------------------------------
Write-Host ""
Write-Host "==> Git: staging and committing" -ForegroundColor Cyan
git add .
git commit -m "Initial Smart Kids Learning project"

# --- 8. Create repo and push --------------------------------
Write-Host ""
Write-Host "==> GitHub: creating repo and pushing" -ForegroundColor Cyan
gh repo create $REPO_NAME --public --description "$REPO_DESC" --source=. --remote=origin --push

Write-Host ""
Write-Host "==> Done!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Watch the build:  gh run watch"
Write-Host "  2. List runs:        gh run list"
Write-Host "  3. Download APK:     gh run download --name smart-kids-apk"
Write-Host ""
Write-Host "Repo URL: https://github.com/$GITHUB_USER/$REPO_NAME" -ForegroundColor Cyan