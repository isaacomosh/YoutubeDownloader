import 'package:flutter/foundation.dart';
import '../services/download_service.dart';

class DownloadProvider extends ChangeNotifier {
  final DownloadService _downloadService = DownloadService();

  // Tracks progress for active downloads {videoId: progressValue}
  final Map<String, double> _downloadProgress = {};

  // Tracks currently downloading video IDs
  final Set<String> _activeDownloads = {};

  double? getProgress(String videoId) => _downloadProgress[videoId];
  bool isDownloading(String videoId) => _activeDownloads.contains(videoId);

  Future<void> startDownload(
    String videoId,
    String title, {
    bool isAudioOnly = false,
  }) async {
    if (_activeDownloads.contains(videoId)) return;

    _activeDownloads.add(videoId);
    _downloadProgress[videoId] = 0.0;
    notifyListeners();

    try {
      await _downloadService.downloadVideo(
        videoId,
        title,
        isAudioOnly: isAudioOnly,
        onProgress: (progress) {
          _downloadProgress[videoId] = progress;
          notifyListeners();
        },
      );
    } catch (e) {
      print('Provider download failed: $e');
    } finally {
      _activeDownloads.remove(videoId);
      // Keep or clear progress when finished
      notifyListeners();
    }
  }
}
