import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/video_model.dart';
import '../providers/download_provider.dart';

class PreviewScreen extends StatelessWidget {
  final VideoModel video;

  const PreviewScreen({super.key, required this.video});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0
        ? '$hours:$minutes:$seconds'
        : '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final downloadProvider = Provider.of<DownloadProvider>(context);
    final bool downloading = downloadProvider.isDownloading(video.id);
    final double? progress = downloadProvider.getProgress(video.id);

    return Scaffold(
      appBar: AppBar(title: const Text('Download Preview')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                video.thumbnailUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 50),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              video.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Author & Duration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  video.author,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                Text(
                  'Duration: ${_formatDuration(video.duration)}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Progress bar if downloading
            if (downloading) ...[
              LinearProgressIndicator(value: progress),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Downloading... ${((progress ?? 0) * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Action Buttons
            if (!downloading) ...[
              ElevatedButton.icon(
                onPressed: () {
                  downloadProvider.startDownload(
                    video.id,
                    video.title,
                    isAudioOnly: false,
                  );
                },
                icon: const Icon(Icons.videocam),
                label: const Text('Download Video (MP4)'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  downloadProvider.startDownload(
                    video.id,
                    video.title,
                    isAudioOnly: true,
                  );
                },
                icon: const Icon(Icons.audiotrack),
                label: const Text('Download Audio Only (MP3)'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
