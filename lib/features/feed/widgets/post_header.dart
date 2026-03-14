import 'package:flutter/material.dart';
import '../models/post.dart';
import 'story_avatar.dart';

class PostHeader extends StatelessWidget {
  final Post post;

  const PostHeader({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Precise 12px horizontal padding 
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          // Precise 32px avatar size -> radius = 16
          StoryAvatar(
            imageUrl: post.userProfileImage, 
            radius: 16.0,
          ), 
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              post.username,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: -0.1,
              ),
            ),
          ),
          // 24px More Vert icon
          const Icon(Icons.more_horiz, size: 24),
        ],
      ),
    );
  }
}
