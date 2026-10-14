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
        return l10n.system;
    }
  }

  Future<void> _pickLanguage(
    BuildContext context,
    SettingsService settings,
  ) async {
    final l10n = AppLocalizations.of(context);
    final current = settings.locale?.languageCode ?? 'en';

    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: RadioGroup<String>(
            groupValue: current,
            onChanged: (v) => Navigator.pop(context, v),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  value: 'en',
                  title: Text(l10n.english),
                ),
                RadioListTile<String>(
                  value: 'bn',
                  title: Text(l10n.bengali),
                ),
              ],
            ),
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
          child: RadioGroup<ThemeMode>(
            groupValue: settings.themeMode,
            onChanged: (v) => Navigator.pop(context, v),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<ThemeMode>(
                  value: ThemeMode.system,
                  title: Text(l10n.system),
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.light,
                  title: Text(l10n.light),
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.dark,
                  title: Text(l10n.dark),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected == null) return;
    await settings.setThemeMode(selected);
  }
}