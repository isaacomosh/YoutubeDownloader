import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../models/video_model.dart';

class VideoService {
  final _yt = YoutubeExplode();

  Future<VideoModel?> getVideoDetails(String urlOrId) async {
    try {
      var video = await _yt.videos.get(urlOrId);
      return VideoModel(
        id: video.id.value,
        title: video.title,
        author: video.author,
        thumbnailUrl: video.thumbnails.highResUrl,
        duration: video.duration ?? Duration.zero,
      );
    } catch (e) {
      print('Error fetching video: $e');
      return null;
    }
  }

  void dispose() {
    _yt.close();
  }
}