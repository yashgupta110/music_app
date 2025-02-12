import 'dart:convert';
import 'package:http/http.dart' as http;
import 'video.dart';

class YouTubeService {
  final String apiKey = 'YOUR YOUTUBE API KEY';

  Future<List<Video>> fetchMusicVideos(String query) async {
    try {
      final url = 'https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&videoCategoryId=10&maxResults=20&q=$query&key=$apiKey';
      print('Fetching URL: $url');
      final response = await http.get(Uri.parse(url));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List videos = json.decode(response.body)['items'];
        return videos.map((v) => Video.fromJson(v)).toList();
      } else {
        throw Exception('Failed to load videos');
      }
    } catch (e) {
      print('Error fetching videos: $e');
      rethrow;
    }
  }
}
