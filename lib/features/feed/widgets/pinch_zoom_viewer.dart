import 'package:flutter/material.dart';

class PinchZoomViewer extends StatefulWidget {
  final Widget child;

  const PinchZoomViewer({super.key, required this.child});

  @override
  State<PinchZoomViewer> createState() => _PinchZoomViewerState();
}

class _PinchZoomViewerState extends State<PinchZoomViewer> with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;
  OverlayEntry? _overlayEntry;
  bool _isZooming = false;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        _transformationController.value = _animation!.value;
      });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScaleStart(ScaleStartDetails details) {
    if (_isZooming) return;
    _isZooming = true;

    // Create overlay
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned.fill(
          child: Container(
            color: Colors.black.withAlpha(204), // Darken background slightly (0.8 opacity)
            alignment: Alignment.center,
            child: InteractiveViewer(
              transformationController: _transformationController,
              panEnabled: true,
              scaleEnabled: true,
              clipBehavior: Clip.none,
              minScale: 1.0,
              maxScale: 4.0,
              onInteractionEnd: (details) {
                _resetZoom();
              },
              child: widget.child,
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (details.scale > 1.0 && !_isZooming) {
       _onScaleStart(ScaleStartDetails());
    }
  }

  void _resetZoom() {
    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(CurveTween(curve: Curves.easeOut).animate(_animationController));

    _animationController.forward(from: 0).whenComplete(() {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isZooming = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (_) {
        // Intercept starting of scale (pinch)
      },
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: (_) => _resetZoom(),
      child: _isZooming ? Opacity(opacity: 0.0, child: widget.child) : widget.child,
    );
  }
}
