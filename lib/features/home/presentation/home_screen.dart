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
            subtitle: '$progressEntries saved',
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