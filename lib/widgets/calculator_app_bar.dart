import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:day_night_themed_switch/day_night_themed_switch.dart';
import 'package:flutter/material.dart';
import 'package:neumorphic_calculator/service/preference_service.dart';
import 'package:neumorphic_calculator/settings_screen.dart';

class CalculatorAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CalculatorAppBar({super.key, this.onButtonSizeChanged});
  final void Function()? onButtonSizeChanged;

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
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
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
                    PreferencesService.instance.saveThemeMode(
                        darkMode ? ThemeMode.dark : ThemeMode.light);
                    context.toggleThemeMode(
                      isReversed: darkMode,
                    );
                  },
                );
              },
            ),
          ),
          IconButton(
            padding: const EdgeInsets.all(16),
            onPressed: () async {
              await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsScreen()))
                  .then((result) async {
                // When result is true that means button radius has been changed
                // so we need to rebuild the widget
                if (result == true) {
                  await Future.delayed(const Duration(milliseconds: 300));
                  widget.onButtonSizeChanged?.call();
                }
              });
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
