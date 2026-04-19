import 'package:flutter/material.dart';
import 'package:greenlens/main.dart';
import 'dart:ui';

const double opacity = 0.48;

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Both ellipse layers blurred together as one
          ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 3,          // 👈 reduced from 60
              sigmaY: 3,
              tileMode: TileMode.decal,
            ),
            child: Stack(
              fit: StackFit.expand, // 👈 forces Stack to fill full screen so Positioned works
              children: [
                const _EllipseBackground(),
                const _EllipseBackgroundBottom(),
              ],
            ),
          ),

          // Content is NOT inside ImageFiltered, so it stays sharp
          child,
        ],
      ),
    );
  }
}

// ─── TOP ──────────────────────────────────────────────────────────────────────

class _EllipseBackground extends StatelessWidget {
  const _EllipseBackground();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.height * 0.45,
      child: CustomPaint(
        painter: _EllipsePainterTop(),
      ),
    );
  }
}

class _EllipsePainterTop extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Ellipse 1
    canvas.drawOval(
      Rect.fromCenter(
        center: const Offset(400, -175),
        width: 1383.33,
        height: 857.83,
      ),
      Paint()
        ..color = PrimaryColor.withOpacity(opacity)
        ..style = PaintingStyle.fill
        ..blendMode = BlendMode.overlay
    );

    // Ellipse 2
    canvas.drawOval(
      Rect.fromCenter(
        center: const Offset(600, -150),
        width: 1383.33,
        height: 857.83,
      ),
      Paint()
        ..color = PrimaryColor.withOpacity(opacity)
        ..style = PaintingStyle.fill
        ..blendMode = BlendMode.overlay
    );

    // Ellipse 3
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, -110),
        width: 2084,
        height: 857.83,
      ),
      Paint()
        ..color = PrimaryColor.withOpacity(opacity)
        ..style = PaintingStyle.fill
        ..blendMode = BlendMode.overlay
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── BOTTOM ───────────────────────────────────────────────────────────────────

class _EllipseBackgroundBottom extends StatelessWidget {
  const _EllipseBackgroundBottom();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Positioned(                        // 👈 anchor to bottom of Stack
      bottom: 0,
      left: 0,
      right: 0,
      child: SizedBox(
        width: size.width,
        height: size.height * 0.45,
        child: CustomPaint(
          painter: _EllipsePainterBottom(),
        ),
      ),
    );
  }
}

class _EllipsePainterBottom extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Ellipse 4
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width*0.5, size.height + 260),  // 👈 pushed below, peeks up
        width: 1655.15,
        height: 933.58,
      ),
      Paint()
        ..color = PrimaryColor.withOpacity(opacity)
        ..style = PaintingStyle.fill
        ..blendMode = BlendMode.overlay
    );

    // Ellipse 5 — Left
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(300, size.height + 275),
        width: 1403.93,
        height: 798.18,
      ),
      Paint()
        ..color = PrimaryColor.withOpacity(opacity)
        ..style = PaintingStyle.fill
        ..blendMode = BlendMode.overlay
    );

    // Ellipse 6 — right
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(600, size.height + 250),
        width: 1692.56,
        height: 798.18,
      ),
      Paint()
        ..color = PrimaryColor.withOpacity(opacity)
        ..style = PaintingStyle.fill
        ..blendMode = BlendMode.overlay
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}