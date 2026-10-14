import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:smart_kids_learning/core/localization/generated/app_localizations.dart';
import 'package:smart_kids_learning/core/widgets/app_card.dart';
import 'package:smart_kids_learning/core/widgets/app_scaffold.dart';
import 'package:smart_kids_learning/core/widgets/primary_button.dart';
import 'package:smart_kids_learning/core/widgets/section_header.dart';
import 'package:smart_kids_learning/features/progress/models/progress_entry.dart';
import 'package:smart_kids_learning/features/progress/services/progress_service.dart';
import 'package:smart_kids_learning/features/quiz/data/quiz_repository.dart';
import 'package:smart_kids_learning/features/quiz/models/quiz_question.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, this.repository = const QuizRepository()});

  final QuizRepository repository;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final List<QuizQuestion> _questions = widget.repository.getQuestions();
  int _index = 0;
  int _correct = 0;
  int? _selected;

  bool get _finished => _index >= _questions.length;

  void _select(int choiceIndex) {
    if (_selected != null) return;
    setState(() {
      _selected = choiceIndex;
      if (choiceIndex == _questions[_index].correctIndex) {
        _correct++;
      }
    });
  }

  Future<void> _next() async {
    if (_selected == null) return;
    if (_index + 1 >= _questions.length) {
      final progress = context.read<ProgressService>();
      await progress.saveEntry(
        ProgressEntry(
          lessonId: 'quiz',
          completedCount: _correct,
          totalCount: _questions.length,
          updatedAt: DateTime.now(),
        ),
      );
      setState(() {
        _index = _questions.length;
        _selected = null;
      });
    } else {
      setState(() {
        _index++;
        _selected = null;
      });
    }
  }

  void _restart() {
    setState(() {
      _index = 0;
      _correct = 0;
      _selected = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppScaffold(
      title: l10n.quiz,
      body: _finished
          ? _ResultView(
              correct: _correct,
              total: _questions.length,
              onRestart: _restart,
            )
          : _QuestionView(
              question: _questions[_index],
              index: _index,
              total: _questions.length,
              selected: _selected,
              onSelect: _select,
              onNext: _next,
            ),
    );
  }
}

class _QuestionView extends StatelessWidget {
  const _QuestionView({
    required this.question,
    required this.index,
    required this.total,
    required this.selected,
    required this.onSelect,
    required this.onNext,
  });

  final QuizQuestion question;
  final int index;
  final int total;
  final int? selected;
  final ValueChanged<int> onSelect;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        SectionHeader(
          title: 'Question \ / \',
          subtitle: question.prompt,
        ),
        const SizedBox(height: 16),
        ...List.generate(question.choices.length, (i) {
          final isSelected = selected == i;
          final isCorrect = i == question.correctIndex;
          final showResult = selected != null;
          final Color? bg = !showResult
              ? null
              : isCorrect
                  ? theme.colorScheme.primaryContainer
                  : isSelected
                      ? theme.colorScheme.errorContainer
                      : null;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: bg,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: () => onSelect(i),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          question.choices[i],
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      if (showResult && isCorrect)
                        const Icon(Icons.check_circle),
                      if (showResult && isSelected && !isCorrect)
                        const Icon(Icons.cancel),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        PrimaryButton(
          label: 'Next',
          onPressed: selected == null ? null : onNext,
        ),
      ],
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.correct,
    required this.total,
    required this.onRestart,
  });

  final int correct;
  final int total;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      children: [
        AppCard(
          child: Column(
            children: [
              const Text('ðŸŽ‰', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text('Score', style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text('\ / \', style: theme.textTheme.headlineMedium),
            ],
          ),
        ),
        const SizedBox(height: 16),
        PrimaryButton(label: 'Play again', onPressed: onRestart),
      ],
    );
  }
}