import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Level2Screen(),
    );
  }
}

class Level2Screen extends StatefulWidget {
  const Level2Screen({super.key});

  @override
  _MemoryGameState createState() => _MemoryGameState();
}

class _MemoryGameState extends State<Level2Screen> {
  List<String> rummyCards = [
    '🂡', '🂱', '🃁', '🃑', '🂢', '🂲', '🃂', '🃒', '🂣', '🂳', '🃃', '🃓', '🂤', '🂴', '🃄', '🃔',
    '🂥', '🂵', '🃅', '🃕', '🂦', '🂶', '🃆', '🃖', '🂧', '🂷', '🃇', '🃗', '🂨', '🂸', '🃈', '🃘',
    '🂩', '🂹', '🃉', '🃙', '🂪', '🂺', '🃊', '🃚', '🂫', '🂻', '🃋', '🃛', '🂭', '🂽', '🃍', '🃝',
    '🂮', '🂾', '🃎', '🃞'
  ];

  String constantCard = '🂡'; // Constant card to match with others
  List<String> cards = [];
  List<int> openedCardsIndex = [];
  bool canOpen = true;
  int attempts = 0;
  int pairsFound = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    // Initially add one constant card and one matching card
    cards.add(constantCard);
    cards.add(rummyCards[0]);
    cards.add(rummyCards[0]);

    // Add two matching cards for each successful match
    for (int i = 0; i < pairsFound; i++) {
      String card = rummyCards[i];
      cards.add(card);
      cards.add(card);
    }

    cards.shuffle();
  }

  void onCardTap(int index) {
    if (!canOpen || openedCardsIndex.contains(index) || openedCardsIndex.length >= 2) return;

    setState(() {
      openedCardsIndex.add(index);
    });

    if (openedCardsIndex.length == 2) {
      canOpen = false;
      Timer(const Duration(seconds: 1), () {
        checkMatch();
        canOpen = true;
      });
    }
  }

  void checkMatch() {
    if (cards[openedCardsIndex[0]] == cards[openedCardsIndex[1]]) {
      setState(() {
        pairsFound++;
        openedCardsIndex.clear();
        score += 10; // Increase score for a successful match
      });
      initializeGame(); // Add new matching pair
      if (pairsFound == rummyCards.length) {
        // All pairs found, you can display a congratulation message or navigate to a new screen
        // For simplicity, let's just print a message in the console
        print('Congratulations! You found all the pairs!');
      }
    } else {
      setState(() {
        openedCardsIndex.removeLast();
        openedCardsIndex.removeLast();
      });
    }
    attempts++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Game - Rummy Cards'),
      ),
      body: Column(
        children: [
          Text('Score: $score'), // Display the score
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Display three cards in a row
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (openedCardsIndex.length < 2) {
                      onCardTap(index);
                    }
                  },
                  child: Card(
                    color: openedCardsIndex.contains(index) ? Colors.white : Colors.blue,
                    child: Center(
                      child: Text(
                        openedCardsIndex.contains(index) ? cards[index] : '',
                        style: const TextStyle(fontSize: 24.0, color: Colors.black),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
