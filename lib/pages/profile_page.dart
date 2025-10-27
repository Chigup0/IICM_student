import 'package:flutter/material.dart';

import '../secure_storage.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: SecureStorageService.getUserName(),
      builder: (context, snapshot) {
        return Column(
          children: [
            Text('Profile: ${snapshot.data ?? ""}'),
            // Add more profile information here
          ],
        );
      },
    );
  }
}
