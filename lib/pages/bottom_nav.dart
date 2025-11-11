import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../pages/qr_dialog.dart';

class BottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _dropletController;
  late int _previousIndex;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.currentIndex;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _dropletController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _updateDropletAnimation();
  }

  void _updateDropletAnimation() {
    _dropletController.forward(from: 0.0);
    _previousIndex = widget.currentIndex;
  }

  @override
  void didUpdateWidget(BottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _updateDropletAnimation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final positions = [-110.0, -55.0, 0.0, 55.0, 110.0];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10), // ⬇️ lift above gesture area
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          /// 💧 Droplet animation
          Positioned(
            top: 0,
            child: AnimatedBuilder(
              animation: _dropletController,
              builder: (context, _) {
                final begin = positions[_previousIndex];
                final end = positions[widget.currentIndex];

                final currentX =
                    Tween<double>(begin: begin, end: end).evaluate(
                  CurvedAnimation(
                    parent: _dropletController,
                    curve: Curves.easeInOutCubic,
                  ),
                );

                final dropY = TweenSequence<double>([
                  TweenSequenceItem(
                    tween: Tween(begin: -80.0, end: 10.0)
                        .chain(CurveTween(curve: Curves.easeOutCubic)),
                    weight: 70,
                  ),
                  TweenSequenceItem(
                    tween: Tween(begin: 10.0, end: 0.0)
                        .chain(CurveTween(curve: Curves.easeOutBack)),
                    weight: 30,
                  ),
                ]).evaluate(_dropletController);

                if (widget.currentIndex == 2) {
                  // Skip QR droplet
                  return const SizedBox.shrink();
                }

                return Transform.translate(
                  offset: Offset(currentX, dropY),
                  child: CustomPaint(
                    painter: DropletPainter(
                      color: AppColors.primaryAccent,
                      highlight: const Color(0xFF00C6FF), // Blue-teal glow
                      progress: _dropletController.value,
                    ),
                    size: const Size(42, 48),
                  ),
                );
              },
            ),
          ),

          /// 🌌 Floating rounded glass bar
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryAccent.withOpacity(0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: SizedBox(
                height: 65,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.08),
                          Colors.white.withOpacity(0.03),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.12),
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: BottomNavigationBar(
                      currentIndex:
                          widget.currentIndex > 4 ? 0 : widget.currentIndex,
                      onTap: (index) {
                        if (index == 2) {
                          showDialog(
                            context: context,
                            builder: (context) => const QrDialog(),
                          );
                          return;
                        }
                        _animationController.forward().then((_) {
                          _animationController.reverse();
                        });
                        widget.onTap(index);
                      },
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      selectedItemColor: AppColors.primaryAccent,
                      unselectedItemColor: Colors.grey.shade500,
                      type: BottomNavigationBarType.fixed,
                      iconSize: 24,
                      selectedFontSize: 11,
                      unselectedFontSize: 11,
                      showSelectedLabels: true,
                      showUnselectedLabels: true,
                      items: [
                        _navItem(Icons.home_rounded, "Home", 0),
                        _navItem(Icons.event_rounded, "Events", 1),

                        // Invisible QR slot (kept for indexing)
                        const BottomNavigationBarItem(
                          icon: SizedBox(width: 30),
                          label: '',
                        ),

                        _navItem(Icons.menu_book_rounded, "Rules", 3),
                        _navItem(Icons.person_rounded, "Profile", 4),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _navItem(IconData icon, String label, int index) {
    final isSelected = widget.currentIndex == index;
    return BottomNavigationBarItem(
      icon: AnimatedScale(
        scale: isSelected ? 1.25 : 1.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primaryAccent.withOpacity(0.5),
                      blurRadius: 16,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: const Color(0xFF00C6FF).withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Icon(icon),
        ),
      ),
      label: label,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _dropletController.dispose();
    super.dispose();
  }
}

/// 💧 Droplet Painter (cool blue glow)
class DropletPainter extends CustomPainter {
  final Color color;
  final Color highlight;
  final double progress;

  DropletPainter({
    required this.color,
    required this.highlight,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.35;

    final paint = Paint()
      ..shader = LinearGradient(
        colors: [color, highlight],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: 20))
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = highlight.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawCircle(Offset(cx, cy), 18 + (progress * 4), glowPaint);

    final radius = 10 + (progress * 6);
    final path = Path()
      ..moveTo(cx, cy - radius)
      ..quadraticBezierTo(cx - radius, cy, cx, cy + radius * 1.6)
      ..quadraticBezierTo(cx + radius, cy, cx, cy - radius)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(DropletPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.highlight != highlight;
}
