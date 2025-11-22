// models/quiz.dart

class Quiz {
  final int id;
  final String question;
  final String correctAnswer;
  final List<String> options;

  Quiz({required this.id, required this.question, required this.correctAnswer, required this.options});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      question: json['question'],
      correctAnswer: json['correct_answer'],
      options: [
        json['correct_answer'],
        json['wrong_answer1'],
        json['wrong_answer2'],
        json['wrong_answer3'],
      ]..shuffle(),
    );
  }
}
