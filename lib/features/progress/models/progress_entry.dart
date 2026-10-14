class ProgressEntry {
  const ProgressEntry({
    required this.lessonId,
    required this.completedCount,
    required this.totalCount,
    required this.updatedAt,
  });

  final String lessonId;
  final int completedCount;
  final int totalCount;
  final DateTime updatedAt;

  double get ratio => totalCount == 0 ? 0 : completedCount / totalCount;

  ProgressEntry copyWith({
    int? completedCount,
    int? totalCount,
    DateTime? updatedAt,
  }) {
    return ProgressEntry(
      lessonId: lessonId,
      completedCount: completedCount ?? this.completedCount,
      totalCount: totalCount ?? this.totalCount,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}