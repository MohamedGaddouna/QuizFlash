// controllers/quiz_controller.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz.dart';

class QuizController {
  static Future<List<Quiz>> fetchQuizzes(int eventId) async {
    final response = await http.get(Uri.parse('http://localhost/time_traveler_app/get_quiz.php?event_id=$eventId'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Quiz.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load quizzes');
    }
  }

Future<void> saveResult(int eventId, int score) async {
  final response = await http.post(
    Uri.parse('http://localhost/time_traveler_app/save_result.php'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, int>{
      'event_id': eventId,
      'score': score,
    }),
  );


  if (response.statusCode != 200) {
    throw Exception('Failed to save result: ${response.body}');
  }
}

}
