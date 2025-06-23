import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neumorphic_calculator/dashboard_controller.dart';
import 'package:neumorphic_calculator/screens/calculator_screen/calculator_screen.dart';
import 'package:neumorphic_calculator/screens/history_screen/history_screen.dart';
import 'package:neumorphic_calculator/screens/settings_screen/settings_screen.dart';
import 'package:neumorphic_calculator/tutorial_screen.dart';
import 'package:neumorphic_calculator/widgets/keep_alive_wrapper.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (controller) {
      return PopScope(
        canPop: controller.index == 1,
        onPopInvokedWithResult: (val, _) {
          if (val) return;
          controller.animateToPage(1);
        },
        child: TutorialScreen(
          child: PageView(
            onPageChanged: (index) {
              controller.index = index;
              controller.update();
            },
            controller: controller.pageController,
            children: const [
              KeepAliveWrapper(child: SettingsScreen()),
              KeepAliveWrapper(child: CalculatorScreen()),
              KeepAliveWrapper(child: HistoryScreen())
            ],
          ),
        ),
      );
    });
  }
}
