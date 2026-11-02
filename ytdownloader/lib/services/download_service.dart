import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class DownloadService {
  final _yt = YoutubeExplode();

  Future<void> downloadVideo(
    String videoId,
    String title, {
    bool isAudioOnly = false,
    required Function(double progress) onProgress,
  }) async {
    try {
      var manifest = await _yt.videos.streamsClient.getManifest(videoId);
      StreamInfo streamInfo;
      String fileExtension;

      if (isAudioOnly) {
        streamInfo = manifest.audioOnly.withHighestBitrate();
        fileExtension = 'mp3';
      } else {
        //Get mixed stream(video+audio combined)if available or highest video stream
        streamInfo = manifest.muxed.withHighestBitrate();
        fileExtension = 'mp4';
      }

      var stream = _yt.videos.streamsClient.get(streamInfo);
      //Get storage directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }
      //Sanitize file name
      String sanitizedTitle = title.replaceAll(RegExp(r'[\\/?:<>|*"]'), '');
      var filePath = '${directory!.path}/$sanitizedTitle.$fileExtension';
      var file = File(filePath);

      var fileStream = file.openWrite();
      var totalLength = streamInfo.size.totalGigaBytes;
      var downloaded = 0.0;

      await for (var data in stream) {
        downloaded += data.length;
        fileStream.add(data);
        var progress = downloaded / totalLength;
        onProgress(progress);
      }
      await fileStream.flush();
      await fileStream.close();
    } catch (e) {
      print('Dowload error: $e');
      rethrow;
    } finally {
      _yt.close();
    }
  }
}
