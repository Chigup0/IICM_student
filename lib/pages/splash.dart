import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;

  const SplashScreen({super.key, required this.nextScreen});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _burstController;
  late AnimationController _glowController;
  late List<Particle> particles;
  bool _showLogo = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _generateParticles();
    _startAnimation();
  }

  void _initializeAnimations() {
    // Stage 1: Particles form the "8" (0-1.5 seconds)
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Stage 2: Burst explosion (1.5-2.2 seconds)
    _burstController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    // Stage 3: Glow and fade (2.2-3 seconds)
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  void _generateParticles() {
    particles = [];
    const int particleCount = 150;
    const double canvasWidth = 400;
    const double canvasHeight = 400;
    const double centerX = 200;
    const double centerY = 200;

    final random = math.Random();

    // Generate particles in figure-8 pattern
    for (int i = 0; i < particleCount; i++) {
      final t = (i / particleCount) * 2 * math.pi;

      // Lissajous curve for figure-8 shape
      final x = centerX + 80 * math.sin(t);
      final y = centerY + 60 * math.sin(t) * math.cos(t);

      particles.add(
        Particle(
          startX: random.nextDouble() * canvasWidth,
          startY: random.nextDouble() * canvasHeight,
          endX: x,
          endY: y,
          color: _getVibranceColor(i % 5),
          delay: (i / particleCount) * 300,
        ),
      );
    }
  }

  Color _getVibranceColor(int index) {
    const colors = [
      Color(0xFFFF6B35), // Energetic Orange
      Color(0xFF004E89), // Deep Teal
      Color(0xFFFFBF69), // Golden Yellow
      Color(0xFFF72585), // Vibrant Pink
      Color(0xFF00D9FF), // Cyan
    ];
    return colors[index];
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _particleController.forward().then((_) {
        _burstController.forward().then((_) {
          _glowController.forward().then((_) {
            _showLogoAndTransition();
          });
        });
      });
    });
  }

  void _showLogoAndTransition() {
    setState(() => _showLogo = true);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background: Deep Purple → Orange
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A0033), // Deep Purple
                  Color(0xFF330011), // Dark Red
                  Color(0xFF663300), // Dark Orange
                ],
              ),
            ),
          ),

          // Particle Canvas
          Center(
            child: SizedBox(
              width: 400,
              height: 400,
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _particleController,
                  _burstController,
                  _glowController,
                ]),
                builder: (context, _) {
                  return CustomPaint(
                    painter: ParticlePainter(
                      particles: particles,
                      particleProgress: _particleController.value,
                      burstProgress: _burstController.value,
                      glowProgress: _glowController.value,
                    ),
                  );
                },
              ),
            ),
          ),

          // Logo Overlay with Glow Fade-In
          if (_showLogo)
            Center(
              child: AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 800),
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B35).withOpacity(0.6),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Image.asset('assets/logo.jpg', fit: BoxFit.contain),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _particleController.dispose();
    _burstController.dispose();
    _glowController.dispose();
    super.dispose();
  }
}

// Particle Model
class Particle {
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  final Color color;
  final double delay;

  Particle({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    required this.color,
    required this.delay,
  });
}

// Custom Painter for Particles
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double particleProgress;
  final double burstProgress;
  final double glowProgress;

  ParticlePainter({
    required this.particles,
    required this.particleProgress,
    required this.burstProgress,
    required this.glowProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    for (final particle in particles) {
      // Stage 1: Particles converge to form "8" (0-1500ms)
      double progress = particleProgress;
      if (particle.delay > 0) {
        progress = math.max(
          0,
          (particleProgress * 1500 - particle.delay) / 1500,
        );
      }

      if (progress < 1.0) {
        // Easing: ease-out cubic for smooth convergence
        final eased = 1 - math.pow(1 - progress, 3);
        final x = particle.startX + (particle.endX - particle.startX) * eased;
        final y = particle.startY + (particle.endY - particle.startY) * eased;
        final radius = 4 * (1 - progress * 0.5);

        _drawParticle(canvas, x, y, radius, particle.color, 1.0);
      } else {
        // Stage 2: Burst outward (1500-2200ms)
        if (burstProgress > 0) {
          final angle = math.atan2(
            particle.endY - centerY,
            particle.endX - centerX,
          );
          final distance = 150 * burstProgress;
          final burstX = particle.endX + math.cos(angle) * distance;
          final burstY = particle.endY + math.sin(angle) * distance;
          final burstRadius = 4 * (1 - burstProgress);
          final burstOpacity = 1.0 - burstProgress;

          _drawParticle(
            canvas,
            burstX,
            burstY,
            burstRadius,
            particle.color,
            burstOpacity,
          );
        } else {
          // Stage 3: Static "8" with glow
          final radius = 4 * (1 - glowProgress * 0.3);
          final glowRadius = 8 + glowProgress * 5;
          final glowOpacity = (1 - glowProgress) * 0.3;

          // Glow effect
          final glowPaint = Paint()
            ..color = particle.color.withOpacity(glowOpacity)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowRadius);

          canvas.drawCircle(
            Offset(particle.endX, particle.endY),
            glowRadius,
            glowPaint,
          );

          // Core particle
          _drawParticle(
            canvas,
            particle.endX,
            particle.endY,
            radius,
            particle.color,
            1.0,
          );
        }
      }
    }
  }

  void _drawParticle(
    Canvas canvas,
    double x,
    double y,
    double radius,
    Color color,
    double opacity,
  ) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..isAntiAlias = true;

    canvas.drawCircle(Offset(x, y), radius, paint);
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
