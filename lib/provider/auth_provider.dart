import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import '../musify/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authClientProvider = StateNotifierProvider<AuthNotifier, oauth2.Client?>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthNotifier(authService);
});

class AuthNotifier extends StateNotifier<oauth2.Client?> {
  final AuthService authService;

  AuthNotifier(this.authService) : super(null) {
    _loadClient();
  }

  Future<void> _loadClient() async {
    final client = await authService.getClient();
    if (client != null && !client.credentials.isExpired) {
      state = client;
    }
  }

  Future<void> login() async {
    final client = await authService.authenticate();
    if (client != null) {
      state = client;
    }
  }

  Future<void> logout() async {
    await authService.logout();
    state = null;
  }
}
