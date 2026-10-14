# ============================================================
#  Smart Kids Learning — fix.ps1
#  Fixes: withValues→withOpacity, CardThemeData→CardTheme,
#  broken string escapes, unused variable.
# ============================================================

$ErrorActionPreference = "Stop"
Write-Host "==> Applying fixes" -ForegroundColor Cyan

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

# --- 1. app_theme.dart (CardTheme + withOpacity) ------------
Write-Host "==> Fixing app_theme.dart" -ForegroundColor Cyan
Write-File -Path "lib/core/theme/app_theme.dart" -Content @"
import 'package:flutter/material.dart';
import 'package:smart_kids_learning/core/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static const double radius = 20;

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
    );

    return _base(scheme).copyWith(
      scaffoldBackgroundColor: AppColors.backgroundLight,
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ).copyWith(
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
    );

    return _base(scheme).copyWith(
      scaffoldBackgroundColor: AppColors.backgroundDark,
    );
  }

  static ThemeData _base(ColorScheme scheme) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      visualDensity: VisualDensity.standard,
    );

    return base.copyWith(
      textTheme: _textTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: scheme.surfaceContainerHighest.withOpacity(0.55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          textStyle: base.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          textStyle: base.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          side: BorderSide(color: scheme.outlineVariant),
          textStyle: base.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withOpacity(0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primaryContainer,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withOpacity(0.5),
        thickness: 1,
        space: 1,
      ),
    );
  }

  static TextTheme _textTheme(TextTheme base) {
    return base.copyWith(
      displaySmall: base.displaySmall?.copyWith(fontWeight: FontWeight.w800),
      headlineMedium:
          base.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
      headlineSmall: base.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
      titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      bodyLarge: base.bodyLarge?.copyWith(height: 1.35),
      bodyMedium: base.bodyMedium?.copyWith(height: 1.35),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
"@

# --- 2. app_scaffold.dart (remove 'actions' on body) --------
Write-Host "==> Fixing app_scaffold.dart" -ForegroundColor Cyan
Write-File -Path "lib/core/widgets/app_scaffold.dart" -Content @"
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.bottomNavigationBar,
  });

  final String? title;
  final Widget body;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title == null ? null : AppBar(title: Text(title!)),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontal = constraints.maxWidth >= 600 ? 32.0 : 16.0;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontal),
              child: body,
            );
          },
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
"@

# --- 3. home_screen.dart (unused var + escapes) -------------
Write-Host "==> Fixing home_screen.dart" -ForegroundColor Cyan
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

# --- 4. learning_screen.dart (escape fix) ------------------
Write-Host "==> Fixing learning_screen.dart" -ForegroundColor Cyan
Write-File -Path "lib/features/learning/presentation/learning_screen.dart" -Content @"
import 'package:flutter/material.dart';
import 'package:smart_kids_learning/core/localization/generated/app_localizations.dart';
import 'package:smart_kids_learning/core/widgets/app_card.dart';
import 'package:smart_kids_learning/core/widgets/app_scaffold.dart';
import 'package:smart_kids_learning/core/widgets/section_header.dart';
import 'package:smart_kids_learning/features/learning/data/lesson_repository.dart';
import 'package:smart_kids_learning/features/learning/models/lesson.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key, this.repository = const LessonRepository()});

  final LessonRepository repository;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lessons = repository.getLessons();

    return AppScaffold(
      title: l10n.learn,
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: lessons.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            return SectionHeader(
              title: l10n.learn,
              subtitle: l10n.homeSubtitle,
            );
          }
          final lesson = lessons[index - 1];
          return _LessonTile(lesson: lesson);
        },
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  const _LessonTile({required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return AppCard(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('\${lesson.emoji}  \${l10n.comingSoon}'),
          ),
        );
      },
      child: Row(
        children: [
          Text(lesson.emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lesson.id, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  '\${lesson.totalItems} items',
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

# --- 5. progress_screen.dart (escape fix) ------------------
Write-Host "==> Fixing progress_screen.dart" -ForegroundColor Cyan
Write-File -Path "lib/features/progress/presentation/progress_screen.dart" -Content @"
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:smart_kids_learning/core/localization/generated/app_localizations.dart';
import 'package:smart_kids_learning/core/widgets/app_card.dart';
import 'package:smart_kids_learning/core/widgets/app_scaffold.dart';
import 'package:smart_kids_learning/core/widgets/section_header.dart';
import 'package:smart_kids_learning/features/progress/services/progress_service.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final service = context.watch<ProgressService>();
    final entries = service.entries.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return AppScaffold(
      title: l10n.progress,
      body: entries.isEmpty
          ? Center(
              child: Text(
                l10n.comingSoon,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: entries.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return SectionHeader(
                    title: l10n.progress,
                    subtitle: l10n.homeSubtitle,
                  );
                }
                final entry = entries[index - 1];
                return AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.lessonId,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(value: entry.ratio),
                      const SizedBox(height: 6),
                      Text('\${entry.completedCount} / \${entry.totalCount}'),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
"@

# --- 6. quiz_screen.dart (escape fix) ----------------------
Write-Host "==> Fixing quiz_screen.dart" -ForegroundColor Cyan
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

# --- 7. progress_service.dart (const var fix) --------------
Write-Host "==> Fixing progress_service.dart" -ForegroundColor Cyan
Write-File -Path "lib/features/progress/services/progress_service.dart" -Content @"
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smart_kids_learning/core/constants/app_constants.dart';
import 'package:smart_kids_learning/features/progress/models/progress_entry.dart';

class ProgressService extends ChangeNotifier {
  SharedPreferences? _prefs;
  final Map<String, ProgressEntry> _entries = {};

  Map<String, ProgressEntry> get entries => Map.unmodifiable(_entries);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _load();
  }

  void _load() {
    final prefs = _prefs;
    if (prefs == null) return;

    for (final key in prefs.getKeys()) {
      if (!key.startsWith(AppConstants.prefProgressPrefix)) continue;
      final raw = prefs.getString(key);
      if (raw == null) continue;
      try {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        final entry = ProgressEntry(
          lessonId: map['lessonId'] as String,
          completedCount: map['completedCount'] as int,
          totalCount: map['totalCount'] as int,
          updatedAt: DateTime.parse(map['updatedAt'] as String),
        );
        _entries[entry.lessonId] = entry;
      } catch (_) {
        // Ignore malformed entries.
      }
    }
  }

  Future<void> saveEntry(ProgressEntry entry) async {
    _entries[entry.lessonId] = entry;
    final prefs = _prefs;
    if (prefs != null) {
      final key = '\${AppConstants.prefProgressPrefix}\${entry.lessonId}';
      await prefs.setString(
        key,
        jsonEncode({
          'lessonId': entry.lessonId,
          'completedCount': entry.completedCount,
          'totalCount': entry.totalCount,
          'updatedAt': entry.updatedAt.toIso8601String(),
        }),
      );
    }
    notifyListeners();
  }

  Future<void> resetAll() async {
    _entries.clear();
    final prefs = _prefs;
    if (prefs != null) {
      final keys = prefs
          .getKeys()
          .where((k) => k.startsWith(AppConstants.prefProgressPrefix))
          .toList();
      for (final key in keys) {
        await prefs.remove(key);
      }
    }
    notifyListeners();
  }
}
"@

Write-Host ""
Write-Host "==> All fixes applied" -ForegroundColor Green