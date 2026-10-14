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
                      Text('${entry.completedCount} / ${entry.totalCount}'),
                    ],
                  ),
                );
              },
            ),
    );
  }
}