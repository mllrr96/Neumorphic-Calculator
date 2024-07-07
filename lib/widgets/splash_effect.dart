import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SplashEffect extends StatefulWidget {
  const SplashEffect({
    super.key,
    this.child,
    required this.splash,
    this.containedInkWell = false,
    this.radius,
    this.borderRadius,
    this.customBorder,
    this.splashColor,
    this.splashFactory,
    this.enableFeedback = true,
    this.excludeFromSemantics = false,
  });

  final Widget? child;
  final bool splash;
  final bool containedInkWell;
  final double? radius;
  final BorderRadius? borderRadius;
  final ShapeBorder? customBorder;
  final Color? splashColor;
  final InteractiveInkFeatureFactory? splashFactory;
  final bool enableFeedback;
  final bool excludeFromSemantics;

  @override
  InkResponseState createState() => InkResponseState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    // properties
    // .add(IterableProperty<String>('gestures', gestures, ifEmpty: '<none>'));
    // properties
    // .add(DiagnosticsProperty<MouseCursor>('mouseCursor', mouseCursor));
    properties.add(DiagnosticsProperty<bool>(
        'containedInkWell', containedInkWell,
        level: DiagnosticLevel.fine));
  }
}

class InkResponseState extends State<SplashEffect>
    with AutomaticKeepAliveClientMixin<SplashEffect> {
  Set<InteractiveInkFeature>? _splashes;
  InteractiveInkFeature? _currentSplash;

  Timer? _activationTimer;

  @override
  void initState() {
    super.initState();

    if (widget.splash) {
      _startNewSplash(context: context);
    }
  }

  @override
  void didUpdateWidget(SplashEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.splash != oldWidget.splash) {
      _startNewSplash(context: context);
    }
  }

  @override
  void dispose() {
    _activationTimer?.cancel();
    _activationTimer = null;
    super.dispose();
  }

  @override
  bool get wantKeepAlive => (_splashes != null && _splashes!.isNotEmpty);

  InteractiveInkFeature _createSplash(Offset globalPosition) {
    final MaterialInkController inkController = Material.of(context);
    final RenderBox referenceBox = context.findRenderObject()! as RenderBox;
    final Offset position = referenceBox.globalToLocal(globalPosition);
    final Color color = widget.splashColor ?? Theme.of(context).splashColor;
    final BorderRadius? borderRadius = widget.borderRadius;
    final ShapeBorder? customBorder = widget.customBorder;

    InteractiveInkFeature? splash;
    void onRemoved() {
      if (_splashes != null) {
        assert(_splashes!.contains(splash));
        _splashes!.remove(splash);
        if (_currentSplash == splash) {
          _currentSplash = null;
        }
        updateKeepAlive();
      } // else we're probably in deactivate()
    }

    splash = (widget.splashFactory ?? Theme.of(context).splashFactory).create(
      controller: inkController,
      referenceBox: referenceBox,
      position: position,
      color: color,
      containedInkWell: widget.containedInkWell,
      radius: widget.radius,
      borderRadius: borderRadius,
      customBorder: customBorder,
      onRemoved: onRemoved,
      textDirection: Directionality.of(context),
    );

    return splash;
  }

  void _startNewSplash({required BuildContext context}) {
    final RenderBox? referenceBox = context.findRenderObject() as RenderBox?;
    if (referenceBox == null) {
      return;
    }

    assert(referenceBox.hasSize,
        'InkResponse must be done with layout before starting a splash.');
    final Offset globalPosition =
        referenceBox.localToGlobal(referenceBox.paintBounds.bottomLeft);
    final InteractiveInkFeature splash = _createSplash(globalPosition);
    _splashes ??= HashSet<InteractiveInkFeature>();
    _splashes!.add(splash);
    _currentSplash?.cancel();
    _currentSplash = splash;
    updateKeepAlive();
    // updateHighlight(_HighlightType.pressed, value: true);
  }

  @override
  void deactivate() {
    if (_splashes != null) {
      final Set<InteractiveInkFeature> splashes = _splashes!;
      _splashes = null;
      for (final InteractiveInkFeature splash in splashes) {
        splash.dispose();
      }
      _currentSplash = null;
    }
    assert(_currentSplash == null);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.

    _currentSplash?.color = widget.splashColor ?? Theme.of(context).splashColor;

    return DefaultSelectionStyle.merge(
      child: Semantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          excludeFromSemantics: true,
          child: widget.child,
        ),
      ),
    );
  }
}
