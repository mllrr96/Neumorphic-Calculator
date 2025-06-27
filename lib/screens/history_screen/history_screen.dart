import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neumorphic_calculator/screens/dashboard_screen/dashboard_controller.dart';
import 'package:neumorphic_calculator/screens/calculator_screen/calculator_controller.dart';
import 'package:neumorphic_calculator/screens/history_screen/history_controller.dart';
import 'package:neumorphic_calculator/screens/settings_screen/settings_controller.dart';
import 'package:neumorphic_calculator/utils/extensions/extensions.dart';
import 'package:neumorphic_calculator/utils/settings_model.dart';
import 'package:neumorphic_calculator/widgets/wipe_overlay_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
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
    return GetBuilder<SettingsController>(builder: (settingsCtrl) {
      final settings = settingsCtrl.state ?? SettingsModel.normal();
      final showTip = settings.showHistoryTip;
      final textStyle = Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(color: Theme.of(context).colorScheme.onSurface);
      return GetBuilder<HistoryController>(builder: (ctrl) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final resultNotEmpty = ctrl.state?.isNotEmpty ?? false;
            return Scaffold(
              body: WipeOverlayList(
                triggerWipe: ctrl.isClearing.value,
                onWipeComplete: (){
                  ctrl.clearData();
                  ctrl.isClearing.value = false;
                },
                child: Column(
                  children: [
                    if (showTip && resultNotEmpty)
                      PreferredSize(
                          preferredSize: Size.fromHeight(_animation.value),
                          child: SizedBox(
                            height: _animation.value,
                            child: ClipRect(
                              child: ListTile(
                                  leading: Icon(Icons.info_outline,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                  title:
                                      const Text('Press and hold to copy result'),
                                  tileColor: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withValues(alpha: 0.1),
                                  trailing: IconButton(
                                    padding: const EdgeInsets.all(16.0),
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      _controller.forward();
                                      settingsCtrl.updateSettings(settingsCtrl
                                              .state
                                              ?.copyWith(showHistoryTip: false) ??
                                          SettingsModel.normal());
                                    },
                                  )),
                            ),
                          )),
                    Expanded(
                      child: ctrl.obx(
                        (historyList) => ListView.builder(
                          itemCount: historyList!.length,
                          itemBuilder: (context, index) {
                            final history = historyList[index];
                            return ListTile(
                              title: Text(history.expression),
                              subtitle: Text(history.output.formatThousands()),
                              trailing: Text(history.dateTime.timeAgo),
                              onTap: () {
                                CalculatorController.instance.updateExpression(
                                  history.expression,
                                  offset: history.expression.length,
                                );
                                DashboardController.instance.animateToPage(1);
                              },
                              onLongPress: () async {
                                // copy the result to the clipboard
                                await Clipboard.setData(
                                    ClipboardData(text: history.output.formatThousands()));
                                HapticFeedback.heavyImpact();
                              },
                            );
                          },
                        ),
                        onEmpty: Center(
                          child: Text('Expression history = 0', style: textStyle),
                        ),
                        onLoading: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        onError: (error) => Center(
                          child: Text(error ?? ' ', style: textStyle),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      });
    });
  }
}
