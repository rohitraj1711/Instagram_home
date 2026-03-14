import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Generate full-bleed Instagram icon', (WidgetTester tester) async {
    final key = GlobalKey();
    
    // We want a perfect 1024x1024 square with NO rounded corners on the background
    // Native OS handles rounding the corners for the App Icon
    await tester.pumpWidget(
      RepaintBoundary(
        key: key,
        child: Container(
          width: 1024,
          height: 1024,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xFFFEDA75), // Yellow
                Color(0xFFF58529), // Orange
                Color(0xFFDD2A7B), // Pink
                Color(0xFF8134AF), // Purple
                Color(0xFF515BD4), // Blue
              ],
              stops: [0.0, 0.25, 0.5, 0.75, 1.0],
            ),
          ),
          child: CustomPaint(
            painter: _IconPainter(),
          ),
        ),
      ),
    );
    
    RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 1.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    
    final file = File('assets/icon.png');
    // Save over the existing icon asset
    await file.writeAsBytes(byteData!.buffer.asUint8List());
  });
}

class _IconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // --- Camera body (rounded square outline) ---
    final double bodyStroke = w * 0.08; 
    final double bodySize = w * 0.65; // Bigger inside the 1024x1024 space
    final double bodyCorner = w * 0.20;
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

    // --- Center lens circle ---
    final double lensRadius = w * 0.16;
    final double lensStroke = w * 0.08;
    final center = Offset(w / 2, h / 2);

    final lensPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = lensStroke;

    canvas.drawCircle(center, lensRadius, lensPaint);

    // --- Flash dot (top right) ---
    final double dotRadius = w * 0.045;
    final double dotX = w * 0.70;
    final double dotY = h * 0.30;

    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(dotX, dotY), dotRadius, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
