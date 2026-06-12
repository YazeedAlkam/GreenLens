import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:greenlens/main.dart';
import 'dart:ui';

/// Opacity applied to each decorative ellipse shape on auth screens.
const double opacity = 0.48;

/// Scaffold wrapper used on all authentication screens.
///
/// Renders a blurred decorative ellipse background (top and bottom),
/// the GreenLens logo centered near the top, and the provided [child] content.
class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Blurred ellipse background
          ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 3,
              sigmaY: 3,
              tileMode: TileMode.decal,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                const _EllipseBackground(),
                const _EllipseBackgroundBottom(),
              ],
            ),
          ),

          Positioned(
            top: 48,
            left: 0,
            right: 0,
            child: Center(
              child: SvgPicture.asset(
                'assets/images/GreenLensLogo.svg',
                height: 170,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

// ─── TOP ──────────────────────────────────────────────────────────────────────

/// Sizes and positions the top [_EllipsePainterTop] CustomPainter.
class _EllipseBackground extends StatelessWidget {
  const _EllipseBackground();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.height * 0.45,
      child: CustomPaint(painter: _EllipsePainterTop()),
    );
  }
}

/// Draws three overlapping semi-transparent blue ellipses at the top of auth screens.
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
        ..color = primaryColor.withValues(alpha: opacity)
        ..style = PaintingStyle.fill
        ..blendMode = BlendMode.overlay,
    );

    // Ellipse 2
    canvas.drawOval(
      Rect.fromCenter(
        center: const Offset(600, -150),
        width: 1383.33,
        height: 857.83,
      ),
      Paint()
        ..color = primaryColor.withValues(alpha: opacity)
        ..style = PaintingStyle.fill
        ..blendMode = BlendMode.overlay,
    );

    // Ellipse 3
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, -110),
        width: 2084,
        height: 857.83,
      ),
      Paint()
        ..color = primaryColor.withValues(alpha: opacity)
        ..style = PaintingStyle.fill
        ..blendMode = BlendMode.overlay,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── BOTTOM ───────────────────────────────────────────────────────────────────

/// Positions the bottom [_EllipsePainterBottom] CustomPainter at the screen's lower edge.
class _EllipseBackgroundBottom extends StatelessWidget {
  const _EllipseBackgroundBottom();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SizedBox(
        width: size.width,
        height: size.height * 0.45,
        child: CustomPaint(painter: _EllipsePainterBottom()),
      ),
    );
  }
}

/// Draws three overlapping semi-transparent blue ellipses rising from the bottom of auth screens.
class _EllipsePainterBottom extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Ellipse 4
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height + 260),
        width: 1655.15,
        height: 933.58,
      ),
      Paint()
        ..color = primaryColor.withValues(alpha: opacity)
        ..style = PaintingStyle.fill
        ..blendMode = BlendMode.overlay,
    );

    // Ellipse 5 — Left
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(300, size.height + 275),
        width: 1403.93,
        height: 798.18,
      ),
      Paint()
        ..color = primaryColor.withValues(alpha: opacity)
        ..style = PaintingStyle.fill
        ..blendMode = BlendMode.overlay,
    );

    // Ellipse 6 — right
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(600, size.height + 250),
        width: 1692.56,
        height: 798.18,
      ),
      Paint()
        ..color = primaryColor.withValues(alpha: opacity)
        ..style = PaintingStyle.fill
        ..blendMode = BlendMode.overlay,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
