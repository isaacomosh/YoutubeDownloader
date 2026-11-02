import 'package:flutter/material.dart';
import '../services/video_service.dart';
import '../models/video_model.dart';
import '../screens/preview_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  final _videoService = VideoService();
  bool _isLoading = false;

  void _searchVideo() async {
    String query = _controller.text.trim();
    if (query.isEmpty) return;
    setState(() => _isLoading = true);
    VideoModel? video = await _videoService.getVideoDetails(query);
    setState(() => _isLoading = false);

    if (video != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PreviewScreen(video: video)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not fetch video. Check the link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Youtube Downloader')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Paste Youtube URL here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.link),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
