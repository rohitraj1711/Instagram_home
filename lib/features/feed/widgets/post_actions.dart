import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import '../providers/feed_provider.dart';

class PostActions extends ConsumerStatefulWidget {
  final Post post;

  const PostActions({super.key, required this.post});

  @override
  ConsumerState<PostActions> createState() => _PostActionsState();
}

class _PostActionsState extends ConsumerState<PostActions> with SingleTickerProviderStateMixin {
  late AnimationController _likeController;
  late Animation<double> _likeScale;

  @override
  void initState() {
    super.initState();
    _likeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _likeScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _likeController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _likeController.dispose();
    super.dispose();
  }

  void _onLikeTap() {
    _likeController.forward(from: 0);
    ref.read(feedProvider.notifier).toggleLike(widget.post.id);
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          // Like action with scale animation
          GestureDetector(
            onTap: _onLikeTap,
            child: ScaleTransition(
              scale: _likeScale,
              child: Icon(
                widget.post.isLiked ? Icons.favorite : Icons.favorite_border,
                color: widget.post.isLiked ? const Color(0xFFED4956) : Theme.of(context).iconTheme.color,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Comment action
          GestureDetector(
            onTap: () => _showSnackBar(context, 'Comments coming soon'),
            child: Icon(
              Icons.mode_comment_outlined,
              size: 24,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          const SizedBox(width: 16),
          // Share / Send action
          GestureDetector(
            onTap: () => _showSnackBar(context, 'Share coming soon'),
            child: Transform.rotate(
              angle: -0.4, // Slight tilt like Instagram's send icon
              child: Icon(
                Icons.send_outlined,
                size: 22,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
          
          const Spacer(),
          
          // Bookmark / Save action
          GestureDetector(
            onTap: () {
              ref.read(feedProvider.notifier).toggleSave(widget.post.id);
            },
            child: Icon(
              widget.post.isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: Theme.of(context).iconTheme.color,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}
