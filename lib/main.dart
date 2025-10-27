import 'package:flutter/material.dart';

import 'constants/colors.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _isLoggedIn() async {
    // Check if user email exists in secure storage
    final email = await SecureStorageService.getUserEmail();
    return email != null && email.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'IICM Scan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryAccent),
        scaffoldBackgroundColor: AppColors.primaryBackground,
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
