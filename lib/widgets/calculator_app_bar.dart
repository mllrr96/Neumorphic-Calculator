import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:day_night_themed_switch/day_night_themed_switch.dart';
import 'package:flutter/material.dart';
import 'package:neumorphic_calculator/service/preference_service.dart';

final settingsIconKey = GlobalKey();

class CalculatorAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CalculatorAppBar({super.key});

  @override
  State<CalculatorAppBar> createState() => _CalculatorAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CalculatorAppBarState extends State<CalculatorAppBar> {
  PreferencesService get referencesService => PreferencesService.instance;
  bool darkMode = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: 80,
        child: ThemeSwitcher(
          builder: (context) {
            darkMode = referencesService.themeMode == ThemeMode.system &&
                    Theme.of(context).brightness == Brightness.dark
                ? true
                : PreferencesService.instance.themeMode == ThemeMode.dark;
            return DayNightSwitch(
              value: darkMode,
              onChanged: (val) {
                darkMode = val;
                PreferencesService.instance
                    .saveThemeMode(darkMode ? ThemeMode.dark : ThemeMode.light);
                context.toggleThemeMode(
                  isReversed: darkMode,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
