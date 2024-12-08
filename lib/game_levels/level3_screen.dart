import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Level3Screen(),
    );
  }
}

class Level3Screen extends StatefulWidget {
  const Level3Screen({super.key});

  @override
  _Level3ScreenState createState() => _Level3ScreenState();
}

class _Level3ScreenState extends State<Level3Screen> {
  final Map<String, List<String>> categories = {
    'Fruits': ['🍎', '🍌', '🍒', '🍇', '🍉', '🍓', '🥑', '🥥', '🥝', '🍋', '🍊', '🍏', '🍐', '🥭', '🍍'],
    'Animals': ['🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼', '🐨', '🐯', '🦁', '🐮', '🐷', '🐸', '🐵'],
    'Professions': ['👮‍♂️', '👩‍🚒', '👨‍🎨', '👩‍🔬', '👨‍🍳', '👩‍🌾', '👨‍🚀', '👩‍🎓', '👨‍⚖️', '👩‍⚕️'],
    'Sports': ['⚽', '🏀', '🏈', '⚾', '🥎', '🎾', '🏐', '🏉', '🎱', '🏓', '🏸', '🏒', '🥍', '🏑', '🥊'],
    'Transport': ['🚗', '🚕', '🚙', '🚌', '🚎', '🏎️', '🚓', '🚑', '🚒', '🚐', '🛻', '🚚', '🚛', '🚜', '🛴'],
  };

  String category = '';
  String targetObject = '';
  bool gameStarted = false;
  bool gameWon = false;
  int points = 0;
  List<String> shuffledOptions = [];

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    setState(() {
      gameStarted = true;
      gameWon = false;
      category = categories.keys.elementAt(Random().nextInt(categories.length));
      targetObject = categories[category]![Random().nextInt(categories[category]!.length)];
      shuffledOptions = List.from(categories[category]!)..shuffle();
    });
  }

  void _checkAnswer(String selectedObject) {
    if (selectedObject == targetObject) {
      setState(() {
        gameWon = true;
        points += 10;
      });
      _startGame(); // Start a new round
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FIND'), 
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (gameStarted)
              Column(
                children: [
                  Text(
                    'Find the $targetObject in $category!',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 20,
              children: gameStarted
                  ? shuffledOptions.map((object) {
                      return ElevatedButton(
                        onPressed: gameStarted && !gameWon ? () => _checkAnswer(object) : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          backgroundColor: gameWon && object == targetObject ? Colors.green : Colors.blue,
                          shape: const CircleBorder(),
                          elevation: 5,
                        ),
                        child: Text(
                          object,
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList()
                  : [],
            ),
            const SizedBox(height: 20),
            Text('Points: $points', style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
