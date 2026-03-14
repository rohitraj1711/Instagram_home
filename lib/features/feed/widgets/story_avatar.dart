import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StoryAvatar extends StatelessWidget {
  final String imageUrl;
  final String? username;
  final bool isAddStory;
  final double radius;

  const StoryAvatar({
    super.key,
    required this.imageUrl,
    this.username,
    this.isAddStory = false,
    this.radius = 33.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.black : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if (!isAddStory)
                // Gradient ring painted with CustomPaint for crisp circles
                CustomPaint(
                  painter: _StoryRingPainter(
                    gradientColors: const [
                      Color(0xFFFEDA75), // Yellow
                      Color(0xFFFA7E1E), // Orange
                      Color(0xFFD62976), // Pink
                      Color(0xFF962FBF), // Purple
                      Color(0xFF4F5BD5), // Blue
                    ],
                    strokeWidth: 2.5,
                    gap: 3.0,
                  ),
                  child: SizedBox(
                    width: radius * 2,
                    height: radius * 2,
                  ),
                ),
              if (isAddStory)
                SizedBox(
                  width: radius * 2,
                  height: radius * 2,
                ),
              // Photo avatar
              CircleAvatar(
                radius: radius - 5,
                backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                backgroundImage: imageUrl.isNotEmpty
                    ? CachedNetworkImageProvider(imageUrl) as ImageProvider
                    : null,
                child: imageUrl.isEmpty
                    ? Icon(Icons.person, color: Colors.grey.shade500, size: radius - 10)
                    : null,
              ),
              // Blue "+" for Add Story
              if (isAddStory)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: bgColor, width: 2.5),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Icon(
                        Icons.add,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (username != null) ...[
            const SizedBox(height: 5),
            SizedBox(
              width: radius * 2,
              child: Text(
                username!,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ]
        ],
      ),
    );
  }
}

/// Custom painter that draws a clean gradient ring around story avatars
class _StoryRingPainter extends CustomPainter {
  final List<Color> gradientColors;
  final double strokeWidth;
  final double gap;

  _StoryRingPainter({
    required this.gradientColors,
    this.strokeWidth = 2.5,
    this.gap = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - (strokeWidth / 2);

    final gradient = SweepGradient(
      colors: gradientColors,
      startAngle: 0.0,
      endAngle: 3.14159 * 2,
    );

    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _StoryRingPainter oldDelegate) => false;
}
