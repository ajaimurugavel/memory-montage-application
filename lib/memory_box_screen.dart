import 'package:flutter/material.dart';

import 'memory box/PhotoScreen.dart';
import 'memory box/VideoScreen.dart';

class MemoryBoxScreen extends StatelessWidget {
  const MemoryBoxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Box'),
        backgroundColor: const Color.fromARGB(255, 37, 209, 243),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: InkWell(
                onTap: () {
                  _navigateToStorageUnit(context, 'The Past is Not Lost. Find It Here');
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 37, 209, 243),
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'The Past is Not Lost. Find It Here',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            _buildMemoryBoxButton(context, 'Photos', '📸', 'Let Photos Help You Remember Who You Are', PhotoScreen()),
            const SizedBox(height: 20.0),
            _buildMemoryBoxButton(context, 'Videos', '📹', 'Videos: Your Window to the Past', VideoScreen()),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 37, 209, 243),
    );
  }

  Widget _buildMemoryBoxButton(BuildContext context, String type, String symbol, String description, Widget screen) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              type,
              style: const TextStyle(
                fontSize: 24.0,
                color: Color.fromARGB(255, 18, 40, 104),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15.0),
            Text(
              symbol,
              style: const TextStyle(
                fontSize: 40.0,
                color: Color.fromARGB(255, 18, 40, 104),
              ),
            ),
            const SizedBox(height: 15.0),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16.0,
                color: Color.fromARGB(255, 18, 40, 104),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToStorageUnit(BuildContext context, String type) {
    // You can implement this if needed
  }
}
