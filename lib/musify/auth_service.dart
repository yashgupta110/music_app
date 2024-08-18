import 'dart:convert';
import 'dart:io';
import 'package:demo/musify/constants.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AuthService {
  Future<oauth2.Client?> authenticate() async {
    final server = await HttpServer.bind('127.0.0.1', 0);
    final port = server.port;
    final redirectUri = 'http://${server.address.host}:$port/callback';

    final grant = oauth2.AuthorizationCodeGrant(
      clientId,
      Uri.parse(authorizationEndpoint),
      Uri.parse(tokenEndpoint),
      secret: clientSecret,
    );

    final authUrl = grant.getAuthorizationUrl(
      Uri.parse(redirectUri),
      scopes: scopes,
    );

    print('Generated Authorization URL: $authUrl');

    await _launchURL(authUrl);

    final responseUrl = await _listenForCode(server);

    if (responseUrl != null) {
      final client = await grant.handleAuthorizationResponse(responseUrl.queryParameters);

      await _saveCredentials(client.credentials);
      return client;
    }

    return null;
  }

  Future<void> _launchURL(Uri url) async {
    if (await canLaunchUrlString(url.toString())) {
      await launchUrlString(url.toString());
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<Uri?> _listenForCode(HttpServer server) async {
    try {
      final request = await server.first;

      final uri = request.uri;
      print('Received request URI: $uri');

      if (uri.queryParameters['error'] != null) {
        return null;
      }

      request.response
        ..statusCode = HttpStatus.ok
        ..headers.set(HttpHeaders.contentTypeHeader, 'text/html')
        ..write('<html><body>Authentication successful! Please close the browser window.</body></html>');
      await request.response.close();

      return uri;
    } finally {
      await server.close();
    }
  }

  Future<void> _saveCredentials(oauth2.Credentials credentials) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/credentials.json');
    await file.writeAsString(json.encode(credentials.toJson()));
    print('Credentials saved to ${file.path}');
  }

  Future<oauth2.Client?> getClient() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/credentials.json');
      if (await file.exists()) {
        final credentials = oauth2.Credentials.fromJson(await file.readAsString());

        if (credentials.isExpired && !credentials.canRefresh) {
          print('Credentials are expired and cannot be refreshed.');
          return null;
        }

        return oauth2.Client(credentials, identifier: clientId, secret: clientSecret);
      } else {
        print('No saved credentials found.');
      }
    } catch (e) {
      print('Failed to load credentials: $e');
    }
    return null;
  }

  Future<void> logout() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/credentials.json');
    if (await file.exists()) {
      await file.delete();
      print('Credentials deleted.');
    }
  }
}
