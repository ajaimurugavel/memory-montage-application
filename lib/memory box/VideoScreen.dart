import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        hintColor: Colors.orangeAccent,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: VideoScreen(),
    );
  }
}

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> with AutomaticKeepAliveClientMixin {
  List<VideoData> videos = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    loadVideos(); // Load videos when the screen is first created
  }

  Future<void> loadVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? videoList = prefs.getStringList('videos');
    if (videoList != null) {
      setState(() {
        videos = videoList.map((videoString) {
          Map<String, dynamic> videoMap = jsonDecode(videoString);
          return VideoData(path: videoMap['path'], name: videoMap['name']);
        }).toList();
      });
    }
  }

  Future<void> saveVideo(String videoPath, String videoName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> videoList = prefs.getStringList('videos') ?? [];
    videoList.add(jsonEncode({'path': videoPath, 'name': videoName}));
    await prefs.setStringList('videos', videoList);
  }

  Future<void> deleteVideo(String videoPath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> videoList = prefs.getStringList('videos') ?? [];
    videoList.removeWhere((videoString) {
      Map<String, dynamic> videoMap = jsonDecode(videoString);
      return videoMap['path'] == videoPath;
    });
    await prefs.setStringList('videos', videoList);
  }

  Future<void> _pickVideo() async {
    final pickedFile =
        await ImagePicker().getVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File videoFile = File(pickedFile.path);
      final String videoName =
          videoFile.path.split('/').last; // Get the file name
      await saveVideo(videoFile.path, videoName);
      setState(() {
        videos.add(VideoData(path: videoFile.path, name: videoName));
      });
    }
  }

  void playVideo(List<VideoData> videos, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          videos: videos,
          initialIndex: index,
        ),
      ),
    );
  }

  Future<void> _refreshVideos() async {
    setState(() {
      videos = []; // Clear existing videos
    });
    await loadVideos(); // Load videos again
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshVideos,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    child: ListTile(
                      title: Text(videos[index].name),
                      onTap: () {
                        playVideo(videos, index);
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          deleteVideo(videos[index].path);
                          setState(() {
                            videos.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              onPressed: _pickVideo,
              tooltip: 'Add Video',
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final List<VideoData> videos;
  final int initialIndex;

  const VideoPlayerScreen(
      {super.key, required this.videos, required this.initialIndex});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _controller =
        VideoPlayerController.file(File(widget.videos[currentIndex].path));
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.videos[currentIndex].name),
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}

class VideoData {
  final String path;
  final String name;

  VideoData({required this.path, required this.name});
}
