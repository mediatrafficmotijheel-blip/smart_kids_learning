# ============================================================
#  Smart Kids Learning — build.ps1
#  One-shot script: creates all project files, initializes Git,
#  creates the GitHub repo, and pushes (Actions builds the APK).
# ============================================================

$ErrorActionPreference = "Stop"

$GITHUB_USER = "mediatrafficmotijheel-blip"
$REPO_NAME   = "smart_kids_learning"
$REPO_DESC   = "Cheerful offline educational app for kids (Flutter, Material 3)"

Write-Host "==> Smart Kids Learning build script" -ForegroundColor Cyan

# --- Write-File helper --------------------------------------
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

# --- 1. Folder structure ------------------------------------
Write-Host "==> Creating folder structure" -ForegroundColor Cyan
$folders = @(
  "lib\app",
  "lib\core\theme",
  "lib\core\constants",
  "lib\core\localization\l10n",
  "lib\core\localization\generated",
  "lib\core\widgets",
  "lib\features\home\presentation",
  "lib\features\learning\data",
  "lib\features\learning\models",
  "lib\features\learning\presentation",
  "lib\features\quiz\data",
  "lib\features\quiz\models",
  "lib\features\quiz\presentation",
  "lib\features\progress\models",
  "lib\features\progress\services",
  "lib\features\progress\presentation",
  "lib\features\settings\services",
  "lib\features\settings\presentation",
  "assets\images",
  "assets\audio",
  "test",
  ".github\workflows"
)
foreach ($f in $folders) {
    New-Item -ItemType Directory -Force -Path $f | Out-Null
}
New-Item -ItemType File -Force -Path "assets\images\.gitkeep" | Out-Null
New-Item -ItemType File -Force -Path "assets\audio\.gitkeep"  | Out-Null

# --- 2. pubspec.yaml ----------------------------------------
Write-Host "==> Writing pubspec.yaml" -ForegroundColor Cyan
Write-File -Path "pubspec.yaml" -Content @"
name: smart_kids_learning
description: Smart Kids Learning - a cheerful offline educational app for kids.
publish_to: "none"
version: 0.1.0+1

environment:
  sdk: ">=3.4.0 <4.0.0"
  flutter: ">=3.22.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  cupertino_icons: ^1.0.8
  provider: ^6.1.2
  shared_preferences: ^2.2.3
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0

flutter:
  uses-material-design: true

  assets:
    - assets/images/
    - assets/audio/

  generate: true
"@

# --- 3. l10n.yaml -------------------------------------------
Write-Host "==> Writing l10n.yaml" -ForegroundColor Cyan
Write-File -Path "l10n.yaml" -Content @"
arb-dir: lib/core/localization/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
nullable-getter: false
synthetic-package: false
output-dir: lib/core/localization/generated
"@

# --- 4. ARB files -------------------------------------------
Write-Host "==> Writing ARB files" -ForegroundColor Cyan
Write-File -Path "lib/core/localization/l10n/app_en.arb" -Content @"
{
  "@@locale": "en",
  "appTitle": "Smart Kids Learning",
  "homeTitle": "Home",
  "homeWelcome": "Welcome, little learner!",
  "homeSubtitle": "Pick a fun activity to start.",
  "learn": "Learn",
  "quiz": "Quiz",
  "progress": "Progress",
  "settings": "Settings",
  "comingSoon": "Coming soon",
  "language": "Language",
  "english": "English",
  "bengali": "বাংলা",
  "theme": "Theme",
  "light": "Light",
  "dark": "Dark",
  "system": "System"
}
"@

Write-File -Path "lib/core/localization/l10n/app_bn.arb" -Content @"
{
  "@@locale": "bn",
  "appTitle": "স্মার্ট কিডস লার্নিং",
  "homeTitle": "হোম",
  "homeWelcome": "স্বাগতম, ছোট শিক্ষার্থী!",
  "homeSubtitle": "শুরু করতে একটি মজার কাজ বেছে নাও।",
  "learn": "শেখা",
  "quiz": "কুইজ",
  "progress": "অগ্রগতি",
  "settings": "সেটিংস",
  "comingSoon": "শীঘ্রই আসছে",
  "language": "ভাষা",
  "english": "English",
  "bengali": "বাংলা",
  "theme": "থিম",
  "light": "লাইট",
  "dark": "ডার্ক",
  "system": "সিস্টেম"
}
"@

# --- 5. main.dart -------------------------------------------
Write-Host "==> Writing Dart source files" -ForegroundColor Cyan
Write-File -Path "lib/main.dart" -Content @"
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_kids_learning/app/app.dart';
import 'package:smart_kids_learning/features/progress/services/progress_service.dart';
import 'package:smart_kids_learning/features/settings/services/settings_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsService = SettingsService();
  final progressService = ProgressService();
  await settingsService.init();
  await progressService.init();

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
"@

# --- 6. app.dart --------------------------------------------
Write-File -Path "lib/app/app.dart" -Content @"
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:smart_kids_learning/core/localization/generated/app_localizations.dart';
import 'package:smart_kids_learning/core/theme/app_theme.dart';
import 'package:smart_kids_learning/features/home/presentation/home_screen.dart';
import 'package:smart_kids_learning/features/settings/services/settings_service.dart';

class SmartKidsApp extends StatelessWidget {
  const SmartKidsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: settings.themeMode,
      locale: settings.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const HomeScreen(),
    );
  }
}
"@

# --- 7. theme -----------------------------------------------
Write-File -Path "lib/core/theme/app_colors.dart" -Content @"
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF4C6FFF);
  static const Color primaryDark = Color(0xFF2F49B8);
  static const Color secondary = Color(0xFFFFB020);
  static const Color tertiary = Color(0xFF2EC4B6);
  static const Color pink = Color(0xFFFF6B9D);
  static const Color success = Color(0xFF3BB273);
  static const Color danger = Color(0xFFE5484D);

  static const Color surfaceLight = Color(0xFFFDFCFF);
  static const Color surfaceDark = Color(0xFF15171C);
  static const Color backgroundLight = Color(0xFFF6F7FB);
  static const Color backgroundDark = Color(0xFF0E1014);
}
"@

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
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
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
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
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
        color: scheme.outlineVariant.withValues(alpha: 0.5),
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

Write-Host "==> Done writing core files" -ForegroundColor Cyan
Write-Host ""
Write-Host "Now run the second part: build2.ps1 (or ask for the rest of the script)." -ForegroundColor Yellow