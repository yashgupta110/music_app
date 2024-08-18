class Video {
  final String id;
  final String title;
  final String author;
  final String thumbnailUrl;

  Video({
    required this.id,
    required this.title,
    required this.author,
    required this.thumbnailUrl,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id']['videoId'],
      title: json['snippet']['title'],
      author: json['snippet']['channelTitle'], // Assuming 'channelTitle' is the author
      thumbnailUrl: json['snippet']['thumbnails']['default']['url'],
    );
  }
}
