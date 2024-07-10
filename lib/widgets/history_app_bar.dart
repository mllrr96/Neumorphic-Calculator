import 'package:flutter/material.dart';
import 'package:neumorphic_calculator/settings_screen.dart';
import 'package:neumorphic_calculator/utils/extensions/extensions.dart';

import '../service/preference_service.dart';

class HistoryAppBar extends StatefulWidget implements PreferredSizeWidget {
  const HistoryAppBar({super.key});

  @override
  State<HistoryAppBar> createState() => _HistoryAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HistoryAppBarState extends State<HistoryAppBar>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 56, end: 0).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = PreferencesService.instance.results;
    final PreferencesService prefs = PreferencesService.instance;

    return AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return AppBar(
            toolbarHeight: kToolbarHeight,
            title: const Text('History'),
            bottom: prefs.settingsModel.showHistoryTip
                ? PreferredSize(
                    preferredSize: Size.fromHeight(_animation.value),
                    child: SizedBox(
                      height: _animation.value,
                      child: ClipRect(
                        child: Column(
                          children: [
                            Expanded(
                              child: ListTile(
                                  leading: Icon(Icons.info_outline,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                  title: const Text(
                                      'Press and hold to copy result'),
                                  tileColor: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.1),
                                  trailing: IconButton(
                                    padding: const EdgeInsets.all(16.0),
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      _controller.forward();
                                      prefs.updateSettings(prefs.settingsModel
                                          .copyWith(showHistoryTip: false));
                                    },
                                  )),
                            ),
                            const Divider(height: 0),
                          ],
                        ),
                      ),
                    ))
                : null,
            actions: [
              if (results.isNotEmpty)
                IconButton(
                    icon: const Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                    ),
                    padding: const EdgeInsets.all(16.0),
                    onPressed: () {
                      ConfirmDialog(
                          title: 'Clear History',
                          content:
                              'Are you sure you want to clear the history?',
                          confirmText: 'Clear',
                          onConfirm: () {
                            PreferencesService.instance.clearResults();
                          }).show(context);
                    }),
            ],
          );
        });
  }
}
