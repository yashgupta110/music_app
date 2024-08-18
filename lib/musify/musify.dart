import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

class Musify extends StatelessWidget {
  final oauth2.Client client;

  const Musify(this.client, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: getCurrentUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            );
          }

          final profile = snapshot.data;
          return Scaffold(
            body: Center(child: Text('Hello, ${profile!['display_name']}')),
          );
        });
  }

  Future<Map<String, dynamic>> getCurrentUserProfile() async {
    final response =
        await client.get(Uri.parse('https://api.spotify.com/v1/me'));
    return Map<String, dynamic>.from(json.decode(response.body));
  }
}
