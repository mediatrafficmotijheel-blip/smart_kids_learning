import 'package:smart_kids_learning/features/learning/models/lesson.dart';

class LessonRepository {
  const LessonRepository();

  List<Lesson> getLessons() {
    return const [
      Lesson(id: 'alphabet', titleKey: 'learn', emoji: 'ðŸ”¤', totalItems: 26),
      Lesson(id: 'numbers', titleKey: 'learn', emoji: 'ðŸ”¢', totalItems: 20),
      Lesson(id: 'colors', titleKey: 'learn', emoji: 'ðŸŽ¨', totalItems: 12),
      Lesson(id: 'shapes', titleKey: 'learn', emoji: 'â¬›', totalItems: 10),
    ];
  }
}