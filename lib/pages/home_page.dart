import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../pages/bottom_nav.dart';
import '../pages/qr_dialog.dart';
import '../secure_storage.dart';
import 'events_page.dart';
import 'info_page.dart';
import 'profile_page.dart';
import 'rulebook_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  Widget _buildHomeContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to IICM',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 20),
          // Add your home content here
          // For example:
          Card(
            color: AppColors.secondaryBackground,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Add quick action buttons or links
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const EventsScreen();
      case 2:
        return const RulebookScreen();
      case 3:
        return const TeamScreen();
      case 4:
        return const ProfileScreen();
      default:
        return _buildHomeContent();
    }
  }

  void _showQrCode() {
    showDialog(context: context, builder: (context) => const QrDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryAccent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/logo.png'),
        ),
        title: FutureBuilder<String?>(
          future: SecureStorageService.getUserName(),
          builder: (context, snapshot) {
            return Text(
              'Hi ${snapshot.data ?? ""}',
              style: const TextStyle(color: Colors.white),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code, color: Colors.white),
            onPressed: _showQrCode,
          ),
        ],
      ),
      body: _getPage(_currentIndex),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
