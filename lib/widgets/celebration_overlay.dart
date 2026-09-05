import 'dart:math';
import 'package:flutter/material.dart';

class CelebrationOverlay extends StatefulWidget {
  final VoidCallback? onFinished;
  final Duration duration;

  const CelebrationOverlay({
    super.key,
    this.onFinished,
    this.duration = const Duration(milliseconds: 900),
  });

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _particles = List.generate(70, (index) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = _random.nextDouble() * 450 + 200;
      final colorList = [
        Colors.redAccent,
        Colors.pinkAccent,
        Colors.orangeAccent,
        Colors.amber,
        Colors.greenAccent,
        Colors.cyanAccent,
        Colors.purpleAccent,
        Colors.deepPurpleAccent,
      ];
      final color = colorList[_random.nextInt(colorList.length)];

      return _Particle(
        vx: cos(angle) * speed,
        vy: sin(angle) * speed,
        size: _random.nextDouble() * 12 + 6,
        color: color,
        rotationSpeed: _random.nextDouble() * 12 - 6,
        isStar: _random.nextBool(),
      );
    });

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onFinished?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: Size.infinite,
            painter: _CelebrationPainter(
              particles: _particles,
              progress: _controller.value,
            ),
          );
        },
      ),
    );
  }
}

class _Particle {
  final double vx;
  final double vy;
  final double size;
  final Color color;
  final double rotationSpeed;
  final bool isStar;

  _Particle({
    required this.vx,
    required this.vy,
    required this.size,
    required this.color,
    required this.rotationSpeed,
    required this.isStar,
  });
}

class _CelebrationPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _CelebrationPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 3);
    final alphaInt = ((1.0 - progress).clamp(0.0, 1.0) * 255).toInt();

    for (final p in particles) {
      final dx = center.dx + p.vx * progress;
      final dy = center.dy + p.vy * progress + 250 * progress * progress; // Gravity
      final paint = Paint()
        ..color = p.color.withAlpha(alphaInt)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(progress * p.rotationSpeed);

      if (p.isStar) {
        final path = Path();
        for (int i = 0; i < 5; i++) {
          final a1 = i * 4 * pi / 5;
          final x1 = cos(a1) * p.size;
          final y1 = sin(a1) * p.size;
          if (i == 0) {
            path.moveTo(x1, y1);
          } else {
            path.lineTo(x1, y1);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.7,
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _CelebrationPainter oldDelegate) => true;
}
