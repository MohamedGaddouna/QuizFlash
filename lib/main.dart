import 'package:flutter/material.dart';
import 'package:quiz_tp1_bd/views/home_screen.dart';

void main() async {
   runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(), // L'écran principal pour générer un quiz
    );
  }
}
