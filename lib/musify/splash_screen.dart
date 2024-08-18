// import 'package:demo/loginscreen.dart';
// import 'package:demo/provider/auth_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:oauth2/oauth2.dart' as oauth2; // Ensure you import oauth2.Client
// import 'musify.dart';

// class SplashScreen extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Listen to authClientProvider to handle navigation
//     ref.listen<oauth2.Client?>(authClientProvider, (previous, next) {
//       if (next != null) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => Musify(next)),
//         );
//       } else {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => LoginScreen()),
//         );
//       }
//     });

//     // Ensure that loadClient is called to initialize client state
//     ref.read(authClientProvider.notifier).loadClient();

//     return Scaffold(
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }
// }
