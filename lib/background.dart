import 'package:flutter/material.dart';

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height + 40,
      size.width,
      size.height - 100,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(oldClipper) => false;
}

// WaveClipper2
class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height - 20,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(oldClipper) => false;
}

// WaveClipper3
class WaveClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // 👇 start from top RIGHT
    path.moveTo(size.width, 0);

    // 👇 go down on the right side
    path.lineTo(size.width, size.height - 100);

    // 👇 curve toward the LEFT
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height + 40,
      0,
      size.height - 115,
    );

    // 👇 go back to top left
    path.lineTo(0, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(oldClipper) => false;
}

class BackgroundCurves extends StatelessWidget {
  const BackgroundCurves({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Wave 1 (back)
          ClipPath(
            clipper: WaveClipper1(),
            child: Container(
              height: 110,
              color: Color(0xFF2E2B8F).withOpacity(0.6),
            ),
          ),

          // 🔹 Wave 2 (middle)
          ClipPath(
            clipper: WaveClipper2(),
            child: Container(
              height: 140,
              color: Color(0xFF5B57D1).withOpacity(0.4),
            ),
          ),

          // 🔹 Wave 3 (front)
          ClipPath(
            clipper: WaveClipper3(),
            child: Container(
              height: 120,
              color: Color(0xFF3F3CA6).withOpacity(0.7),
            ),
          ),

          // 🔹 Your content
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 120),
              Text(
                "GreenLens",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
