# ============================================================
#  Smart Kids Learning — newui1.ps1
#  Bangla alphabet data + TTS service.
# ============================================================

$ErrorActionPreference = "Stop"
Write-Host "==> Smart Kids Learning newui1.ps1" -ForegroundColor Cyan

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

# --- 1. Bangla letter model ---------------------------------
Write-Host "==> Writing Bangla letter model" -ForegroundColor Cyan
Write-File -Path "lib/features/alphabet/models/bangla_letter.dart" -Content @'
import 'package:flutter/material.dart';

/// A single Bangla letter (vowel or consonant).
class BanglaLetter {
  const BanglaLetter({
    required this.id,
    required this.letter,
    required this.romanized,
    required this.exampleWord,
    required this.exampleEmoji,
    required this.color,
    required this.category,
  });

  final String id;
  final String letter;
  final String romanized;
  final String exampleWord;
  final String exampleEmoji;
  final Color color;
  final LetterCategory category;
}

enum LetterCategory { vowel, consonant }
'@

# --- 2. Bangla alphabet data --------------------------------
Write-Host "==> Writing Bangla alphabet data" -ForegroundColor Cyan
Write-File -Path "lib/features/alphabet/data/bangla_alphabet.dart" -Content @'
import 'package:flutter/material.dart';
import 'package:smart_kids_learning/features/alphabet/models/bangla_letter.dart';

class BanglaAlphabet {
  BanglaAlphabet._();

  static const Color _c1 = Color(0xFFE53935); // red
  static const Color _c2 = Color(0xFF1E88E5); // blue
  static const Color _c3 = Color(0xFF43A047); // green
  static const Color _c4 = Color(0xFFFB8C00); // orange
  static const Color _c5 = Color(0xFF8E24AA); // purple
  static const Color _c6 = Color(0xFFFDD835); // yellow
  static const Color _c7 = Color(0xFFD81B60); // pink
  static const Color _c8 = Color(0xFF00897B); // teal
  static const Color _c9 = Color(0xFF3949AB); // indigo
  static const Color _c10 = Color(0xFF6D4C41); // brown

  static const List<Color> rainbow = [
    _c1, _c2, _c3, _c4, _c5, _c6, _c7, _c8, _c9, _c10
  ];

  static const List<BanglaLetter> vowels = [
    BanglaLetter(id: 'o', letter: 'অ', romanized: 'o', exampleWord: 'অজগর', exampleEmoji: '🐍', color: _c1, category: LetterCategory.vowel),
    BanglaLetter(id: 'aa', letter: 'আ', romanized: 'aa', exampleWord: 'আম', exampleEmoji: '🥭', color: _c2, category: LetterCategory.vowel),
    BanglaLetter(id: 'i', letter: 'ই', romanized: 'i', exampleWord: 'ইঁদুর', exampleEmoji: '🐭', color: _c3, category: LetterCategory.vowel),
    BanglaLetter(id: 'ii', letter: 'ঈ', romanized: 'ii', exampleWord: 'ঈগল', exampleEmoji: '🦅', color: _c4, category: LetterCategory.vowel),
    BanglaLetter(id: 'u', letter: 'উ', romanized: 'u', exampleWord: 'উট', exampleEmoji: '🐪', color: _c5, category: LetterCategory.vowel),
    BanglaLetter(id: 'uu', letter: 'ঊ', romanized: 'uu', exampleWord: 'ঊষা', exampleEmoji: '🌅', color: _c6, category: LetterCategory.vowel),
    BanglaLetter(id: 'ri', letter: 'ঋ', romanized: 'ri', exampleWord: 'ঋতু', exampleEmoji: '🍂', color: _c7, category: LetterCategory.vowel),
    BanglaLetter(id: 'e', letter: 'এ', romanized: 'e', exampleWord: 'এক', exampleEmoji: '1️⃣', color: _c8, category: LetterCategory.vowel),
    BanglaLetter(id: 'oi', letter: 'ঐ', romanized: 'oi', exampleWord: 'ঐতিহাসিক', exampleEmoji: '🏛️', color: _c9, category: LetterCategory.vowel),
    BanglaLetter(id: 'oo', letter: 'ও', romanized: 'o', exampleWord: 'ওল', exampleEmoji: '🥔', color: _c10, category: LetterCategory.vowel),
    BanglaLetter(id: 'ou', letter: 'ঔ', romanized: 'ou', exampleWord: 'ঔষধ', exampleEmoji: '💊', color: _c1, category: LetterCategory.vowel),
  ];

  static const List<BanglaLetter> consonants = [
    BanglaLetter(id: 'k', letter: 'ক', romanized: 'k', exampleWord: 'কলা', exampleEmoji: '🍌', color: _c1, category: LetterCategory.consonant),
    BanglaLetter(id: 'kh', letter: 'খ', romanized: 'kh', exampleWord: 'খরগোশ', exampleEmoji: '🐰', color: _c2, category: LetterCategory.consonant),
    BanglaLetter(id: 'g', letter: 'গ', romanized: 'g', exampleWord: 'গরু', exampleEmoji: '🐄', color: _c3, category: LetterCategory.consonant),
    BanglaLetter(id: 'gh', letter: 'ঘ', romanized: 'gh', exampleWord: 'ঘড়ি', exampleEmoji: '⌚', color: _c4, category: LetterCategory.consonant),
    BanglaLetter(id: 'ng', letter: 'ঙ', romanized: 'ng', exampleWord: 'ব্যাঙ', exampleEmoji: '🐸', color: _c5, category: LetterCategory.consonant),
    BanglaLetter(id: 'ch', letter: 'চ', romanized: 'ch', exampleWord: 'চশমা', exampleEmoji: '👓', color: _c6, category: LetterCategory.consonant),
    BanglaLetter(id: 'chh', letter: 'ছ', romanized: 'chh', exampleWord: 'ছাতা', exampleEmoji: '☂️', color: _c7, category: LetterCategory.consonant),
    BanglaLetter(id: 'j', letter: 'জ', romanized: 'j', exampleWord: 'জাহাজ', exampleEmoji: '🚢', color: _c8, category: LetterCategory.consonant),
    BanglaLetter(id: 'jh', letter: 'ঝ', romanized: 'jh', exampleWord: 'ঝুড়ি', exampleEmoji: '🧺', color: _c9, category: LetterCategory.consonant),
    BanglaLetter(id: 'ny', letter: 'ঞ', romanized: 'n', exampleWord: 'মিঞা', exampleEmoji: '🧑', color: _c10, category: LetterCategory.consonant),
    BanglaLetter(id: 'tt', letter: 'ট', romanized: 't', exampleWord: 'টমেটো', exampleEmoji: '🍅', color: _c1, category: LetterCategory.consonant),
    BanglaLetter(id: 'tth', letter: 'ঠ', romanized: 'th', exampleWord: 'ঠোঁট', exampleEmoji: '👄', color: _c2, category: LetterCategory.consonant),
    BanglaLetter(id: 'dd', letter: 'ড', romanized: 'd', exampleWord: 'ডিম', exampleEmoji: '🥚', color: _c3, category: LetterCategory.consonant),
    BanglaLetter(id: 'ddh', letter: 'ঢ', romanized: 'dh', exampleWord: 'ঢাক', exampleEmoji: '🥁', color: _c4, category: LetterCategory.consonant),
    BanglaLetter(id: 'nn', letter: 'ণ', romanized: 'n', exampleWord: 'হরিণ', exampleEmoji: '🦌', color: _c5, category: LetterCategory.consonant),
    BanglaLetter(id: 't', letter: 'ত', romanized: 't', exampleWord: 'তারা', exampleEmoji: '⭐', color: _c6, category: LetterCategory.consonant),
    BanglaLetter(id: 'th', letter: 'থ', romanized: 'th', exampleWord: 'থালা', exampleEmoji: '🍽️', color: _c7, category: LetterCategory.consonant),
    BanglaLetter(id: 'd', letter: 'দ', romanized: 'd', exampleWord: 'দাঁত', exampleEmoji: '🦷', color: _c8, category: LetterCategory.consonant),
    BanglaLetter(id: 'dh', letter: 'ধ', romanized: 'dh', exampleWord: 'ধান', exampleEmoji: '🌾', color: _c9, category: LetterCategory.consonant),
    BanglaLetter(id: 'n', letter: 'ন', romanized: 'n', exampleWord: 'নদী', exampleEmoji: '🏞️', color: _c10, category: LetterCategory.consonant),
    BanglaLetter(id: 'p', letter: 'প', romanized: 'p', exampleWord: 'পাখি', exampleEmoji: '🐦', color: _c1, category: LetterCategory.consonant),
    BanglaLetter(id: 'ph', letter: 'ফ', romanized: 'ph', exampleWord: 'ফুল', exampleEmoji: '🌸', color: _c2, category: LetterCategory.consonant),
    BanglaLetter(id: 'b', letter: 'ব', romanized: 'b', exampleWord: 'বাঘ', exampleEmoji: '🐯', color: _c3, category: LetterCategory.consonant),
    BanglaLetter(id: 'bh', letter: 'ভ', romanized: 'bh', exampleWord: 'ভালুক', exampleEmoji: '🐻', color: _c4, category: LetterCategory.consonant),
    BanglaLetter(id: 'm', letter: 'ম', romanized: 'm', exampleWord: 'মাছ', exampleEmoji: '🐟', color: _c5, category: LetterCategory.consonant),
    BanglaLetter(id: 'j2', letter: 'য', romanized: 'j', exampleWord: 'যাদু', exampleEmoji: '🎩', color: _c6, category: LetterCategory.consonant),
    BanglaLetter(id: 'r', letter: 'র', romanized: 'r', exampleWord: 'রাজা', exampleEmoji: '👑', color: _c7, category: LetterCategory.consonant),
    BanglaLetter(id: 'l', letter: 'ল', romanized: 'l', exampleWord: 'লেবু', exampleEmoji: '🍋', color: _c8, category: LetterCategory.consonant),
    BanglaLetter(id: 'sh', letter: 'শ', romanized: 'sh', exampleWord: 'শিং', exampleEmoji: '🐏', color: _c9, category: LetterCategory.consonant),
    BanglaLetter(id: 'shh', letter: 'ষ', romanized: 'sh', exampleWord: 'ষাট', exampleEmoji: '6️⃣', color: _c10, category: LetterCategory.consonant),
    BanglaLetter(id: 's', letter: 'স', romanized: 's', exampleWord: 'সূর্য', exampleEmoji: '☀️', color: _c1, category: LetterCategory.consonant),
    BanglaLetter(id: 'h', letter: 'হ', romanized: 'h', exampleWord: 'হাতি', exampleEmoji: '🐘', color: _c2, category: LetterCategory.consonant),
    BanglaLetter(id: 'rr', letter: 'ড়', romanized: 'r', exampleWord: 'বড়', exampleEmoji: '📏', color: _c3, category: LetterCategory.consonant),
    BanglaLetter(id: 'rrh', letter: 'ঢ়', romanized: 'rh', exampleWord: 'আষাঢ়', exampleEmoji: '🌧️', color: _c4, category: LetterCategory.consonant),
    BanglaLetter(id: 'y', letter: 'য়', romanized: 'y', exampleWord: 'বয়', exampleEmoji: '👦', color: _c5, category: LetterCategory.consonant),
    BanglaLetter(id: 't2', letter: 'ৎ', romanized: 't', exampleWord: 'হঠাৎ', exampleEmoji: '⚡', color: _c6, category: LetterCategory.consonant),
    BanglaLetter(id: 'ng2', letter: 'ং', romanized: 'ng', exampleWord: 'রং', exampleEmoji: '🎨', color: _c7, category: LetterCategory.consonant),
    BanglaLetter(id: 'hh', letter: 'ঃ', romanized: 'h', exampleWord: 'দুঃখ', exampleEmoji: '😢', color: _c8, category: LetterCategory.consonant),
    BanglaLetter(id: 'n2', letter: 'ঁ', romanized: 'n', exampleWord: 'চাঁদ', exampleEmoji: '🌙', color: _c9, category: LetterCategory.consonant),
  ];
}
'@

# --- 3. TTS service -----------------------------------------
Write-Host "==> Writing TTS service" -ForegroundColor Cyan
Write-File -Path "lib/core/services/tts_service.dart" -Content @'
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
'@

Write-Host ""
Write-Host "==> Part 1 done" -ForegroundColor Green
Write-Host "Next: create newui2.ps1 for cloud background + animated card." -ForegroundColor Yellow