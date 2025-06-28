import 'package:flutter/material.dart';
import 'dart:math' as math;

class WipeOverlayList extends StatefulWidget {
  final Widget child;
  final bool triggerWipe;
  final VoidCallback? onWipeComplete;
  final Color? lineColor;
  final double lineThickness;
  final Duration duration;

  const WipeOverlayList({
    super.key,
    required this.child,
    required this.triggerWipe,
    required this.onWipeComplete,
    this.lineColor,
    this.lineThickness = 3.0,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<WipeOverlayList> createState() => _WipeOverlayListState();
}

class _WipeOverlayListState extends State<WipeOverlayList>
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
      curve: Curves.easeInOut,
    );

    if (widget.triggerWipe) {
      _startWipe();
    }
  }

  @override
  void didUpdateWidget(covariant WipeOverlayList oldWidget) {
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
    final theme = Theme.of(context);
    final overlayColor = theme.scaffoldBackgroundColor;

    final lineColor = theme.colorScheme.primary.withValues(alpha: 0.5);

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;

        return Stack(
          children: [
            widget.child,
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final wipeHeight = _animation.value * height;

                return Stack(
                  children: [
                    // Overlay itself
                    ClipRect(
                      child: Align(
                        alignment: Alignment.topCenter,
                        heightFactor: _animation.value,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: overlayColor,
                          ),
                        ),
                      ),
                    ),
                    // Thin line at leading edge
                    Positioned(
                      top: math.max(0, wipeHeight - widget.lineThickness / 2),
                      left: 0,
                      right: 0,
                      child: Container(
                        height: widget.lineThickness,
                        color: lineColor,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
