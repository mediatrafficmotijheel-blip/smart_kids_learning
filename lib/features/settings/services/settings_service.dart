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