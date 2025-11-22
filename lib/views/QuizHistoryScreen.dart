import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuizHistoryScreen extends StatefulWidget {
  @override
  _QuizHistoryScreenState createState() => _QuizHistoryScreenState();
}

class _QuizHistoryScreenState extends State<QuizHistoryScreen> {
  List<Map<String, dynamic>> _quizHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuizHistory();
  }

  // Fonction pour récupérer l'historique des quiz depuis l'API
  Future<void> _fetchQuizHistory() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost/time_traveler_appv2/get_quiz_history.php'), // Remplacez par l'URL de votre API
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          setState(() {
            _quizHistory = List<Map<String, dynamic>>.from(responseData['data']);
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          _showError('Erreur : ${responseData['message']}');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        _showError('Erreur serveur : ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Erreur réseau : $e');
    }
  }

  // Affiche une boîte de dialogue d'erreur
  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flash Card"),
        backgroundColor: const Color.fromARGB(255, 24, 137, 202),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _quizHistory.isEmpty
              ? Center(
                  child: Text(
                    "Aucun historique disponible.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _quizHistory.length,
                  itemBuilder: (context, index) {
                    final quiz = _quizHistory[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ID : ${quiz['id']}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Text("Question : ${quiz['question']}"),
                            SizedBox(height: 8),
                            Text("Réponse correcte : ${quiz['correct_answer']}"),
                            SizedBox(height: 8),
                            Text("Réponse utilisateur : ${quiz['user_answer']}"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
