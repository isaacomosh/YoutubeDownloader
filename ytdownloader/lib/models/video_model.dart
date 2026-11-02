class VideoModel {
  final String id;
  final String title;
  final String author;
  final String thumbnailUrl;
  final Duration duration;

  VideoModel({
    required this.id,
    required this.title,
    required this.author,
    required this.thumbnailUrl,
    required this.duration,
  });
}
