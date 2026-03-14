import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import '../providers/feed_provider.dart';
import '../../../core/theme/app_colors.dart';

class PostActions extends ConsumerWidget {
  final Post post;

  const PostActions({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 12px padding block as explicitly requested
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          // 24px Like action
          GestureDetector(
            onTap: () {
              ref.read(feedProvider.notifier).toggleLike(post.id);
            },
            child: Icon(
              post.isLiked ? Icons.favorite : Icons.favorite_border,
              color: post.isLiked ? AppColors.likeRed : Theme.of(context).iconTheme.color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          // 24px Comment action
          const Icon(
            Icons.mode_comment_outlined,
            size: 24,
          ),
          const SizedBox(width: 16),
          // 24px Send action
          const Icon(
            Icons.send_outlined,
            size: 24,
          ),
          
          const Spacer(),
          
          // 24px Save action 
          GestureDetector(
            onTap: () {
              ref.read(feedProvider.notifier).toggleSave(post.id);
            },
            child: Icon(
              post.isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: Theme.of(context).iconTheme.color,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
