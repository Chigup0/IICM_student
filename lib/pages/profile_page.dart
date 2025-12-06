import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../secure_storage.dart';
import 'login_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showFullDetails = false;

  Future<void> _logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.secondaryBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Logout',
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: AppColors.secondaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.secondaryText),
            ),
          ),
          TextButton(
            onPressed: () async {
              await SecureStorageService.deleteUserData();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              }
            },
            child: Text(
              'Logout',
              style: TextStyle(color: AppColors.secondaryAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Profile Photo Section
                  Center(
                    child: FutureBuilder<String?>(
                      future: SecureStorageService.getUserImage(),
                      builder: (context, snapshot) {
                        final imageUrl = snapshot.data;
                        return GestureDetector(
                          onTap: () {
                            if (imageUrl != null && imageUrl.isNotEmpty) {
                              _showFullScreenImage(context, imageUrl);
                            }
                          },
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.secondaryBackground,
                              border: Border.all(
                                color: AppColors.primaryAccent,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryAccent.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: imageUrl != null && imageUrl.isNotEmpty
                                  ? Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Icon(
                                              Icons.person,
                                              size: 60,
                                              color: AppColors.primaryAccent,
                                            );
                                          },
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value:
                                                    loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                    : null,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(AppColors.primaryAccent),
                                              ),
                                            );
                                          },
                                    )
                                  : Icon(
                                      Icons.person,
                                      size: 60,
                                      color: AppColors.primaryAccent,
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // User Name
                  FutureBuilder<String?>(
                    future: SecureStorageService.getUserName(),
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data ?? 'User',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // All Details Box with Show More/Less integrated
                  GestureDetector(
                    onTap: () =>
                        setState(() => _showFullDetails = !_showFullDetails),
                    child: _buildDetailsBox(),
                  ),
                  const SizedBox(height: 24),
                  // Logout Button
                  GestureDetector(
                    onTap: () => _logout(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryAccent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.secondaryAccent.withOpacity(0.4),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            color: const Color.fromARGB(255, 255, 0, 0),
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(255, 251, 0, 0),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsBox() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryAccent.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailItem(
            'Email',
            SecureStorageService.getUserEmail(),
            Icons.email,
          ),
          _buildDivider(),
          _buildDetailItem(
            'Roll No',
            SecureStorageService.getUserRollNo(),
            Icons.badge,
          ),
          _buildDivider(),
          _buildDetailItem(
            'Team',
            SecureStorageService.getUserTeam(),
            Icons.group,
          ),
          if (_showFullDetails) ...[
            _buildDivider(),
            _buildDetailItem(
              'Gender',
              SecureStorageService.getUserGender(),
              Icons.wc,
            ),
            _buildDivider(),
            _buildDetailItem(
              'Event',
              SecureStorageService.getUserEvent(),
              Icons.event,
            ),
            _buildDivider(),
            _buildDetailItem(
              'Hall',
              SecureStorageService.getUserHall(),
              Icons.home,
            ),
            _buildDivider(),
            _buildDetailItem(
              'Last Meal',
              SecureStorageService.getUserMeal(),
              Icons.restaurant,
            ),
          ],
          _buildDivider(),
          // Show More/Less button at bottom edge
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryAccent.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _showFullDetails ? 'Show Less' : 'Show More',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.primaryAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  _showFullDetails ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.primaryAccent,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, Future<String?> future, IconData icon) {
    return FutureBuilder<String?>(
      future: future,
      builder: (context, snapshot) {
        final value = snapshot.data ?? 'N/A';
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.primaryAccent, size: 20),
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
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w600,
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

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: AppColors.primaryAccent.withOpacity(0.15),
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            // Full screen image
            Center(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.primaryBackground,
                    child: Center(
                      child: Text(
                        'Failed to load image',
                        style: TextStyle(color: AppColors.primaryText),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Close button
            Positioned(
              top: 20,
              right: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
