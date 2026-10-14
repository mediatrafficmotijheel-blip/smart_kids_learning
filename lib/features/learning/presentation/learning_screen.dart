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
            content: Text('\  \'),
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
                  '\ items',
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