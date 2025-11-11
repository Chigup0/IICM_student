import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../pages/bottom_nav.dart';
import '../pages/top_nav.dart';
import '../pages/qr_dialog.dart';
import 'events_page.dart';
import 'profile_page.dart';
import 'rulebook_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const EventsScreen(),
    const SizedBox.shrink(), // QR
    const RulebookScreen(),
    const ProfileScreen(),
  ];

  void _goToProfile() => setState(() => _currentIndex = 4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      extendBody: true,
      resizeToAvoidBottomInset: false,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: TopNav(onProfileTap: _goToProfile),
      ),

      body: GestureDetector(
        behavior: HitTestBehavior.opaque,

        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0 && _currentIndex > 0) {
            setState(() => _currentIndex--);
          } else if (details.primaryVelocity! < 0 && _currentIndex < 4) {
            setState(() => _currentIndex++);
          }
        },
        child: _pages[_currentIndex],
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: AppColors.primaryAccent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.buttonText.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const QrDialog(),
                );
              },
              customBorder: const CircleBorder(),
              child: Icon(
                Icons.qr_code_2_rounded,
                color: AppColors.buttonText,
                size: 34,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BottomNav(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                )),
            const SizedBox(height: 8),
            Text('Ready to explore?',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.secondaryText,
                )),
          ],
        ),
      ),
    );
  }
}
