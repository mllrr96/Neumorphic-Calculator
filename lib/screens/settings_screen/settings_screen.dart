import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neumorphic_calculator/screens/settings_screen/settings_controller.dart';
import 'package:neumorphic_calculator/service/theme_controller.dart';
import 'package:neumorphic_calculator/utils/enum.dart';
import 'package:neumorphic_calculator/utils/extensions/color_extension.dart';
import 'package:neumorphic_calculator/utils/extensions/extensions.dart';
import 'package:neumorphic_calculator/utils/extensions/theme_extension.dart';
import 'package:neumorphic_calculator/utils/settings_model.dart';
import 'package:neumorphic_calculator/widgets/button_radius_dialog.dart';
import 'package:neumorphic_calculator/widgets/made_by.dart';
import 'package:neumorphic_calculator/widgets/neumorphic_button.dart';
import 'package:system_theme/system_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool splash = false;

  ThemeController get themeCtrl => ThemeController.instance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.isDarkMode;
    final titleTextStyle = theme.textTheme.headlineSmall?.copyWith(
      color: isDark ? Colors.white : Colors.black,
    );

    final isDynamicColorAvailable =
        SystemTheme.accentColor.accent != SystemTheme.fallbackColor &&
            defaultTargetPlatform.supportsAccentColor;
    return GetBuilder<SettingsController>(builder: (settingsCtrl) {
      final settings = settingsCtrl.state ?? SettingsModel.normal();
      return Scaffold(
        bottomNavigationBar: const BottomAppBar(
          padding: EdgeInsets.zero,
          child: MadeByWidget(),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          children: [
            SizedBox(
              height: 75,
              child: ListView.separated(
                  key: const PageStorageKey('themeColor'),
                  shrinkWrap: true,
                  clipBehavior: Clip.none,
                  padding: EdgeInsets.zero,
                  itemCount: ThemeColor.values.length + 1,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (_, index) {
                    if (index == 0 && !isDynamicColorAvailable) {
                      return const SizedBox.shrink();
                    }
                    if (index == 0 && isDynamicColorAvailable) {
                      return const VerticalDivider(
                        indent: 10,
                        endIndent: 10,
                        thickness: 3,
                      );
                    }
                    return const SizedBox(width: 12.0);
                  },
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      if (!isDynamicColorAvailable) {
                        return const SizedBox.shrink();
                      }
                      return NeumorphicButton(
                        borderRadius: settings.buttonRadius,
                        onPressed: () {
                          final accentColor = SystemTheme.accentColor.accent
                              .withValues(alpha: 1);
                          settingsCtrl.updateSettings(
                              settings.copyWith(dynamicColor: true));
                          final light =
                              accentColor.getTheme(settings.font.textTheme);
                          final dark = accentColor.getTheme(
                              settings.font.textTheme,
                              brightness: Brightness.dark);
                          ThemeController.instance.updateTheme(light, dark);
                          SettingsController.instance.updateSettings(
                              settings.copyWith(dynamicColor: true));
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: SystemTheme.accentColor.accent
                                .withValues(alpha: 1),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: settings.dynamicColor
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                      );
                    }
                    final themeColor = ThemeColor.values[index - 1];
                    return NeumorphicButton(
                      borderRadius: settings.buttonRadius,
                      onPressed: () {
                        settingsCtrl.updateSettings(settings.copyWith(
                            themeColor: themeColor, dynamicColor: false));

                        final light =
                            themeColor.color.getTheme(settings.font.textTheme);
                        final dark = themeColor.color.getTheme(
                            settings.font.textTheme,
                            brightness: Brightness.dark);
                        ThemeController.instance.updateTheme(light, dark);
                        SettingsController.instance
                            .updateSettings(settings.copyWith(
                          themeColor: themeColor,
                          dynamicColor: false,
                        ));
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: themeColor.color,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: settings.themeColor == themeColor &&
                                !settings.dynamicColor
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    );
                  }),
            ),
            const SizedBox(height: 18.0),
            GetBuilder<ThemeController>(builder: (_) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NeumorphicButton(
                    borderRadius: settings.buttonRadius,
                    onPressed: () async {
                      themeCtrl.saveThemeMode(ThemeMode.system);
                    },
                    child: Icon(
                      Icons.brightness_auto,
                      size: 28,
                      color: themeCtrl.themeMode == ThemeMode.system
                          ? theme.colorScheme.primary
                          : isDark
                              ? Colors.white
                              : Colors.black54,
                    ),
                  ),
                  NeumorphicButton(
                    borderRadius: settings.buttonRadius,
                    onPressed: () {
                      themeCtrl.saveThemeMode(ThemeMode.light);
                    },
                    child: Icon(
                      Icons.light_mode,
                      size: 28,
                      color: themeCtrl.themeMode == ThemeMode.light
                          ? theme.colorScheme.primary
                          : isDark
                              ? Colors.white
                              : Colors.black54,
                    ),
                  ),
                  NeumorphicButton(
                    borderRadius: settings.buttonRadius,
                    onPressed: () {
                      themeCtrl.saveThemeMode(ThemeMode.dark);

                      // context.updateThemeMode(
                      //   themeMode: ThemeMode.dark,
                      //   isReversed: true,
                      // );
                    },
                    child: Icon(
                      Icons.dark_mode,
                      size: 28,
                      color: themeCtrl.themeMode == ThemeMode.dark
                          ? theme.colorScheme.primary
                          : isDark
                              ? Colors.white
                              : Colors.black54,
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 18.0),
            NeumorphicButton(
              borderRadius: settings.buttonRadius,
              child: ListTile(
                title: const Text('Font'),
                trailing: Text(theme.textTheme.bodyLarge?.fontFamily ?? ''),
              ),
              onPressed: () {
                showAdaptiveDialog<Fonts>(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: const Text('Select Font'),
                        titleTextStyle: titleTextStyle,
                        children: Fonts.values.map((font) {
                          final theme = isDark
                              ? font.setToTheme(themeCtrl.darkTheme)
                              : font.setToTheme(themeCtrl.lightTheme);
                          return Theme(
                            data: theme,
                            child: ListTile(
                              trailing: settings.font == font
                                  ? const Icon(Icons.check)
                                  : null,
                              onTap: () {
                                if (font == settings.font) {
                                  return Navigator.pop(context);
                                }
                                ThemeController.instance.updateTheme(
                                    font.setToTheme(themeCtrl.lightTheme),
                                    font.setToTheme(themeCtrl.darkTheme));
                                SettingsController.instance.updateSettings(
                                    settings.copyWith(font: font));
                                Navigator.pop(context);
                              },
                              title: Text(font.name.capitalize ?? font.name),
                              subtitle:
                                  const Text('This is demo text 1234567890'),
                            ),
                          );
                        }).toList(),
                      );
                    });
              },
            ),
            const SizedBox(height: 18.0),
            NeumorphicButton(
              borderRadius: settings.buttonRadius,
              child: ListTile(
                title: const Text('Button Radius'),
                trailing: Text(settings.buttonRadius.toString()),
              ),
              onPressed: () async {
                await ButtonRadiusDialog(buttonRadius: settings.buttonRadius)
                    .show(context)
                    .then(
                  (result) {
                    if (result is double) {
                      settingsCtrl.updateSettings(
                          settings.copyWith(buttonRadius: result));
                      // ThemeController.instance.update();
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 18.0),
            NeumorphicButton(
              borderRadius: settings.buttonRadius,
              child: ListTile(
                title: const Text('Haptic Feedback'),
                trailing: Switch(
                  value: settings.hapticEnabled,
                  onChanged: (value) {
                    if (value) {
                      HapticFeedback.mediumImpact();
                    }
                    settingsCtrl.updateSettings(
                        settings.copyWith(hapticEnabled: value));
                  },
                ),
              ),
              onPressed: () {
                if (!settings.hapticEnabled) {
                  HapticFeedback.mediumImpact();
                }
                settingsCtrl.updateSettings(
                    settings.copyWith(hapticEnabled: !settings.hapticEnabled));
              },
            )
          ],
        ),
      );
    });
  }
}
