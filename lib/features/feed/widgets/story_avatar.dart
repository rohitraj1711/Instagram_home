import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Gradient ring or placeholder container
              Container(
                width: radius * 2,
                height: radius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isAddStory ? null : AppColors.storyGradient,
                  border: isAddStory 
                    ? null 
                    : Border.all(color: Colors.transparent, width: 2), // Ring thickness handled implicitly below
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0), // Gap between gradient and image
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(2.0), // White bridge gap
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[300], // Skeleton color matching image
                      backgroundImage: imageUrl.isNotEmpty 
                        ? CachedNetworkImageProvider(imageUrl) as ImageProvider
                        : null,
                    ),
                  ),
                ),
              ),
              
              if (isAddStory)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          if (username != null) ...[
            const SizedBox(height: 4),
            Text(
              username!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ]
        ],
      ),
    );
  }
}
