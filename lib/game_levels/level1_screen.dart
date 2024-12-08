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
      debugShowCheckedModeBanner: false,
      home: Level1Screen(),
    );
  }
}

class Level1Screen extends StatefulWidget {
  const Level1Screen({super.key});

  @override
  _Level1ScreenState createState() => _Level1ScreenState();
}

class _Level1ScreenState extends State<Level1Screen> {
  Map<String, String> objectSymbols = {
    'Apple': '🍎',
    'Banana': '🍌',
    'Orange': '🍊',
    'Grapes': '🍇',
    'Mango': '🥭',
  };

  String displayedObject = '';
  int expectedCount = 0;
  int userCount = 0;
  int points = 0;
  double containerWidth = 300;
  double containerHeight = 300;
  bool isCounting = false;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    generateRandomObject();
  }

  void generateRandomObject() {
    var random = Random();
    setState(() {
      displayedObject = objectSymbols.keys.elementAt(random.nextInt(objectSymbols.length));
      expectedCount = random.nextInt(10) + 1;
      userCount = 0;
      isCounting = false;
    });
  }

  void verifyCount() {
    if (userCount == expectedCount) {
      setState(() {
        points += 10;
      });
      generateRandomObject();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Game Over'),
          content: Text('Your count was incorrect. Your score: $points'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  points = 0;
                });
                generateRandomObject();
              },
              child: const Text('Restart'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> symbols = _buildObjectSymbols(displayedObject);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Count The Objects'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[900]!, Colors.blue[700]!], // Use non-nullable colors
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Count the object(s):',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: containerWidth,
                    height: containerHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IgnorePointer(
                      ignoring: isCounting,
                      child: Stack(
                        children: symbols,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (!isCounting && userCount > 0) {
                            setState(() {
                              userCount--;
                            });
                          }
                        },
                        color: Colors.white,
                      ),
                      Text(
                        userCount.toString(),
                        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          if (!isCounting) {
                            setState(() {
                              userCount++;
                            });
                          }
                        },
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (!isCounting) {
                        setState(() {
                          isCounting = true;
                        });
                      }
                      verifyCount();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      isCounting ? 'Verifying...' : 'Verify Count',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Points: $points',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildObjectSymbols(String object) {
    List<Widget> objects = [];
    var random = Random();
    for (int i = 0; i < expectedCount; i++) {
      double left = random.nextDouble() * (containerWidth - 50);
      double top = random.nextDouble() * (containerHeight - 50);
      objects.add(Positioned(
        left: left,
        top: top,
        child: Text(
          objectSymbols[object] ?? '',
          style: const TextStyle(fontSize: 40),
        ),
      ));
    }
    return objects;
  }
}
