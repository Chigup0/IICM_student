import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../secure_storage.dart';
import 'login_page.dart';

class TopNav extends StatelessWidget {
  final VoidCallback onProfileTap;

  const TopNav({super.key, required this.onProfileTap});

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
            child: Text('Cancel',
                style: TextStyle(color: AppColors.secondaryText)),
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
            child: Text('Logout',
                style: TextStyle(color: AppColors.secondaryAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(26),
        bottomRight: Radius.circular(26),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryBackground.withOpacity(0.95),
                const Color(0xFF1A2337).withOpacity(0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border(
              bottom: BorderSide(
                color: AppColors.secondaryAccent.withOpacity(0.25),
                width: 1.2,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondaryAccent.withOpacity(0.12),
                blurRadius: 30,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: SafeArea(
            bottom: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// 🔸 Left: Logo + Titles
                Row(
                  children: [
                    // Peacock-inspired glowing logo ring
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF1E73BE), // blue from peacock
                            Color(0xFFF7941D), // orange from sun
                            Color(0xFF4CAF50), // green vine hint
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E73BE).withOpacity(0.4),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ClipOval(
                          child: Image.asset('assets/logo.jpg', fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Inter IIT',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondaryText,
                            letterSpacing: 0.5,
                          ),
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFF1E73BE), // blue
                              Color(0xFFF7941D), // orange
                            ],
                          ).createShader(bounds),
                          child: const Text(
                            'Cult Meet 8.0',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                /// 🔹 Right: Profile + Logout
                Row(
                  children: [
                    _iconButton(
                      icon: Icons.account_circle_rounded,
                      color: AppColors.primaryAccent,
                      glow: AppColors.primaryAccent.withOpacity(0.3),
                      onTap: onProfileTap,
                    ),
                    const SizedBox(width: 8),
                    _iconButton(
                      icon: Icons.logout_rounded,
                      color: AppColors.secondaryAccent,
                      glow: AppColors.secondaryAccent.withOpacity(0.3),
                      onTap: () => _logout(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconButton({
    required IconData icon,
    required Color color,
    required Color glow,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: color.withOpacity(0.1),
          boxShadow: [
            BoxShadow(
              color: glow,
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
