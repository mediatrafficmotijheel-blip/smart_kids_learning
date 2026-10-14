import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Speaks Bangla letters and words using the platform TTS engine.
class TtsService {
  TtsService._();
  static final TtsService instance = TtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;
  bool _banglaAvailable = false;

  bool get banglaAvailable => _banglaAvailable;

  Future<void> init() async {
    if (_initialized) return;
    try {
      await _tts.setLanguage('bn-BD');
      await _tts.setSpeechRate(0.4);
      await _tts.setPitch(1.1);
      await _tts.setVolume(1.0);
      _banglaAvailable = true;
    } catch (e) {
      _banglaAvailable = false;
      debugPrint('TTS init failed: $e');
    }
    _initialized = true;
  }

  Future<void> speak(String text) async {
    await init();
    if (!_banglaAvailable) {
      // Fallback: try English engine anyway; some phones speak Bangla with default.
      try {
        await _tts.setLanguage('bn');
      } catch (_) {}
    }
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      debugPrint('TTS speak failed: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}