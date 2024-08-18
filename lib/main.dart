import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo/loginscreen.dart';
import 'package:demo/home.dart'; // Make sure this import is correct
import 'package:demo/provider/auth_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authClient = ref.watch(authClientProvider);

    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: authClient == null
          ? LoginScreen()
          : HomeScreen(client: authClient), // Pass the client to HomeScreen
    );
  }
}
