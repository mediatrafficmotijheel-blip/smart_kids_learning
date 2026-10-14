# ============================================================
#  Smart Kids Learning — build2.ps1
#  Writes remaining source files, commits, creates GitHub repo,
#  and pushes (Actions will build the APK).
# ============================================================

$ErrorActionPreference = "Stop"

$GITHUB_USER = "mediatrafficmotijheel-blip"
$REPO_NAME   = "smart_kids_learning"
$REPO_DESC   = "Cheerful offline educational app for kids (Flutter, Material 3)"

Write-Host "==> Smart Kids Learning build2.ps1" -ForegroundColor Cyan

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

# --- 1. Constants -------------------------------------------
Write-Host "==> Writing constants" -ForegroundColor Cyan
Write-File -Path "lib/core/constants/app_constants.dart" -Content @"
class AppConstants {
  AppConstants._();

  static const String appName = 'Smart Kids Learning';

  static const String prefLocale = 'pref_locale';
  static const String prefThemeMode = 'pref_theme_mode';
  static const String prefProgressPrefix = 'progress_';
}
"@

Write-File -Path "lib/core/constants/app_sizes.dart" -Content @"
class AppSizes {
  AppSizes._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  static const double cardRadius = 20;
  static const double buttonHeight = 56;
}
"@

# --- 2. Core widgets ----------------------------------------
Write-Host "==> Writing core widgets" -ForegroundColor Cyan
Write-File -Path "lib/core/widgets/app_scaffold.dart" -Content @"
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  final String? title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
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
      actions: actions,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
"@

Write-File -Path "lib/core/widgets/app_card.dart" -Content @"
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);
    final card = Card(child: content);

    if (onTap == null) {
      return semanticLabel == null
          ? card
          : Semantics(label: semanticLabel, button: false, child: card);
    }

    return Semantics(
      label: semanticLabel,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: card,
      ),
    );
  }
}
"@

Write-File -Path "lib/core/widgets/primary_button.dart" -Content @"
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final child = icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              const SizedBox(width: 8),
              Text(label),
            ],
          );

    final button = FilledButton(onPressed: onPressed, child: child);
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
"@

Write-File -Path "lib/core/widgets/section_header.dart" -Content @"
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleLarge),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
"@

# --- 3. Settings feature ------------------------------------
Write-Host "==> Writing settings feature" -ForegroundColor Cyan
Write-File -Path "lib/features/settings/services/settings_service.dart" -Content @"
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smart_kids_learning/core/constants/app_constants.dart';

class SettingsService extends ChangeNotifier {
  SharedPreferences? _prefs;

  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.system;

  Locale? get locale => _locale;
  ThemeMode get themeMode => _themeMode;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _load();
  }

  void _load() {
    final prefs = _prefs;
    if (prefs == null) return;

    final code = prefs.getString(AppConstants.prefLocale);
    if (code != null && code.isNotEmpty) {
      _locale = Locale(code);
    }

    final mode = prefs.getString(AppConstants.prefThemeMode);
    _themeMode = _parseThemeMode(mode);
  }

  ThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setLocale(Locale? locale) async {
    if (_locale == locale) return;
    _locale = locale;
    final prefs = _prefs;
    if (prefs != null) {
      if (locale == null) {
        await prefs.remove(AppConstants.prefLocale);
      } else {
        await prefs.setString(AppConstants.prefLocale, locale.languageCode);
      }
    }
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    final prefs = _prefs;
    if (prefs != null) {
      await prefs.setString(AppConstants.prefThemeMode, mode.name);
    }
    notifyListeners();
  }
}
"@

Write-File -Path "lib/features/settings/presentation/settings_screen.dart" -Content @"
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:smart_kids_learning/core/localization/generated/app_localizations.dart';
import 'package:smart_kids_learning/core/widgets/app_scaffold.dart';
import 'package:smart_kids_learning/core/widgets/section_header.dart';
import 'package:smart_kids_learning/features/settings/services/settings_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = context.watch<SettingsService>();

    return AppScaffold(
      title: l10n.settings,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          SectionHeader(title: l10n.settings),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(l10n.language),
                  subtitle: Text(
                    settings.locale?.languageCode == 'bn'
                        ? l10n.bengali
                        : l10n.english,
                  ),
                  trailing: const Icon(Icons.translate),
                  onTap: () => _pickLanguage(context, settings),
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text(l10n.theme),
                  subtitle: Text(_themeLabel(l10n, settings.themeMode)),
                  trailing: const Icon(Icons.brightness_6),
                  onTap: () => _pickTheme(context, settings),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _themeLabel(AppLocalizations l10n, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return l10n.light;
      case ThemeMode.dark:
        return l10n.dark;
      case ThemeMode.system:
      default:
        return l10n.system;
    }
  }

  Future<void> _pickLanguage(
    BuildContext context,
    SettingsService settings,
  ) async {
    final l10n = AppLocalizations.of(context);
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final current = settings.locale?.languageCode ?? 'en';
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                value: 'en',
                groupValue: current,
                title: Text(l10n.english),
                onChanged: (v) => Navigator.pop(context, v),
              ),
              RadioListTile<String>(
                value: 'bn',
                groupValue: current,
                title: Text(l10n.bengali),
                onChanged: (v) => Navigator.pop(context, v),
              ),
            ],
          ),
        );
      },
    );

    if (selected == null) return;
    await settings.setLocale(Locale(selected));
  }

  Future<void> _pickTheme(
    BuildContext context,
    SettingsService settings,
  ) async {
    final l10n = AppLocalizations.of(context);
    final selected = await showModalBottomSheet<ThemeMode>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                value: ThemeMode.system,
                groupValue: settings.themeMode,
                title: Text(l10n.system),
                onChanged: (v) => Navigator.pop(context, v),
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.light,
                groupValue: settings.themeMode,
                title: Text(l10n.light),
                onChanged: (v) => Navigator.pop(context, v),
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: settings.themeMode,
                title: Text(l10n.dark),
                onChanged: (v) => Navigator.pop(context, v),
              ),
            ],
          ),
        );
      },
    );

    if (selected == null) return;
    await settings.setThemeMode(selected);
  }
}
"@

# --- 4. Progress feature ------------------------------------
Write-Host "==> Writing progress feature" -ForegroundColor Cyan
Write-File -Path "lib/features/progress/models/progress_entry.dart" -Content @"
class ProgressEntry {
  const ProgressEntry({
    required this.lessonId,
    required this.completedCount,
    required this.totalCount,
    required this.updatedAt,
  });

  final String lessonId;
  final int completedCount;
  final int totalCount;
  final DateTime updatedAt;

  double get ratio => totalCount == 0 ? 0 : completedCount / totalCount;

  ProgressEntry copyWith({
    int? completedCount,
    int? totalCount,
    DateTime? updatedAt,
  }) {
    return ProgressEntry(
      lessonId: lessonId,
      completedCount: completedCount ?? this.completedCount,
      totalCount: totalCount ?? this.totalCount,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
"@

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

# --- 5. Learning feature ------------------------------------
Write-Host "==> Writing learning feature" -ForegroundColor Cyan
Write-File -Path "lib/features/learning/models/lesson.dart" -Content @"
class Lesson {
  const Lesson({
    required this.id,
    required this.titleKey,
    required this.emoji,
    required this.totalItems,
  });

  final String id;
  final String titleKey;
  final String emoji;
  final int totalItems;
}
"@

Write-File -Path "lib/features/learning/data/lesson_repository.dart" -Content @"
import 'package:smart_kids_learning/features/learning/models/lesson.dart';

class LessonRepository {
  const LessonRepository();

  List<Lesson> getLessons() {
    return const [
      Lesson(id: 'alphabet', titleKey: 'learn', emoji: '🔤', totalItems: 26),
      Lesson(id: 'numbers', titleKey: 'learn', emoji: '🔢', totalItems: 20),
      Lesson(id: 'colors', titleKey: 'learn', emoji: '🎨', totalItems: 12),
      Lesson(id: 'shapes', titleKey: 'learn', emoji: '⬛', totalItems: 10),
    ];
  }
}
"@

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
    return AppCard(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '\${lesson.emoji}  \${AppLocalizations.of(context).comingSoon}',
            ),
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

Write-Host "==> Done writing feature files" -ForegroundColor Cyan
Write-Host ""
Write-Host "Now run build3.ps1 for quiz, home, tests, workflow, and push." -ForegroundColor Yellow