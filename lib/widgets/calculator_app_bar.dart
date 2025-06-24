import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:neumorphic_calculator/screens/dashboard_screen/dashboard_controller.dart';
import 'package:neumorphic_calculator/screens/settings_screen/settings_controller.dart';
import 'package:neumorphic_calculator/service/theme_controller.dart';
import 'package:neumorphic_calculator/utils/extensions/extensions.dart';
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
  ThemeController get themeService => ThemeController.instance;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GetBuilder<SettingsController>(builder: (ctrl) {
            return IconPageIndicator(
              controller: DashboardController.instance.pageController,
              icons: [
                LucideIcons.wrench,
                LucideIcons.calculator,
                LucideIcons.history,
              ],
              buttonRadius: ctrl.state?.buttonRadius,
            );
          }),
          IconButton(
            padding: const EdgeInsets.all(16.0),
            icon: const Icon(LucideIcons.info),
            onPressed: () {
              // showInfoDialog(context);
              const InfoDialog().show(context);
            },
          ),
        ],
      ),
    );
  }
}
