// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

abstract class _ParentInkResponseState {
  void markChildInkResponsePressed(
      _ParentInkResponseState childState, bool value);
}

class _ParentInkResponseProvider extends InheritedWidget {
  const _ParentInkResponseProvider({
    required this.state,
    required super.child,
  });

  final _ParentInkResponseState state;

  @override
  bool updateShouldNotify(_ParentInkResponseProvider oldWidget) =>
      state != oldWidget.state;

  static _ParentInkResponseState? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_ParentInkResponseProvider>()
        ?.state;
  }
}

typedef _GetRectCallback = RectCallback? Function(RenderBox referenceBox);
typedef _CheckContext = bool Function(BuildContext context);

/// An area of a [Material] that responds to touch. Has a configurable shape and
/// can be configured to clip splashes that extend outside its bounds or not.
///
/// For a variant of this widget that is specialized for rectangular areas that
/// always clip splashes, see [InkWell].
///
/// An [SplashContainer] widget does two things when responding to a tap:
///
///  * It starts to animate a _highlight_. The shape of the highlight is
///    determined by [highlightShape]. If it is a [BoxShape.circle], the
///    default, then the highlight is a circle of fixed size centered in the
///    [SplashContainer]. If it is [BoxShape.rectangle], then the highlight is a box
///    the size of the [SplashContainer] itself, unless [getRectCallback] is
///    provided, in which case that callback defines the rectangle. The color of
///    the highlight is set by [highlightColor].
///
///  * Simultaneously, it starts to animate a _splash_. This is a growing circle
///    initially centered on the tap location. If this is a [containedInkWell],
///    the splash grows to the [radius] while remaining centered at the tap
///    location. Otherwise, the splash migrates to the center of the box as it
///    grows.
///
/// The following two diagrams show how [SplashContainer] looks when tapped if the
/// [highlightShape] is [BoxShape.circle] (the default) and [containedInkWell]
/// is false (also the default).
///
/// The first diagram shows how it looks if the [SplashContainer] is relatively
/// large:
///
/// ![The highlight is a disc centered in the box, smaller than the child widget.](https://flutter.github.io/assets-for-api-docs/assets/material/ink_response_large.png)
///
/// The second diagram shows how it looks if the [SplashContainer] is small:
///
/// ![The highlight is a disc overflowing the box, centered on the child.](https://flutter.github.io/assets-for-api-docs/assets/material/ink_response_small.png)
///
/// The main thing to notice from these diagrams is that the splashes happily
/// exceed the bounds of the widget (because [containedInkWell] is false).
///
/// The following diagram shows the effect when the [SplashContainer] has a
/// [highlightShape] of [BoxShape.rectangle] with [containedInkWell] set to
/// true. These are the values used by [InkWell].
///
/// ![The highlight is a rectangle the size of the box.](https://flutter.github.io/assets-for-api-docs/assets/material/ink_well.png)
///
/// The [SplashContainer] widget must have a [Material] widget as an ancestor. The
/// [Material] widget is where the ink reactions are actually painted. This
/// matches the Material Design premise wherein the [Material] is what is
/// actually reacting to touches by spreading ink.
///
/// If a Widget uses this class directly, it should include the following line
/// at the top of its build function to call [debugCheckHasMaterial]:
///
/// ```dart
/// assert(debugCheckHasMaterial(context));
/// ```
///
/// ## Troubleshooting
///
/// ### The ink splashes aren't visible!
///
/// If there is an opaque graphic, e.g. painted using a [Container], [Image], or
/// [DecoratedBox], between the [Material] widget and the [SplashContainer] widget,
/// then the splash won't be visible because it will be under the opaque graphic.
/// This is because ink splashes draw on the underlying [Material] itself, as
/// if the ink was spreading inside the material.
///
/// The [Ink] widget can be used as a replacement for [Image], [Container], or
/// [DecoratedBox] to ensure that the image or decoration also paints in the
/// [Material] itself, below the ink.
///
/// If this is not possible for some reason, e.g. because you are using an
/// opaque [CustomPaint] widget, alternatively consider using a second
/// [Material] above the opaque widget but below the [SplashContainer] (as an
/// ancestor to the ink response). The [MaterialType.transparency] material
/// kind can be used for this purpose.
///
/// See also:
///
///  * [GestureDetector], for listening for gestures without ink splashes.
///  * [ElevatedButton] and [TextButton], two kinds of buttons in Material Design.
///  * [IconButton], which combines [SplashContainer] with an [Icon].
class SplashContainer extends StatelessWidget {
  /// Creates an area of a [Material] that responds to touch.
  ///
  /// Must have an ancestor [Material] widget in which to cause ink reactions.
  const SplashContainer({
    super.key,
    this.splash = false,
    this.child,
    this.containedInkWell = false,
    this.highlightShape = BoxShape.circle,
    this.radius,
    this.borderRadius,
    this.customBorder,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.overlayColor,
    this.splashColor,
    this.splashFactory,
    this.enableFeedback = true,
    this.excludeFromSemantics = false,
    this.focusNode,
    this.canRequestFocus = true,
    this.onFocusChange,
    this.autofocus = false,
    this.statesController,
    this.hoverDuration,
  });

  final bool splash;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  /// Whether this ink response should be clipped its bounds.
  ///
  /// This flag also controls whether the splash migrates to the center of the
  /// [SplashContainer] or not. If [containedInkWell] is true, the splash remains
  /// centered around the tap location. If it is false, the splash migrates to
  /// the center of the [SplashContainer] as it grows.
  ///
  /// See also:
  ///
  ///  * [highlightShape], the shape of the focus, hover, and pressed
  ///    highlights.
  ///  * [borderRadius], which controls the corners when the box is a rectangle.
  ///  * [getRectCallback], which controls the size and position of the box when
  ///    it is a rectangle.
  final bool containedInkWell;

  /// The shape (e.g., circle, rectangle) to use for the highlight drawn around
  /// this part of the material when pressed, hovered over, or focused.
  ///
  /// The same shape is used for the pressed highlight (see [highlightColor]),
  /// the focus highlight (see [focusColor]), and the hover highlight (see
  /// [hoverColor]).
  ///
  /// If the shape is [BoxShape.circle], then the highlight is centered on the
  /// [SplashContainer]. If the shape is [BoxShape.rectangle], then the highlight
  /// fills the [SplashContainer], or the rectangle provided by [getRectCallback] if
  /// the callback is specified.
  ///false
  ///
  ///  * [containedInkWell], which controls clipping behavior.
  ///  * [borderRadius], which controls the corners when the box is a rectangle.
  ///  * [highlightColor], the color of the highlight.
  ///  * [getRectCallback], which controls the size and position of the box when
  ///    it is a rectangle.
  final BoxShape highlightShape;

  /// The radius of the ink splash.
  ///
  /// Splashes grow up to this size. By default, this size is determined from
  /// the size of the rectangle provided by [getRectCallback], or the size of
  /// the [SplashContainer] itself.
  ///
  /// See also:
  ///
  ///  * [splashColor], the color of the splash.
  ///  * [splashFactory], which defines the appearance of the splash.
  final double? radius;

  /// The border radius of the containing rectangle. This is effective only if
  /// [highlightShape] is [BoxShape.rectangle].
  ///
  /// If this is null, it is interpreted as [BorderRadius.zero].
  final BorderRadius? borderRadius;

  /// The custom clip border.
  ///
  /// If this is null, the ink response will not clip its content.
  final ShapeBorder? customBorder;

  /// The color of the ink response when the parent widget is focused. If this
  /// property is null then the focus color of the theme,
  /// [ThemeData.focusColor], will be used.
  ///
  /// See also:
  ///
  ///  * [highlightShape], the shape of the focus, hover, and pressed
  ///    highlights.
  ///  * [hoverColor], the color of the hover highlight.
  ///  * [splashColor], the color of the splash.
  ///  * [splashFactory], which defines the appearance of the splash.
  final Color? focusColor;

  /// The color of the ink response when a pointer is hovering over it. If this
  /// property is null then the hover color of the theme,
  /// [ThemeData.hoverColor], will be used.
  ///
  /// See also:
  ///
  ///  * [highlightShape], the shape of the focus, hover, and pressed
  ///    highlights.
  ///  * [highlightColor], the color of the pressed highlight.
  ///  * [focusColor], the color of the focus highlight.
  ///  * [splashColor], the color of the splash.
  ///  * [splashFactory], which defines the appearance of the splash.
  final Color? hoverColor;

  /// The highlight color of the ink response when pressed. If this property is
  /// null then the highlight color of the theme, [ThemeData.highlightColor],
  /// will be used.
  ///
  /// See also:
  ///
  ///  * [hoverColor], the color of the hover highlight.
  ///  * [focusColor], the color of the focus highlight.
  ///  * [highlightShape], the shape of the focus, hover, and pressed
  ///    highlights.
  ///  * [splashColor], the color of the splash.
  ///  * [splashFactory], which defines the appearance of the splash.
  final Color? highlightColor;

  /// Defines the ink response focus, hover, and splash colors.
  ///
  /// This default null property can be used as an alternative to
  /// [focusColor], [hoverColor], [highlightColor], and
  /// [splashColor]. If non-null, it is resolved against one of
  /// [MaterialState.focused], [MaterialState.hovered], and
  /// [MaterialState.pressed]. It's convenient to use when the parent
  /// widget can pass along its own MaterialStateProperty value for
  /// the overlay color.
  ///
  /// [MaterialState.pressed] triggers a ripple (an ink splash), per
  /// the current Material Design spec. The [overlayColor] doesn't map
  /// a state to [highlightColor] because a separate highlight is not
  /// used by the current design guidelines. See
  /// https://material.io/design/interaction/states.html#pressed
  ///
  /// If the overlay color is null or resolves to null, then [focusColor],
  /// [hoverColor], [splashColor] and their defaults are used instead.
  ///
  /// See also:
  ///
  ///  * The Material Design specification for overlay colors and how they
  ///    match a component's state:
  ///    <https://material.io/design/interaction/states.html#anatomy>.
  final MaterialStateProperty<Color?>? overlayColor;

  /// The splash color of the ink response. If this property is null then the
  /// splash color of the theme, [ThemeData.splashColor], will be used.
  ///
  /// See also:
  ///
  ///  * [splashFactory], which defines the appearance of the splash.
  ///  * [radius], the (maximum) size of the ink splash.
  ///  * [highlightColor], the color of the highlight.
  final Color? splashColor;

  /// Defines the appearance of the splash.
  ///
  /// Defaults to the value of the theme's splash factory: [ThemeData.splashFactory].
  ///
  /// See also:
  ///
  ///  * [radius], the (maximum) size of the ink splash.
  ///  * [splashColor], the color of the splash.
  ///  * [highlightColor], the color of the highlight.
  ///  * [InkSplash.splashFactory], which defines the default splash.
  ///  * [InkRipple.splashFactory], which defines a splash that spreads out
  ///    more aggressively than the default.
  final InteractiveInkFeatureFactory? splashFactory;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a tap will produce a clicking sound and a
  /// long-press will produce a short vibration, when feedback is enabled.
  ///
  /// See also:
  ///
  ///  * [Feedback] for providing platform-specific feedback to certain actions.
  final bool enableFeedback;

  /// Whether to exclude the gestures introduced by this widget from the
  /// semantics tree.
  ///
  /// For example, a long-press gesture for showing a tooltip is usually
  /// excluded because the tooltip itself is included in the semantics
  /// tree directly and so having a gesture to show it would result in
  /// duplication of information.
  final bool excludeFromSemantics;

  /// {@template flutter.material.inkwell.onFocusChange}
  /// Handler called when the focus changes.
  ///
  /// Called with true if this widget's node gains focus, and false if it loses
  /// focus.
  /// {@endtemplate}
  final ValueChanged<bool>? onFocusChange;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.canRequestFocus}
  final bool canRequestFocus;

  /// The rectangle to use for the highlight effect and for clipping
  /// the splash effects if [containedInkWell] is true.
  ///
  /// This method is intended to be overridden by descendants that
  /// specialize [SplashContainer] for unusual cases. For example,
  /// [TableRowInkWell] implements this method to return the rectangle
  /// corresponding to the row that the widget is in.
  ///
  /// The default behavior returns null, which is equivalent to
  /// returning the referenceBox argument's bounding box (though
  /// slightly more efficient).
  RectCallback? getRectCallback(RenderBox referenceBox) => null;

  /// {@template flutter.material.inkwell.statesController}
  /// Represents the interactive "state" of this widget in terms of
  /// a set of [MaterialState]s, like [MaterialState.pressed] and
  /// [MaterialState.focused].
  ///
  /// Classes based on this one can provide their own
  /// [MaterialStatesController] to which they've added listeners.
  /// They can also update the controller's [MaterialStatesController.value]
  /// however, this may only be done when it's safe to call
  /// [State.setState], like in an event handler.
  /// {@endtemplate}
  final MaterialStatesController? statesController;

  /// The duration of the animation that animates the hover effect.
  ///
  /// The default is 50ms.
  final Duration? hoverDuration;

  @override
  Widget build(BuildContext context) {
    final _ParentInkResponseState? parentState =
        _ParentInkResponseProvider.maybeOf(context);
    return _InkResponseStateWidget(
      splash: splash,
      containedInkWell: containedInkWell,
      highlightShape: highlightShape,
      radius: radius,
      borderRadius: borderRadius,
      customBorder: customBorder,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      overlayColor: overlayColor,
      splashColor: splashColor,
      splashFactory: splashFactory,
      enableFeedback: enableFeedback,
      excludeFromSemantics: excludeFromSemantics,
      focusNode: focusNode,
      canRequestFocus: canRequestFocus,
      onFocusChange: onFocusChange,
      autofocus: autofocus,
      parentState: parentState,
      getRectCallback: getRectCallback,
      debugCheckContext: debugCheckContext,
      statesController: statesController,
      hoverDuration: hoverDuration,
      child: child,
    );
  }

  /// Asserts that the given context satisfies the prerequisites for
  /// this class.
  ///
  /// This method is intended to be overridden by descendants that
  /// specialize [SplashContainer] for unusual cases. For example,
  /// [TableRowInkWell] implements this method to verify that the widget is
  /// in a table.
  @mustCallSuper
  bool debugCheckContext(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasDirectionality(context));
    return true;
  }
}

class _InkResponseStateWidget extends StatefulWidget {
  const _InkResponseStateWidget({
    this.child,
    required this.splash,
    this.containedInkWell = false,
    this.highlightShape = BoxShape.circle,
    this.radius,
    this.borderRadius,
    this.customBorder,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.overlayColor,
    this.splashColor,
    this.splashFactory,
    this.enableFeedback = true,
    this.excludeFromSemantics = false,
    this.focusNode,
    this.canRequestFocus = true,
    this.onFocusChange,
    this.autofocus = false,
    this.parentState,
    this.getRectCallback,
    required this.debugCheckContext,
    this.statesController,
    this.hoverDuration,
  });

  final Widget? child;
  final bool splash;
  final bool containedInkWell;
  final BoxShape highlightShape;
  final double? radius;
  final BorderRadius? borderRadius;
  final ShapeBorder? customBorder;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final MaterialStateProperty<Color?>? overlayColor;
  final Color? splashColor;
  final InteractiveInkFeatureFactory? splashFactory;
  final bool enableFeedback;
  final bool excludeFromSemantics;
  final ValueChanged<bool>? onFocusChange;
  final bool autofocus;
  final FocusNode? focusNode;
  final bool canRequestFocus;
  final _ParentInkResponseState? parentState;
  final _GetRectCallback? getRectCallback;
  final _CheckContext debugCheckContext;
  final MaterialStatesController? statesController;
  final Duration? hoverDuration;

  @override
  _InkResponseState createState() => _InkResponseState();

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
    properties.add(DiagnosticsProperty<BoxShape>(
      'highlightShape',
      highlightShape,
      description: '${containedInkWell ? "clipped to " : ""}$highlightShape',
      showName: false,
    ));
  }
}

/// Used to index the allocated highlights for the different types of highlights
/// in [_InkResponseState].
enum _HighlightType {
  pressed,
  hover,
  focus,
}

class _InkResponseState extends State<_InkResponseStateWidget>
    with AutomaticKeepAliveClientMixin<_InkResponseStateWidget>
    implements _ParentInkResponseState {
  Set<InteractiveInkFeature>? _splashes;
  InteractiveInkFeature? _currentSplash;
  final Map<_HighlightType, InkHighlight?> _highlights =
      <_HighlightType, InkHighlight?>{};
  MaterialStatesController? internalStatesController;

  bool get highlightsExist => _highlights.values
      .where((InkHighlight? highlight) => highlight != null)
      .isNotEmpty;

  final ObserverList<_ParentInkResponseState> _activeChildren =
      ObserverList<_ParentInkResponseState>();

  Timer? _activationTimer;

  @override
  void markChildInkResponsePressed(
      _ParentInkResponseState childState, bool value) {
    final bool lastAnyPressed = _anyChildInkResponsePressed;
    if (value) {
      _activeChildren.add(childState);
    } else {
      _activeChildren.remove(childState);
    }
    final bool nowAnyPressed = _anyChildInkResponsePressed;
    if (nowAnyPressed != lastAnyPressed) {
      widget.parentState?.markChildInkResponsePressed(this, nowAnyPressed);
    }
  }

  bool get _anyChildInkResponsePressed => _activeChildren.isNotEmpty;

  void handleStatesControllerChange() {
    // Force a rebuild to resolve widget.overlayColor, widget.mouseCursor
    setState(() {});
  }

  MaterialStatesController get statesController =>
      widget.statesController ?? internalStatesController!;

  void initStatesController() {
    if (widget.statesController == null) {
      internalStatesController = MaterialStatesController();
    }
    statesController.addListener(handleStatesControllerChange);
  }

  @override
  void initState() {
    super.initState();
    initStatesController();

    if (widget.splash) {
      _startNewSplash(context: context);
    }
  }

  @override
  void didUpdateWidget(_InkResponseStateWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.statesController != oldWidget.statesController) {
      oldWidget.statesController?.removeListener(handleStatesControllerChange);
      if (widget.statesController != null) {
        internalStatesController?.dispose();
        internalStatesController = null;
      }
      initStatesController();
    }
    if (widget.customBorder != oldWidget.customBorder) {
      _updateHighlightsAndSplashes();
    }

    if (widget.splash != oldWidget.splash) {
      _startNewSplash(context: context);
    }
  }

  @override
  void dispose() {
    statesController.removeListener(handleStatesControllerChange);
    internalStatesController?.dispose();
    _activationTimer?.cancel();
    _activationTimer = null;
    super.dispose();
  }

  @override
  bool get wantKeepAlive =>
      highlightsExist || (_splashes != null && _splashes!.isNotEmpty);

  Duration getFadeDurationForType(_HighlightType type) {
    switch (type) {
      case _HighlightType.pressed:
        return const Duration(milliseconds: 200);
      case _HighlightType.hover:
      case _HighlightType.focus:
        return widget.hoverDuration ?? const Duration(milliseconds: 50);
    }
  }

  void updateHighlight(_HighlightType type,
      {required bool value, bool callOnHover = true}) {
    final InkHighlight? highlight = _highlights[type];
    void handleInkRemoval() {
      assert(_highlights[type] != null);
      _highlights[type] = null;
      updateKeepAlive();
    }

    switch (type) {
      case _HighlightType.pressed:
        statesController.update(MaterialState.pressed, value);
      case _HighlightType.hover:
        if (callOnHover) {
          statesController.update(MaterialState.hovered, value);
        }
      case _HighlightType.focus:
        // see handleFocusUpdate()
        break;
    }

    if (type == _HighlightType.pressed) {
      widget.parentState?.markChildInkResponsePressed(this, value);
    }
    if (value == (highlight != null && highlight.active)) {
      return;
    }

    if (value) {
      if (highlight == null) {
        final Color resolvedOverlayColor =
            widget.overlayColor?.resolve(statesController.value) ??
                switch (type) {
                  // Use the backwards compatible defaults
                  _HighlightType.pressed =>
                    widget.highlightColor ?? Theme.of(context).highlightColor,
                  _HighlightType.focus =>
                    widget.focusColor ?? Theme.of(context).focusColor,
                  _HighlightType.hover =>
                    widget.hoverColor ?? Theme.of(context).hoverColor,
                };
        final RenderBox referenceBox = context.findRenderObject()! as RenderBox;
        _highlights[type] = InkHighlight(
          controller: Material.of(context),
          referenceBox: referenceBox,
          color: resolvedOverlayColor,
          shape: widget.highlightShape,
          radius: widget.radius,
          borderRadius: widget.borderRadius,
          customBorder: widget.customBorder,
          rectCallback: widget.getRectCallback!(referenceBox),
          onRemoved: handleInkRemoval,
          textDirection: Directionality.of(context),
          fadeDuration: getFadeDurationForType(type),
        );
        updateKeepAlive();
      } else {
        highlight.activate();
      }
    } else {
      highlight!.deactivate();
    }
    assert(value == (_highlights[type] != null && _highlights[type]!.active));

    // switch (type) {
    //   case _HighlightType.pressed:
    //     widget.onHighlightChanged?.call(value);
    //   case _HighlightType.hover:
    //     if (callOnHover) {
    //       widget.onHover?.call(value);
    //     }
    //   case _HighlightType.focus:
    //     break;
    // }
  }

  void _updateHighlightsAndSplashes() {
    for (final InkHighlight? highlight in _highlights.values) {
      if (highlight != null) {
        highlight.customBorder = widget.customBorder;
      }
    }
    if (_currentSplash != null) {
      _currentSplash!.customBorder = widget.customBorder;
    }
    if (_splashes != null && _splashes!.isNotEmpty) {
      for (final InteractiveInkFeature inkFeature in _splashes!) {
        inkFeature.customBorder = widget.customBorder;
      }
    }
  }

  InteractiveInkFeature _createSplash(Offset globalPosition) {
    final MaterialInkController inkController = Material.of(context);
    final RenderBox referenceBox = context.findRenderObject()! as RenderBox;
    final Offset position = referenceBox.globalToLocal(globalPosition);
    final Color color = widget.splashColor!;
    final RectCallback? rectCallback =
        widget.containedInkWell ? widget.getRectCallback!(referenceBox) : null;
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
      rectCallback: rectCallback,
      radius: widget.radius,
      borderRadius: borderRadius,
      customBorder: customBorder,
      onRemoved: onRemoved,
      textDirection: Directionality.of(context),
    );

    return splash;
  }

  void _startNewSplash({required BuildContext context}) {
    final RenderBox referenceBox = context.findRenderObject()! as RenderBox;
    assert(referenceBox.hasSize,
        'InkResponse must be done with layout before starting a splash.');
    final Offset globalPosition =
        referenceBox.localToGlobal(referenceBox.paintBounds.bottomLeft);

    statesController.update(
        MaterialState.pressed, true); // ... before creating the splash
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
    for (final _HighlightType highlight in _highlights.keys) {
      _highlights[highlight]?.dispose();
      _highlights[highlight] = null;
    }
    widget.parentState?.markChildInkResponsePressed(this, false);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.debugCheckContext(context));
    super.build(context); // See AutomaticKeepAliveClientMixin.

    Color getHighlightColorForType(_HighlightType type) {
      const Set<MaterialState> pressed = <MaterialState>{MaterialState.pressed};
      const Set<MaterialState> focused = <MaterialState>{MaterialState.focused};
      const Set<MaterialState> hovered = <MaterialState>{MaterialState.hovered};

      final ThemeData theme = Theme.of(context);
      return switch (type) {
        // The pressed state triggers a ripple (ink splash), per the current
        // Material Design spec. A separate highlight is no longer used.
        // See https://material.io/design/interaction/states.html#pressed
        _HighlightType.pressed => widget.overlayColor?.resolve(pressed) ??
            widget.highlightColor ??
            theme.highlightColor,
        _HighlightType.focus => widget.overlayColor?.resolve(focused) ??
            widget.focusColor ??
            theme.focusColor,
        _HighlightType.hover => widget.overlayColor?.resolve(hovered) ??
            widget.hoverColor ??
            theme.hoverColor,
      };
    }

    for (final _HighlightType type in _highlights.keys) {
      _highlights[type]?.color = getHighlightColorForType(type);
    }

    _currentSplash?.color =
        widget.overlayColor?.resolve(statesController.value) ??
            widget.splashColor ??
            Theme.of(context).splashColor;

    return _ParentInkResponseProvider(
      state: this,
      child: DefaultSelectionStyle.merge(
        child: Semantics(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            excludeFromSemantics: true,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
