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

class _PostCarouselState extends ConsumerState<PostCarousel> with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _heartAnimationController;
  late AnimationController _heartFadeController;
  late Animation<double> _heartScaleAnimation;
  late Animation<double> _heartOpacityAnimation;
  bool _isHeartAnimating = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    // Heart scale animation — big pop-in, slight overshoot, settle
    _heartAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _heartScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.05), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 10),
    ]).animate(CurvedAnimation(
      parent: _heartAnimationController,
      curve: Curves.easeOut,
    ));

    // Fade out animation
    _heartFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _heartOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _heartFadeController, curve: Curves.easeIn),
    );
    
    _heartAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Hold the heart visible for a moment, then fade out
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            _heartFadeController.forward(from: 0);
          }
        });
      }
    });

    _heartFadeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() {
            _isHeartAnimating = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _heartAnimationController.dispose();
    _heartFadeController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    setState(() {
      _isHeartAnimating = true;
    });

    _heartFadeController.reset();
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
        AspectRatio(
          aspectRatio: 4 / 5, 
          child: GestureDetector(
            onDoubleTap: _handleDoubleTap,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.post.imageUrls.length,
                  itemBuilder: (context, index) {
                    return PinchZoomViewer(
                      child: CachedNetworkImage(
                        imageUrl: widget.post.imageUrls[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey.shade900,
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
                        ),
                      ),
                    );
                  },
                ),
                
                // Double Tap Big Red Heart Overlay
                if (_isHeartAnimating)
                  FadeTransition(
                    opacity: _heartOpacityAnimation,
                    child: ScaleTransition(
                      scale: _heartScaleAnimation,
                      child: const Icon(
                        Icons.favorite,
                        color: Color(0xFFED4956), // Instagram's exact red
                        size: 120,
                        shadows: [
                          Shadow(
                            color: Colors.black38,
                            blurRadius: 30,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Dot indicator
        if (isCarousel) ...[
          const SizedBox(height: 12),
          SmoothPageIndicator(
            controller: _pageController,
            count: widget.post.imageUrls.length,
            effect: ScrollingDotsEffect(
              dotHeight: 6,
              dotWidth: 6,
              activeDotColor: Colors.blueAccent,
              dotColor: Colors.grey.shade600,
              spacing: 4,
            ),
          ),
        ]
      ],
    );
  }
}
