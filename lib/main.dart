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