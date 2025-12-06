import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'rulebook_page.dart';

class TopNav extends StatelessWidget {
  final VoidCallback onProfileTap;

  const TopNav({super.key, required this.onProfileTap});

  void _openRulebook(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RulebookScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // slightly smaller radius so the rounded bottom doesn't consume too much vertical space
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(18),
        bottomRight: Radius.circular(18),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          // keep container lightweight vertically
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
                color: AppColors.secondaryAccent.withOpacity(0.22),
                width: 1.0,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondaryAccent.withOpacity(0.08),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left block: logo + text
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // smaller logo so overall header is shorter
                    Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF1E73BE),
                            Color(0xFFF7941D),
                            Color(0xFF4CAF50),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E73BE).withOpacity(0.32),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/logo.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Make the column take the minimal vertical space
                    Column(
                      mainAxisSize: MainAxisSize.min,
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

                        // Tight line-height and MainAxisSize.min prevents clipping/extra space
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFF1E73BE), Color(0xFFF7941D)],
                          ).createShader(bounds),
                          child: const Text(
                            'Cult Meet 8.0',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.25,
                              height: 1.0, // keep descender visible but compact
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Right block: icons
                Row(
                  children: [
                    _iconButton(
                      icon: Icons.book_rounded,
                      color: AppColors.primaryText,
                      glow: AppColors.primaryText.withOpacity(0.22),
                      onTap: () => _openRulebook(context),
                    ),
                    const SizedBox(width: 8),
                    _iconButton(
                      icon: Icons.account_circle_rounded,
                      color: AppColors.primaryAccent,
                      glow: AppColors.primaryAccent.withOpacity(0.22),
                      onTap: onProfileTap,
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
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: color.withOpacity(0.08),
          boxShadow: [BoxShadow(color: glow, blurRadius: 12, spreadRadius: 1)],
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: color, size: 26),
      ),
    );
  }
}
