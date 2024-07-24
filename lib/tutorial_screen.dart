import 'package:flutter/material.dart';
import 'package:neumorphic_calculator/service/preference_service.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key, required this.child});
  final Widget child;

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  late TutorialCoachMark tutorialCoachMark;
  final historyKey = GlobalKey();
  final swipeUpKey = GlobalKey();
  final settingsKey = GlobalKey();
  bool showSettings = false;
  bool showHistory = false;
  bool showSwipeUp = false;
  bool ignorePointer = false;

  @override
  void initState() {
    if (PreferencesService.isFirstRun) {
      ignorePointer = true;
      initTutorial();
      Future.delayed(const Duration(seconds: 2), () {
        tutorialCoachMark.show(context: context);
        setState(() {
          showSettings = true;
        });
      });
    }
    super.initState();
  }

  void handleClick(TargetFocus target) {
    if (target.identify == 'settings') {
      setState(() {
        showSettings = false;
        showHistory = true;
      });
    }
    if (target.identify == 'history') {
      setState(() {
        showHistory = false;
        showSwipeUp = true;
      });
    } else if (target.identify == 'swipeup') {
      setState(() {
        showSwipeUp = false;
      });
    }
  }

  void initTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      onClickTarget: handleClick,
      onClickOverlay: handleClick,
      onSkip: () {
        setState(() {
          showHistory = false;
          showSwipeUp = false;
          showHistory = false;
          ignorePointer = false;
        });
        return true;
      },
      onFinish: () {
        setState(() {
          ignorePointer = false;
        });
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
        TargetFocus(
          identify: 'swipeup',
          keyTarget: swipeUpKey,
          paddingFocus: 0.0,
          alignSkip: Alignment.bottomRight,
          enableOverlayTab: true,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return const Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Swipe up to view more settings',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                    Text(
                      'and enable scientific calculator',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ], // List<TargetFocus>
      colorShadow: Colors.blue, // DEFAULT Colors.black
    );
  }

  @override
  Widget build(BuildContext context) {
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
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Material(
                    key: settingsKey,
                    elevation: 2,
                    borderRadius: BorderRadius.circular(50),
                    child: IconButton(
                      padding: const EdgeInsets.all(16),
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ),
                ),
              )),
        ),
        IgnorePointer(
          ignoring: true,
          child: AnimatedOpacity(
              opacity: showHistory ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Material(
                    key: historyKey,
                    elevation: 2,
                    borderRadius: BorderRadius.circular(50),
                    child: IconButton(
                      padding: const EdgeInsets.all(16),
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                ),
              )),
        ),
        IgnorePointer(
          ignoring: true,
          child: AnimatedOpacity(
              opacity: showSwipeUp ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Material(
                    key: swipeUpKey,
                    elevation: 2,
                    borderRadius: BorderRadius.circular(50),
                    child: IconButton(
                      padding: const EdgeInsets.all(16),
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_upward),
                    ),
                  ),
                ),
              )),
        ),
      ],
    );
  }
}
