import 'dart:async';
import 'package:animated_theme_switcher/animated_theme_switcher.dart'
    hide ThemeSwitcherState;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;
import 'theme_switcher_bloc.dart';

typedef ThemeBlocBuilder = Widget Function(BuildContext, ThemeState state);

class ThemeBlocProvider extends StatefulWidget {
  const ThemeBlocProvider({
    super.key,
    this.builder,
    this.child,
    this.duration = const Duration(milliseconds: 300),
    required this.themeState,
  });
  final ThemeBlocBuilder? builder;
  final Widget? child;
  final ThemeState themeState;
  final Duration duration;
  @override
  State<ThemeBlocProvider> createState() => _ThemeBlocProviderState();
}

class _ThemeBlocProviderState extends State<ThemeBlocProvider>
    with TickerProviderStateMixin {
  late AnimationController controller;
  ui.Image? image;
  final previewContainer = GlobalKey();
  bool isReversed = false;
  late Offset switcherOffset;
  ThemeSwitcherClipper clipper = const ThemeSwitcherCircleClipper();

  void changeTheme({
    required ThemeMode themeMode,
    required GlobalKey key,
    ThemeSwitcherClipper? clipper,
    required bool isReversed,
    Offset? offset,
    VoidCallback? onAnimationFinish,
  }) async {
    if (controller.isAnimating) {
      return;
    }

    if (clipper != null) {
      this.clipper = clipper;
    }
    this.isReversed = isReversed;
    switcherOffset = _getSwitcherCoordinates(key, offset);
    await _saveScreenshot();

    if (isReversed) {
      await controller
          .reverse(from: 1.0)
          .then((value) => onAnimationFinish?.call());
    } else {
      await controller
          .forward(from: 0.0)
          .then((value) => onAnimationFinish?.call());
    }
    setState(() {});
  }

  Future<void> _saveScreenshot() async {
    final boundary = previewContainer.currentContext!.findRenderObject()
        as RenderRepaintBoundary;
    image = await boundary.toImage(
        pixelRatio: WidgetsBinding
            .instance.platformDispatcher.views.first.devicePixelRatio);
    setState(() {});
  }

  Offset _getSwitcherCoordinates(
      GlobalKey<State<StatefulWidget>> switcherGlobalKey,
      [Offset? tapOffset]) {
    final renderObject =
        switcherGlobalKey.currentContext!.findRenderObject()! as RenderBox;
    final size = renderObject.size;
    return renderObject.localToGlobal(Offset.zero).translate(
          tapOffset?.dx ?? (size.width / 2),
          tapOffset?.dy ?? (size.height / 2),
        );
  }

  @override
  void initState() {
    controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.child != null || widget.builder != null,
        'child or builder must be provided');
    return BlocProvider(
      create: (context) => ThemeSwitcherBloc(),
      child: Builder(builder: (context) {
        return BlocBuilder<ThemeSwitcherBloc, ThemeSwitcherState>(
          builder: (context, state) {
            return RepaintBoundary(
              key: previewContainer,
              child: widget.child ??
                  widget.builder!(
                      context, (state as ThemeSwitcherLoaded).themeState),
            );
          },
        );
      }),
    );
  }
}
