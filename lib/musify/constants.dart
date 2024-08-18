
const String authorizationEndpoint = 'https://accounts.spotify.com/authorize';
const String tokenEndpoint = 'https://accounts.spotify.com/api/token';
const String redirectUri = 'http://127.0.0.1/callback'; // Adjust as needed
const String clientId = 'c64f11ced4534f3a8488e227d38d86ca';
const String clientSecret = 'e9e3666b760d4bda923c4021b6c05292';
final List<String> scopes = [
  'user-read-email',
  'user-read-private'
]; // Adjust scopes as needed
