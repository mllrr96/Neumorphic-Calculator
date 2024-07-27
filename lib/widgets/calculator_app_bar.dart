import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:day_night_themed_switch/day_night_themed_switch.dart';
import 'package:flutter/material.dart';
import 'package:neumorphic_calculator/service/preference_service.dart';
import 'package:neumorphic_calculator/service/theme_service.dart';
import 'package:neumorphic_calculator/utils/extensions/extensions.dart';
import 'package:neumorphic_calculator/widgets/info_dialog.dart';

class CalculatorAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CalculatorAppBar({super.key});

  @override
  State<CalculatorAppBar> createState() => _CalculatorAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CalculatorAppBarState extends State<CalculatorAppBar> {
  ThemeService get themeService => ThemeService.instance;
  bool darkMode = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ThemeSwitcher(
            builder: (context) {
              darkMode = themeService.themeMode == ThemeMode.system &&
                      Theme.of(context).brightness == Brightness.dark
                  ? true
                  : themeService.themeMode == ThemeMode.dark;
              return SizedBox(
                width: 80,
                child: DayNightSwitch(
                  value: darkMode,
                  onChanged: (val) {
                    darkMode = val;
                    themeService.saveThemeMode(
                        darkMode ? ThemeMode.dark : ThemeMode.light);
                    context.toggleThemeMode(
                      isReversed: darkMode,
                    );
                  },
                ),
              );
            },
          ),
          if (!PreferencesService.isFirstRun)
            IconButton(
              padding: const EdgeInsets.all(16.0),
              icon: const Icon(Icons.info_outline),
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
