import 'package:flutter/material.dart';

class FunFactsScreen extends StatefulWidget {
  const FunFactsScreen({super.key});

  @override
  _FunFactsScreenState createState() => _FunFactsScreenState();
}

class _FunFactsScreenState extends State<FunFactsScreen> {
  int currentIndex = 0;

  final List<String> funFacts = [
    "The shortest war in history was between Britain and Zanzibar on August 27, 1896. Zanzibar surrendered after 38 minutes.",
    "Bananas are berries, but strawberries aren't.",
    "The world's oldest known recipe is for beer.",
    "The unicorn is the national animal of Scotland.",
    "The shortest complete sentence in the English language is 'I am.'",
    "A group of flamingos is called a 'flamboyance.'",
    "Octopuses have three hearts.",
    "The Earth has traveled more than 5,000 miles in the past 5 minutes.",
    "There are more fake flamingos in the world than real ones.",
    "A single cloud can weigh more than 1 million pounds.",
    "Honey never spoils. Archaeologists have found pots of honey in ancient Egyptian tombs that are over 3,000 years old and still perfectly edible.",
    "Cows have best friends.",
    "The Eiffel Tower can be 15 cm taller during the summer due to thermal expansion.",
    "Polar bears have black skin under their white fur.",
    "A day on Venus is longer than its year.",
    "Giraffes have the same number of vertebrae in their necks as humans.",
    "Turtles can breathe through their butts.",
    "The smell of freshly-cut grass is actually a plant distress call.",
    "The shortest distance between two points on Earth is a straight line through the Earth's core.",
    "The voice of Mickey Mouse and the voice of Minnie Mouse got married in real life.",
    "The human brain can read up to 1,000 words per minute.",
    "Banging your head against a wall for one hour burns 150 calories.",
    "A group of pandas is called an 'embarrassment.'",
    "The strongest muscle in the human body is the masseter, the muscle that closes the jaw.",
    "The average person will spend 25 years asleep.",
    "The Great Wall of China is not visible from space without aid.",
    "It takes 8 minutes and 20 seconds for light to travel from the Sun to the Earth.",
    "The total weight of all ants on Earth is roughly equal to the total weight of all humans.",
    "The average person will shed around 40 pounds of skin in their lifetime.",
    "Bees can recognize human faces.",
  ];

  void nextFunFact() {
    setState(() {
      currentIndex = (currentIndex + 1) % funFacts.length;
    });
  }

  void previousFunFact() {
    setState(() {
      currentIndex = (currentIndex - 1 + funFacts.length) % funFacts.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fun Facts'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Color.fromARGB(255, 246, 246, 247)],
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              funFacts[currentIndex],
              style: const TextStyle(
                fontSize: 24.0,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: previousFunFact,
                  child: const Text('Previous'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: nextFunFact,
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
