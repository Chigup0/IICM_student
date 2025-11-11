import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../secure_storage.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileItem(
                  context,
                  'Name',
                  SecureStorageService.getUserName(),
                  Icons.person,
                ),
                _buildProfileItem(
                  context,
                  'Email',
                  SecureStorageService.getUserEmail(),
                  Icons.email,
                ),
                _buildProfileItem(
                  context,
                  'Roll No',
                  SecureStorageService.getUserRollNo(),
                  Icons.badge,
                ),
                _buildProfileItem(
                  context,
                  'Gender',
                  SecureStorageService.getUserGender(),
                  Icons.wc,
                ),
                _buildProfileItem(
                  context,
                  'Event',
                  SecureStorageService.getUserEvent(),
                  Icons.event,
                ),
                _buildProfileItem(
                  context,
                  'Team',
                  SecureStorageService.getUserTeam(),
                  Icons.group,
                ),
                _buildProfileItem(
                  context,
                  'Hall',
                  SecureStorageService.getUserHall(),
                  Icons.home,
                ),
                _buildProfileItem(
                  context,
                  'Last Meal',
                  SecureStorageService.getUserMeal(),
                  Icons.restaurant,
                ),
                _buildProfileItem(
                  context,
                  'Code',
                  SecureStorageService.getUserCode(),
                  Icons.code,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(
    BuildContext context,
    String label,
    Future<String?> future,
    IconData icon,
  ) {
    return FutureBuilder<String?>(
      future: future,
      builder: (context, snapshot) {
        final value = snapshot.data ?? 'N/A';
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.secondaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primaryAccent.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.primaryAccent, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
