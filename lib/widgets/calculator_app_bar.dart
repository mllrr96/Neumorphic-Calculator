import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:neumorphic_calculator/controllers/theme_controller.dart';
import 'package:neumorphic_calculator/screens/dashboard_screen/dashboard_controller.dart';
import 'package:neumorphic_calculator/screens/history_screen/history_controller.dart';
import 'package:neumorphic_calculator/screens/settings_screen/settings_controller.dart';
import 'package:neumorphic_calculator/utils/const.dart';
import 'package:neumorphic_calculator/utils/extensions/extensions.dart';
import 'package:neumorphic_calculator/utils/extensions/theme_extension.dart';
import 'package:neumorphic_calculator/widgets/confirm_dialog.dart';
import 'package:neumorphic_calculator/widgets/icon_page_indicator.dart';
import 'package:neumorphic_calculator/widgets/info_dialog.dart';

class CalculatorAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CalculatorAppBar({super.key});

  @override
  State<CalculatorAppBar> createState() => _CalculatorAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CalculatorAppBarState extends State<CalculatorAppBar> {
  ThemeController get themeCtrl => ThemeController.instance;

  DashboardController get dashboardCtrl => DashboardController.instance;

  HistoryController get historyCtrl => HistoryController.instance;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).isDarkMode;
    final onHistoryPage = dashboardCtrl.index == 2;
    return Container(
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GetBuilder<SettingsController>(builder: (ctrl) {
            return IconPageIndicator(
              controller: dashboardCtrl.pageController,
              icons: [
                LucideIcons.wrench,
                LucideIcons.calculator,
                LucideIcons.history,
              ],
              buttonRadius: ctrl.state?.buttonRadius,
            );
          }),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: IconButton(
              key: ValueKey<bool>(onHistoryPage),
              padding: const EdgeInsets.all(16.0),
              icon: onHistoryPage
                  ? const Icon(
                      LucideIcons.trash2,
                      color: Colors.red,
                    )
                  : const Icon(LucideIcons.info),
              onPressed: onHistoryPage
                  ? () {
                      if (historyCtrl.status.isEmpty) return;
                      ConfirmDialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Clear History'),
                              Lottie.asset(
                                !isDark
                                    ? AppConst.deleteDark
                                    : AppConst.deleteLight,
                                height: 50,
                                width: 50,
                                repeat: false,
                              ),
                            ],
                          ),
                          content:
                              'Are you sure you want to clear the history?',
                          confirmText: 'Clear',
                          onConfirm: () {
                            historyCtrl.isClearing.value = true;
                            historyCtrl.update();
                          }).show(context);
                    }
                  : () {
                      const InfoDialog().show(context);
                    },
            ),
          )
        ],
      ),
    );
  }
}
