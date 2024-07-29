import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:neumorphic_calculator/utils/const.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoDialog extends StatefulWidget {
  const InfoDialog({super.key});

  @override
  State<InfoDialog> createState() => _InfoDialogState();
}

class _InfoDialogState extends State<InfoDialog> with TickerProviderStateMixin {
  late AnimationController _swipeRightController;
  late AnimationController _swipeLeftController;
  late AnimationController _swipeUpController;
  late AnimationController _heartController;
  void _initAnimations() {
    _swipeRightController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _swipeLeftController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _swipeUpController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _heartController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
  }

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _swipeLeftController.forward();
    _swipeLeftController.addListener(
      () {
        if (_swipeLeftController.isCompleted) {
          _swipeRightController.reset();
          _swipeRightController.forward();
        }
      },
    );

    _swipeRightController.addListener(
      () {
        if (_swipeRightController.isCompleted) {
          _swipeUpController.reset();
          _swipeUpController.forward();
        }
      },
    );

    _swipeUpController.addListener(
      () {
        if (_swipeUpController.isCompleted) {
          _heartController.reset();
          _heartController.forward();
        }
      },
    );

    _heartController.addListener(
      () {
        if (_heartController.isCompleted) {
          _swipeLeftController.reset();
          _swipeLeftController.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _swipeRightController.dispose();
    _swipeLeftController.dispose();
    _swipeUpController.dispose();
    _heartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleTextStyle = Theme.of(context)
        .textTheme
        .headlineSmall
        ?.copyWith(color: isDark ? Colors.white : Colors.black);
    final githubIconPath = isDark ? AppConst.githubLight : AppConst.githubDark;
    return AlertDialog.adaptive(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text('Neumorphic Calculator', style: titleTextStyle)),
          IconButton(
            onPressed: () async {
              try {
                await launchUrl(Uri.parse(AppConst.githubLink));
              } catch (_) {}
            },
            icon: Lottie.asset(
              githubIconPath,
              width: 50,
              height: 50,
            ),
          )
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.withOpacity(0.35)),
              child: Lottie.asset(
                AppConst.swipeLeftGesture,
                controller: _swipeLeftController,
                width: 50,
                height: 50,
              ),
            ),
            title: const Text('Swipe left to access the history.'),
          ),
          const Divider(),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.withOpacity(0.35)),
              child: Lottie.asset(
                AppConst.swipeRightGesture,
                controller: _swipeRightController,
                width: 50,
                height: 50,
              ),
            ),
            title: const Text('Swipe right to access the settings.'),
          ),
          const Divider(),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.withOpacity(0.35)),
              child: Lottie.asset(
                AppConst.swipeUpGesture,
                controller: _swipeUpController,
                width: 50,
                height: 50,
              ),
            ),
            title: const Text('Swipe up to access quick settings.'),
          ),
          const Divider(),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.withOpacity(0.35)),
              child: Lottie.asset(
                AppConst.heart,
                controller: _heartController,
                width: 50,
                height: 50,
              ),
            ),
            title: const Text('Made with ❤️ by Mohammed Ragheb'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            showLicensePage(context: context);
          },
          child: const Text('Licenses'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
