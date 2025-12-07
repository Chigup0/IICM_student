import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'secure_storage.dart';

final SystemUiOverlayStyle _whiteStatusBarStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarBrightness:
      Brightness.dark, // iOS: status bar background is dark -> content light
  statusBarIconBrightness: Brightness.light, // Android: white icons
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 Fix nav bar and system theme (no red tint)
  // Source - https://stackoverflow.com/a
  // Posted by Sanjayrajsinh, modified by community. See post 'Timeline' for change history
  // Retrieved 2025-12-07, License - CC BY-SA 4.0

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Lock to portrait mode (optional but recommended)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _isLoggedIn() async {
    final email = await SecureStorageService.getUserEmail();
    return email != null && email.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),
      ),

      home: FutureBuilder<bool>(
        future: _isLoggedIn(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == true) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
