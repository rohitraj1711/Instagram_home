import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post.dart';
import '../providers/feed_provider.dart';
import 'pinch_zoom_viewer.dart';

class PostCarousel extends ConsumerStatefulWidget {
  final Post post;

  const PostCarousel({super.key, required this.post});

  @override
  ConsumerState<PostCarousel> createState() => _PostCarouselState();
}

class _PostCarouselState extends ConsumerState<PostCarousel> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _heartAnimationController;
  late Animation<double> _heartScaleAnimation;
  bool _isHeartAnimating = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    // Heart animation setup
    _heartAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Quick pop
    );

    _heartScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 40),
    ]).animate(CurvedAnimation(
      parent: _heartAnimationController,
      curve: Curves.easeOutBack,
    ));
    
    _heartAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            _heartAnimationController.reverse();
          }
        });
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          _isHeartAnimating = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _heartAnimationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    setState(() {
      _isHeartAnimating = true;
    });

    _heartAnimationController.forward(from: 0);

    if (!widget.post.isLiked) {
      ref.read(feedProvider.notifier).toggleLike(widget.post.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.post.imageUrls.isEmpty) return const SizedBox.shrink();

    final isCarousel = widget.post.imageUrls.length > 1;

    return Column(
      children: [
        // The Instagram typical large vertical rectangle constraint
        AspectRatio(
          aspectRatio: 4 / 5, 
          child: GestureDetector(
            onDoubleTap: _handleDoubleTap,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(), // Smooth physics
                  itemCount: widget.post.imageUrls.length,
                  itemBuilder: (context, index) {
                    return PinchZoomViewer(
                      child: CachedNetworkImage(
                        imageUrl: widget.post.imageUrls[index],
                        fit: BoxFit.cover,
                        // Using a faded container as default CachedNetworkImage placeholder
                        placeholder: (context, url) => Container(
                          color: Colors.grey.shade200,
                        ),
                        // Explicit fallback error handling UI
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
                        ),
                      ),
                    );
                  },
                ),
                
                // Double Tap to Like Animated Heart Overlay
                if (_isHeartAnimating)
                  ScaleTransition(
                    scale: _heartScaleAnimation,
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Optional dot indicator
        if (isCarousel) ...[
          const SizedBox(height: 12),
          SmoothPageIndicator(
            controller: _pageController,
            count: widget.post.imageUrls.length,
            effect: ScrollingDotsEffect(
              dotHeight: 6,
              dotWidth: 6,
              activeDotColor: Colors.blueAccent,
              dotColor: Colors.grey.shade300,
              spacing: 4,
            ),
          ),
        ]
      ],
    );
  }
}
