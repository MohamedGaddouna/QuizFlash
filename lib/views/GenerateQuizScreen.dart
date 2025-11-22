import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GenerateQuizScreen extends StatefulWidget {
  @override
  _GenerateQuizScreenState createState() => _GenerateQuizScreenState();
}

class _GenerateQuizScreenState extends State<GenerateQuizScreen> {
  String _quizText = 'Cliquez sur "Générer un Quiz" pour commencer';
  bool _isLoading = false;
  final String _apiKey = 'AIzaSyCsmjFBj35iuQS4LLk-4RYKHX23KeROqEU'; // Remplacez par votre clé API valide
  String _userQuestion = '';
  String _generatedQuestion = ''; // Variable pour stocker la question générée par l'API
  TextEditingController _responseController = TextEditingController();
  String _submittedResponses = '';
  String _correctAnswers = ''; // Variable pour stocker les réponses correctes

  // Fonction pour appeler l'API et récupérer les données
  Future<void> _generateQuiz() async {
    if (_userQuestion.isEmpty) {
      setState(() {
        _quizText = 'Veuillez saisir une question avant de générer un quiz.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _correctAnswers = ''; // Réinitialiser les réponses correctes
    });

    try {
      final response = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$_apiKey',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text': _userQuestion +
                      " (Veuillez fournir des choix multiples, et indiquez les réponses correctes en écrivant 'Réponse : [text]')"
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['candidates'] != null &&
            responseData['candidates'].isNotEmpty) {
          String quizText =
              responseData['candidates'][0]['content']['parts'][0]['text'];

          // Enregistrer la question générée
          _generatedQuestion = quizText;

          // Extraire les réponses correctes
          RegExp answerRegExp = RegExp(r'Réponse\s*:\s*(.+)', multiLine: true);
          Iterable<RegExpMatch> matches = answerRegExp.allMatches(quizText);

          // Enregistrer les réponses correctes séparément
          _correctAnswers = matches
              .map((match) => match.group(1)?.trim() ?? '')
              .join('\n');

          // Nettoyer le texte du quiz en supprimant les réponses correctes
          quizText = quizText.replaceAll(RegExp(r'Réponse\s*:.+'), '');

          setState(() {
            _quizText = quizText.isNotEmpty ? quizText : 'Aucun quiz généré.';
          });

          // Envoyer la question générée et les réponses correctes à l'API PHP
          await ();
        } else {
          setState(() {
            _quizText = 'Aucune donnée retournée par l\'API';
          });
        }
      } else {
        final errorResponse = jsonDecode(response.body);
        setState(() {
          _quizText =
              'Erreur : ${response.statusCode} - ${errorResponse['error']['message']}';
        });
      }
    } catch (e) {
      setState(() {
        _quizText = 'Erreur de connexion : $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fonction pour soumettre les réponses de l'utilisateur
  Future<void> _submitResponses() async {
    if (_responseController.text.isEmpty) {
      return;
    }

    setState(() {
      List<String> responses = _responseController.text
          .split(',')
          .map((response) => response.trim())
          .toList();
      _submittedResponses = responses.join(', ');
    });

    // Envoyer les réponses de l'utilisateur à l'API PHP
    try {
      final response = await http.post(
        Uri.parse('http://localhost/time_traveler_appv2/submit_responses.php'), // Remplacez par votre URL
        body: {
          'question': _generatedQuestion, // Utilisez la question générée ici
          'correct_answer': _correctAnswers,
          'user_answer': _submittedResponses,
        },
      );

      if (response.statusCode == 200) {
        // Réponse reçue du serveur, afficher un message de confirmation
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Résultats du Quiz'),
              content: Text(
                'Vos réponses : $_submittedResponses\n\nRéponses correctes : $_correctAnswers',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          _quizText = 'Erreur lors de l\'envoi des réponses au serveur.';
        });
      }
    } catch (e) {
      setState(() {
        _quizText = 'Erreur de connexion au serveur : $e';
      });
    }

    _responseController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Générateur de Quiz'),
        backgroundColor: const Color.fromARGB(255, 24, 137, 202),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Zone pour saisir une question
            TextField(
              onChanged: (value) {
                _userQuestion = value;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Veuillez saisir une question pour générer un quiz',
                hintText: 'La question doit commencer par "Donner un quiz" suivi du sujet ou de la question', // Placeholder mis à jour
              ),
            ),
            SizedBox(height: 20),
            // Bouton pour générer le quiz
            ElevatedButton(
              onPressed: _isLoading ? null : _generateQuiz,
              child: Text('Générer un Quiz'),
            ),
            SizedBox(height: 20),
            // Affichage du quiz généré
            _isLoading
                ? CircularProgressIndicator()
                : Text(
                    _quizText,
                    textAlign: TextAlign.center,
                  ),
            SizedBox(height: 20),
            // Zone pour saisir les réponses
            TextField(
              controller: _responseController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Entrez vos réponses (séparées par des virgules)',
              ),
            ),
            SizedBox(height: 20),
            // Bouton pour valider les réponses
            ElevatedButton(
              onPressed: _submitResponses,
              child: Text('Valider les réponses'),
            ),
            SizedBox(height: 20),
            // Affichage des réponses soumises
            Text(
              _submittedResponses.isEmpty
                  ? 'Aucune réponse soumise.'
                  : 'Réponses soumises : $_submittedResponses',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
