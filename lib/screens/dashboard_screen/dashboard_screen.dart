import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neumorphic_calculator/screens/calculator_screen/calculator_controller.dart';
import 'package:neumorphic_calculator/screens/dashboard_screen/dashboard_controller.dart';
import 'package:neumorphic_calculator/screens/calculator_screen/calculator_screen.dart';
import 'package:neumorphic_calculator/screens/history_screen/history_screen.dart';
import 'package:neumorphic_calculator/screens/settings_screen/settings_screen.dart';
import 'package:neumorphic_calculator/tutorial_screen.dart';
import 'package:neumorphic_calculator/utils/extensions/extensions.dart';
import 'package:neumorphic_calculator/widgets/calculator_app_bar.dart';
import 'package:neumorphic_calculator/widgets/circular_wipe_overlay_widget.dart';
import 'package:neumorphic_calculator/widgets/input_widget.dart';
import 'package:neumorphic_calculator/widgets/keep_alive_wrapper.dart';
import 'package:neumorphic_calculator/widgets/result_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<DashboardController>(builder: (dashCtrl) {
      return PopScope(
        canPop: dashCtrl.index == 1,
        onPopInvokedWithResult: (val, _) {
          if (val) return;
          dashCtrl.animateToPage(1);
        },
        child: TutorialScreen(
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: theme.appBarTheme.systemOverlayStyle?.copyWith(
                  systemNavigationBarColor: theme.scaffoldBackgroundColor,
                ) ??
                SystemUiOverlayStyle.light,
            child: Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    Flexible(
                      child: GetBuilder<CalculatorController>(
                        builder: (controller) {
                          return CircularWipeOverlayWidget(
                            triggerWipe: controller.isClearing,
                            onWipeComplete: () {
                              controller.isClearing = false;
                              controller.output = '';
                              controller.textCtrl.clear();
                              controller.update();
                            },
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CalculatorAppBar(),
                                  Expanded(
                                      flex: 2,
                                      child: InputWidget(controller.textCtrl)),
                                  Expanded(
                                    child: ResultWidget(
                                      controller.output.formatExpression(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: PageView(
                        onPageChanged: (index) {
                          dashCtrl.index = index;
                          dashCtrl.update();
                        },
                        controller: dashCtrl.pageController,
                        children: const [
                          KeepAliveWrapper(child: SettingsScreen()),
                          KeepAliveWrapper(child: CalculatorScreen()),
                          KeepAliveWrapper(child: HistoryScreen())
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
