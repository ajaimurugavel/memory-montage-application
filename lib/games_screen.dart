import 'package:flutter/material.dart';
import 'package:memory_montage_lite/game_levels/level2_screen.dart';

import 'game_levels/fun_facts.dart';
import 'game_levels/level1_screen.dart';
import 'game_levels/level3_screen.dart';
import 'game_levels/more_game_screen.dart';
import 'game_levels/more_reading_screen.dart'; // Import MoreReadingScreen

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Games'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Colors.deepPurpleAccent],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Memory Mischief',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                padding: const EdgeInsets.all(20.0),
                children: [
                  _buildLevelButton(context, 'Level 1', '🧠', Level1Screen(), Colors.green),
                  _buildLevelButton(context, 'Level 2', '🃏', Level2Screen(), Colors.blue),
                  _buildLevelButton(context, 'Level 3', '🔍', Level3Screen(), Colors.orange),
                  _buildFactsButton(context, 'Fun Facts', '📚', Colors.yellow),
                  _buildMoreGameButton(context, 'More Game', Icons.games, MoreGameScreen(), Colors.pink),
                  _buildMoreReadingButton(context, 'More Reading', Icons.book, MoreReadingScreen(), Colors.purple), // New button for More Reading
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelButton(BuildContext context, String label, String symbol, Widget screen, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: _buildButton(label, symbol, color),
    );
  }

  Widget _buildFactsButton(BuildContext context, String label, String symbol, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FunFactsScreen()),
        );
      },
      child: _buildButton(label, symbol, color),
    );
  }

  Widget _buildMoreGameButton(BuildContext context, String label, IconData icon, Widget screen, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: _buildButtonWithIcon(label, icon, color),
    );
  }

  Widget _buildMoreReadingButton(BuildContext context, String label, IconData icon, Widget screen, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: _buildButtonWithIcon(label, icon, color),
    );
  }

  Widget _buildButton(String label, String symbol, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            symbol,
            style: const TextStyle(
              fontSize: 42.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonWithIcon(String label, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 42.0,
            color: Colors.white,
          ),
          const SizedBox(height: 12.0),
          Text(
            label,
            style: const TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
