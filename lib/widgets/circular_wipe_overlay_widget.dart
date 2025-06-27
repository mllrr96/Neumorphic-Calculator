import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircularWipeOverlayWidget extends StatefulWidget {
  final Widget child;
  final bool triggerWipe;
  final VoidCallback? onWipeComplete;
  final Color? overlayColor;
  final Duration duration;

  const CircularWipeOverlayWidget({
    super.key,
    required this.child,
    required this.triggerWipe,
    required this.onWipeComplete,
    this.overlayColor,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<CircularWipeOverlayWidget> createState() => _CircularWipeOverlayWidgetState();
}

class _CircularWipeOverlayWidgetState extends State<CircularWipeOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    if (widget.triggerWipe) {
      _startWipe();
    }
  }

  @override
  void didUpdateWidget(covariant CircularWipeOverlayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.triggerWipe && !oldWidget.triggerWipe) {
      _startWipe();
    }
  }

  void _startWipe() {
    _controller.forward().then((_) {
      widget.onWipeComplete?.call();
      _controller.reset();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final overlayColor =
        widget.overlayColor ?? Theme.of(context).colorScheme.primary;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxSize = math.sqrt(constraints.maxWidth * constraints.maxWidth +
            constraints.maxHeight * constraints.maxHeight);
        return Stack(
          children: [
            widget.child,
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final radius = _animation.value * maxSize;
                return ClipPath(
                  clipper: CircleRevealClipper(
                    centerOffset: const Offset(0, 1),
                    radius: radius,
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: overlayColor,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class CircleRevealClipper extends CustomClipper<Path> {
  final Offset centerOffset;
  final double radius;
  final Size size;

  CircleRevealClipper({
    required this.centerOffset,
    required this.radius,
    required this.size,
  });

  @override
  Path getClip(Size _) {
    final path = Path();

    final center = Offset(
      centerOffset.dx * size.width,
      centerOffset.dy * size.height,
    );

    path.addOval(
      Rect.fromCircle(center: center, radius: radius),
    );

    return path;
  }

  @override
  bool shouldReclip(covariant CircleRevealClipper oldClipper) {
    return radius != oldClipper.radius ||
        centerOffset != oldClipper.centerOffset;
  }
}
