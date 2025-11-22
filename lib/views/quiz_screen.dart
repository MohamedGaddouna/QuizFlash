// views/quiz_screen.dart
import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/quiz.dart';
import '../controllers/quiz_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuizScreen extends StatefulWidget {
  final Event event;

  QuizScreen({required this.event});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<List<Quiz>> futureQuiz;
  List<Quiz> quizList = [];
  List<String?> selectedAnswers = [];
  List<String> feedbackList = [];
  int correctAnswersCount = 0;
  bool isQuizFinished = false;

  @override
  void initState() {
    super.initState();
    futureQuiz = QuizController.fetchQuizzes(widget.event.id);
  }

  void validateAnswer(int index, Quiz quiz) {
    if (!isQuizFinished) {
      setState(() {
        if (selectedAnswers[index] == quiz.correctAnswer) {
          feedbackList[index] = "Correct!";
          correctAnswersCount++;
        } else {
          feedbackList[index] = "Incorrect! The correct answer is: ${quiz.correctAnswer}";
        }
      });
    }
  }

  Future<void> saveResult() async {
    final response = await http.post(
      Uri.parse('http://localhost/time_traveler_app/save_result.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'event_id': widget.event.id,
        'score': correctAnswersCount,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Score saved successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save score.")),
      );
    }
  }

  void finishQuiz() {
    setState(() {
      isQuizFinished = true;
      for (int i = 0; i < selectedAnswers.length; i++) {
        if (selectedAnswers[i] == null) {
          feedbackList[i] = "You did not answer this question.";
        } else {
          feedbackList[i] = selectedAnswers[i] == quizList[i].correctAnswer 
              ? "Correct! The correct answer is: ${quizList[i].correctAnswer}"
              : "Incorrect! The correct answer is: ${quizList[i].correctAnswer}";
        }
      }
    });
    saveResult();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quiz on ${widget.event.title}")),
      body: FutureBuilder<List<Quiz>>(
        future: futureQuiz,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            quizList = snapshot.data!;
            if (selectedAnswers.isEmpty) {
              selectedAnswers = List.filled(quizList.length, null);
              feedbackList = List.filled(quizList.length, "");
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: quizList.length,
                    itemBuilder: (context, index) {
                      final quiz = quizList[index];
                      return Card(
                        margin: EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                quiz.question,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 10),
                              ...quiz.options.map((option) {
                                return RadioListTile<String>(
                                  title: Text(option),
                                  value: option,
                                  groupValue: selectedAnswers[index],
                                  onChanged: isQuizFinished ? null : (value) {
                                    setState(() {
                                      selectedAnswers[index] = value;
                                      validateAnswer(index, quiz);
                                    });
                                  },
                                  activeColor: Colors.blue,
                                );
                              }).toList(),
                              if (isQuizFinished)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    feedbackList[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: feedbackList[index].contains("Correct") ? Colors.green : Colors.red,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (isQuizFinished)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Your Score: $correctAnswersCount/${quizList.length}",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isQuizFinished ? Colors.grey : Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: isQuizFinished ? null : finishQuiz,
                    child: Text(
                      isQuizFinished ? "Quiz Finished" : "Finish Quiz",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
