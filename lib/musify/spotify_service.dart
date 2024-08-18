import 'dart:convert';
import 'package:http/http.dart' as http;

class SpotifyService {
  final String accessToken;

  SpotifyService(this.accessToken);

  Future<Map<String, dynamic>> getCurrentUserProfile() async {
    final response = await http.get(
      Uri.https('api.spotify.com', '/v1/me'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    return json.decode(response.body);
  }
}
