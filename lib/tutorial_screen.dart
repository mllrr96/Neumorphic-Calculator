import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:neumorphic_calculator/service/preference_service.dart';
import 'package:neumorphic_calculator/utils/const.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key, required this.child});
  final Widget child;

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen>
    with TickerProviderStateMixin {
  late TutorialCoachMark tutorialCoachMark;
  final historyKey = GlobalKey();
  final settingsKey = GlobalKey();
  bool showSettings = false;
  bool showHistory = false;
  bool ignorePointer = false;

  late AnimationController _swipeRightController;
  late AnimationController _swipeLeftController;

  void _initAnimations() {
    _swipeRightController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _swipeLeftController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
  }

  @override
  void initState() {
    if (PreferencesService.isFirstRun) {
      ignorePointer = true;
      initTutorial();
      _initAnimations();
      Future.delayed(const Duration(seconds: 2), () {
        tutorialCoachMark.show(context: context);
        setState(() {
          showSettings = true;
        });
        _swipeRightController.repeat();
      });
    }
    super.initState();
  }

  void handleClick(TargetFocus target) {
    if (target.identify == 'settings') {
      _swipeRightController.stop();
      setState(() {
        showSettings = false;
        showHistory = true;
      });
      _swipeLeftController.repeat();
    }
    if (target.identify == 'history') {
      _swipeLeftController.stop();
      setState(() {
        showHistory = false;
      });
    }
  }

  void initTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      onClickTarget: handleClick,
      onClickOverlay: handleClick,
      hideSkip: true,
      onSkip: () {
        setState(() {
          showHistory = false;
          showHistory = false;
          ignorePointer = false;
        });
        _swipeRightController.stop();
        _swipeLeftController.stop();
        return true;
      },
      onFinish: () {
        setState(() {
          ignorePointer = false;
        });
        _swipeRightController.stop();
        _swipeLeftController.stop();
      },
      paddingFocus: 0.0,
      targets: [
        TargetFocus(
          identify: 'settings',
          keyTarget: settingsKey,
          alignSkip: Alignment.bottomRight,
          enableOverlayTab: true,
          contents: [
            TargetContent(
              builder: (context, controller) {
                return const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Swipe right to view settings',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'and change theme, button style and more',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        TargetFocus(
          identify: 'history',
          keyTarget: historyKey,
          paddingFocus: 0.0,
          alignSkip: Alignment.bottomRight,
          enableOverlayTab: true,
          contents: [
            TargetContent(
              builder: (context, controller) {
                return const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Swipe left to view calculations history',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ],
      colorShadow: Colors.blue,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (!PreferencesService.isFirstRun) {
      return widget.child;
    }

    return Stack(
      children: [
        IgnorePointer(ignoring: ignorePointer, child: widget.child),
        IgnorePointer(
          ignoring: true,
          child: AnimatedOpacity(
              opacity: showSettings ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Material(
                color: isDark
                    ? Colors.transparent
                    : Colors.grey.withValues(alpha: 0.5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Lottie.asset(AppConst.swipeRightGesture,
                      key: settingsKey,
                      height: 150,
                      width: 150,
                      controller: _swipeRightController),
                ),
              )),
        ),
        IgnorePointer(
          ignoring: true,
          child: AnimatedOpacity(
              opacity: showHistory ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Material(
                color: isDark
                    ? Colors.transparent
                    : Colors.grey.withValues(alpha: 0.5),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Lottie.asset(AppConst.swipeLeftGesture,
                      key: historyKey,
                      height: 150,
                      width: 150,
                      controller: _swipeLeftController),
                ),
              )),
        ),
      ],
    );
  }
}
