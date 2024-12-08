import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreGameScreen extends StatelessWidget {
  const MoreGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More Game'),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildGameButton(context, 'Tricky Cups', 'https://www.improvememory.org/wp-content/games/trickycups_e_fullscreen.html', Icons.gamepad),
              const SizedBox(height: 20.0),
              _buildGameButton(context, 'Track Ball', 'https://www.improvememory.org/wp-content/games/trackballs_e_fullscreen.html', Icons.gamepad),
              const SizedBox(height: 20.0),
              _buildGameButton(context, 'Pattern Memory', 'https://www.improvememory.org/wp-content/games/patternmemory_e_fullscreen.html', Icons.gamepad),
              const SizedBox(height: 20.0),
              _buildGameButton(context, 'Puzzle', 'https://www.improvememory.org/wp-content/games/slide/index.html', Icons.gamepad),
              const SizedBox(height: 20.0),
              _buildGameButton(context, 'Road Block', 'https://www.improvememory.org/wp-content/games/road-block-puzzle/index.html', Icons.gamepad),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameButton(BuildContext context, String title, String url, IconData icon) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _launchURL(context, url);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.all(20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 50.0),
            const SizedBox(width: 20.0),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }

  void _launchURL(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to launch the game. Please try again later.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
