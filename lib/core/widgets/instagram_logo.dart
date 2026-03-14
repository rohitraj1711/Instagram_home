import 'package:flutter/material.dart';

/// Draws the Instagram camera icon with gradient background
class InstagramLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // --- 1. Background rounded square with Instagram gradient ---
    final bgRect = Rect.fromLTWH(0, 0, w, h);
    final double cornerRadius = w * 0.22;

    final bgGradient = LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: const [
        Color(0xFFFEDA75), // Yellow
        Color(0xFFF58529), // Orange
        Color(0xFFDD2A7B), // Pink
        Color(0xFF8134AF), // Purple
        Color(0xFF515BD4), // Blue
      ],
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
    );

    final bgPaint = Paint()
      ..shader = bgGradient.createShader(bgRect);

    final bgRRect = RRect.fromRectAndRadius(bgRect, Radius.circular(cornerRadius));
    canvas.drawRRect(bgRRect, bgPaint);

    // --- 2. Camera body (rounded square outline) ---
    final double bodyStroke = w * 0.065;
    final double bodySize = w * 0.52;
    final double bodyCorner = w * 0.15;
    final double bodyLeft = (w - bodySize) / 2;
    final double bodyTop = (h - bodySize) / 2;

    final bodyRect = Rect.fromLTWH(bodyLeft, bodyTop, bodySize, bodySize);
    final bodyRRect = RRect.fromRectAndRadius(bodyRect, Radius.circular(bodyCorner));

    final bodyPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = bodyStroke
      ..strokeCap = StrokeCap.round;

    canvas.drawRRect(bodyRRect, bodyPaint);

    // --- 3. Center lens circle ---
    final double lensRadius = w * 0.135;
    final double lensStroke = w * 0.065;
    final center = Offset(w / 2, h / 2);

    final lensPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = lensStroke;

    canvas.drawCircle(center, lensRadius, lensPaint);

    // --- 4. Flash dot (top right) ---
    final double dotRadius = w * 0.04;
    final double dotX = w * 0.655;
    final double dotY = h * 0.345;

    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(dotX, dotY), dotRadius, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Widget wrapper for the Instagram logo
class InstagramLogo extends StatelessWidget {
  final double size;

  const InstagramLogo({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: InstagramLogoPainter(),
      size: Size(size, size),
    );
  }
}
