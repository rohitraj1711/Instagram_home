import 'package:flutter/material.dart';
import '../models/post.dart';
import 'post_header.dart';
import 'post_carousel.dart';
import 'post_actions.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Header (Avatar, Username, More Button)
        PostHeader(post: post),
        
        // 2. Main Photo / Carousel (With Pinch-to-zoom)
        PostCarousel(post: post),
        
        // 3. Interactions (Like, Comment, Share, Save)
        PostActions(post: post),
        
        // 4. Caption and Likes text formatting
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            '${post.likesCount} Likes',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        
        if (post.caption.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 13),
                children: [
                  TextSpan(
                    text: '${post.username} ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: post.caption),
                ],
              ),
            ),
          ),
          
        const SizedBox(height: 16),
      ],
    );
  }
}
