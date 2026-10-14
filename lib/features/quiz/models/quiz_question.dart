class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.prompt,
    required this.choices,
    required this.correctIndex,
  });

  final String id;
  final String prompt;
  final List<String> choices;
  final int correctIndex;
}