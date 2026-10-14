import 'package:smart_kids_learning/features/quiz/models/quiz_question.dart';

class QuizRepository {
  const QuizRepository();

  List<QuizQuestion> getQuestions() {
    return const [
      QuizQuestion(
        id: 'q1',
        prompt: 'Which one is the letter A?',
        choices: ['A', 'B', 'C', 'D'],
        correctIndex: 0,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: 'How many apples? ðŸŽðŸŽðŸŽ',
        choices: ['1', '2', '3', '4'],
        correctIndex: 2,
      ),
      QuizQuestion(
        id: 'q3',
        prompt: 'What color is the sun? â˜€ï¸',
        choices: ['Blue', 'Green', 'Yellow', 'Purple'],
        correctIndex: 2,
      ),
    ];
  }
}