
const String authorizationEndpoint = 'https://accounts.spotify.com/authorize';
const String tokenEndpoint = 'https://accounts.spotify.com/api/token';
const String redirectUri = 'http://127.0.0.1/callback'; // Adjust as needed
const String clientId = 'YOUR CLIENT ID';
const String clientSecret = 'YOUR SECERET ID ';
final List<String> scopes = [
  'user-read-email',
  'user-read-private'
]; // Adjust scopes as needed
