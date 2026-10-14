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
      final key = '\\';
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