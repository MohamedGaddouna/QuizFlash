import 'package:flutter/material.dart';
import 'GenerateQuizScreen.dart';
import 'QuizHistoryScreen.dart'; // Import de l'écran de l'historique

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Generation"),
        backgroundColor: const Color.fromARGB(255, 24, 137, 202), // Couleur de l'entête bleue
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0f7fa), Color(0xFFb2ebf2)], // Gradient de fond bleu clair
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Espacement autour du contenu
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Bouton pour générer un quiz avec une icône et un style amélioré
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GenerateQuizScreen(),
                      ),
                    );
                  },
                  icon: Icon(Icons.lightbulb_outline, color: Colors.white), // Icône pour le bouton
                  label: Text(
                    "Generate Quiz from Description",
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Texte en noir
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0288d1), // Couleur bleue du bouton
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Espacement interne
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40), // Coins plus arrondis
                    ),
                    elevation: 8, // Ombre plus marquée
                  ),
                ),
                SizedBox(height: 20), // Espacement entre les boutons

                // Bouton pour voir l'historique avec une icône et un style amélioré
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizHistoryScreen(),
                      ),
                    );
                  },
                  icon: Icon(Icons.history, color: Colors.white), // Icône pour l'historique
                  label: Text(
                    "Flash Carte",
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Texte en noir
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0288d1), // Couleur bleue du bouton
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Espacement interne
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40), // Coins plus arrondis
                    ),
                    elevation: 8, // Ombre plus marquée
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
