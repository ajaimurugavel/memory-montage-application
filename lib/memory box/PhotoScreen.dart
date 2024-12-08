import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PhotoScreen(),
    );
  }
}

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({super.key});

  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  List<String> memories = [];
  String currentMemory = '';
  bool isSlideShowActive = false;
  int currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    loadMemories();
    showRandomMemory();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> loadMemories() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      memories = prefs.getStringList('memories') ?? [];
    });
  }

  Future<void> saveMemory(String imageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    memories.add(imageUrl);
    await prefs.setStringList('memories', memories);
    _showSlideShowPrompt(imageUrl);
  }

  Future<void> deleteMemory(String imageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    memories.remove(imageUrl);
    await prefs.setStringList('memories', memories);
    showRandomMemory(); // Refresh the screen after deletion
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      await saveMemory(imageFile.path);
      setState(() {
        memories.add(imageFile.path);
      });
    }
  }

  void showRandomMemory() {
    setState(() {
      final random = Random();
      currentMemory = memories.isNotEmpty
          ? memories[random.nextInt(memories.length)]
          : '';
    });
  }

  void toggleSlideShow() {
    setState(() {
      isSlideShowActive = !isSlideShowActive;
      if (isSlideShowActive) {
        startSlideShow();
      } else {
        stopSlideShow();
      }
    });
  }

  void startSlideShow() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % memories.length;
        currentMemory = memories[currentIndex];
      });
    });
  }

  void stopSlideShow() {
    _timer?.cancel();
  }

  void _showSlideShowPrompt(String imageUrl) {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedDate = formatter.format(now);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New Memory Added'),
          content: const Text('Do you want to start a slideshow with this photo?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                toggleSlideShow();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Screen'),
      ),
      body: Center(
        child: currentMemory.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImage(
                        imagePath: currentMemory,
                        onDelete: () {
                          deleteMemory(currentMemory);
                          Navigator.pop(context); // Close full-screen view after deletion
                        },
                      ),
                    ),
                  );
                },
                child: Image.file(
                  File(currentMemory),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        tooltip: 'Add Memory',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (currentMemory.isNotEmpty) // Show delete option only when a photo is viewed
              IconButton(
                onPressed: () {
                  deleteMemory(currentMemory);
                },
                icon: const Icon(Icons.delete),
              ),
            IconButton(
              onPressed: toggleSlideShow,
              icon: Icon(isSlideShowActive ? Icons.pause : Icons.play_arrow),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GalleryScreen(memories: memories),
                  ),
                );
              },
              icon: const Icon(Icons.photo_library),
            ),
            IconButton( // Shuffle option
              onPressed: () {
                setState(() {
                  memories.shuffle();
                  currentIndex = 0;
                  currentMemory = memories.isNotEmpty ? memories[currentIndex] : '';
                });
              },
              icon: const Icon(Icons.shuffle),
            ),
          ],
        ),
      ),
    );
  }
}

class GalleryScreen extends StatelessWidget {
  final List<String> memories;

  const GalleryScreen({super.key, required this.memories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: memories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenImage(
                    imagePath: memories[index],
                    onDelete: () {
                      // Implement delete action here if needed
                    },
                  ),
                ),
              );
            },
            child: Image.file(File(memories[index]), fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imagePath;
  final Function onDelete;

  const FullScreenImage({super.key, required this.imagePath, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Screen Image'),
        actions: [
          IconButton(
            onPressed: () {
              onDelete();
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Image.file(File(imagePath)),
        ),
      ),
    );
  }
}
