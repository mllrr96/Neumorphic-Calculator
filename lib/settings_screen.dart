import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neumorphic_calculator/service/preference_service.dart';
import 'package:neumorphic_calculator/utils/extension.dart';
import 'package:neumorphic_calculator/utils/settings_model.dart';
import 'package:neumorphic_calculator/utils/theme.dart';
import 'widgets/button.dart';
import 'widgets/splash_effect.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool splash = false;

  late SettingsModel settings;
  @override
  void initState() {
    settings = PreferencesService.instance.settingsModel;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ThemeSwitchingArea(
      child: PopScope(
        canPop: settings == PreferencesService.instance.settingsModel,
        onPopInvoked: (value) {
          if (value) return;
          // show dialog
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Discard Changes?'),
                  content:
                      const Text('Are you sure you want to discard changes?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        settings = PreferencesService.instance.settingsModel;
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Discard'),
                    ),
                  ],
                );
              });
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Settings'),
              centerTitle: true,
            ),
            floatingActionButton:
                settings != PreferencesService.instance.settingsModel
                    ? FloatingActionButton.extended(
                        onPressed: () {
                          final result = PreferencesService
                                  .instance.settingsModel.buttonRadius !=
                              settings.buttonRadius;
                          PreferencesService.instance.updateSettings(settings);

                          Navigator.pop(context, result);
                        },
                        icon: const Icon(Icons.save),
                        label: const Text('Save'),
                      )
                    : null,
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
              children: [
                NeumorphicButton(
                  borderRadius: BorderRadius.circular(settings.buttonRadius),
                  onPressed: null,
                  child: ThemeSwitcher(builder: (context) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SegmentedButton<ThemeType>(
                        segments: ThemeType.values.map((e) {
                          return ButtonSegment<ThemeType>(
                            value: e,
                            label: Text(e.toString().split('.').last.capitilize,
                                style: TextStyle(
                                    color: e == ThemeType.blue
                                        ? Colors.blue
                                        : Colors.pink)),
                          );
                        }).toList(),
                        selected: {PreferencesService.instance.themeType},
                        onSelectionChanged: (value) {
                          final font =
                              PreferencesService.instance.settingsModel.font;
                          ThemeData lightTheme = value.first.themeData.$1;
                          ThemeData darkTheme = value.first.themeData.$2;
                          if (font != Fonts.cairo) {
                            lightTheme = font.setToTheme(lightTheme);
                            darkTheme = font.setToTheme(darkTheme);
                          }
                          context.updateTheme(
                            lightTheme: lightTheme,
                            darkTheme: darkTheme,
                          );
                          PreferencesService.instance.saveTheme(value.first);
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 18.0),
                NeumorphicButton(
                  borderRadius: BorderRadius.circular(settings.buttonRadius),
                  onPressed: null,
                  child: ThemeSwitcher(builder: (context) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SegmentedButton<ThemeMode>(
                        segments: ThemeMode.values.map((e) {
                          return ButtonSegment<ThemeMode>(
                            value: e,
                            label: Text(
                              e.toString().split('.').last.capitilize,
                            ),
                          );
                        }).toList(),
                        selected: {PreferencesService.instance.themeMode},
                        onSelectionChanged: (value) {
                          PreferencesService.instance
                              .saveThemeMode(value.first);
                          final avoidAnimation =
                              value.first == ThemeMode.system &&
                                  MediaQuery.of(context).platformBrightness ==
                                      Theme.of(context).brightness;
                          context.updateThemeMode(
                              animateTransition: !avoidAnimation,
                              themeMode: value.first,
                              isReversed: value.first == ThemeMode.dark ||
                                  value.first == ThemeMode.system &&
                                      MediaQuery.of(context)
                                              .platformBrightness ==
                                          Brightness.dark);
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 18.0),
                NeumorphicButton(
                  borderRadius: BorderRadius.circular(settings.buttonRadius),
                  child: ListTile(
                    title: const Text('Font'),
                    trailing: Text(
                        Theme.of(context).textTheme.bodyLarge?.fontFamily ??
                            ''),
                  ),
                  onPressed: () {
                    showAdaptiveDialog<Fonts>(
                        context: context,
                        builder: (context) {
                          return ThemeSwitcher(builder: (context) {
                            return SimpleDialog(
                              title: const Text('Select Font'),
                              children: Fonts.values.map((e) {
                                final theme = isDark
                                    ? e.setToTheme(
                                        PreferencesService.instance.darkTheme)
                                    : e.setToTheme(
                                        PreferencesService.instance.lightTheme);
                                return Theme(
                                  data: theme,
                                  child: ListTile(
                                    onTap: () {
                                      final settings = PreferencesService
                                          .instance.settingsModel;
                                      if (e == settings.font) {
                                        return Navigator.pop(context);
                                      }
                                      context.updateTheme(
                                          lightTheme: e.setToTheme(
                                              PreferencesService
                                                  .instance.lightTheme),
                                          darkTheme: e.setToTheme(
                                              PreferencesService
                                                  .instance.darkTheme));
                                      PreferencesService.instance
                                          .updateSettings(
                                              settings.copyWith(font: e));
                                      Navigator.pop(context);
                                    },
                                    title: Text(e.name.capitilize),
                                    subtitle:
                                        Text('This is demo text 1234567890'),
                                  ),
                                );
                              }).toList(),
                            );
                          });
                        });
                    // Navigator.pushNamed(context, '/theme');
                  },
                ),
                const SizedBox(height: 18.0),
                NeumorphicButton(
                  borderRadius: BorderRadius.circular(settings.buttonRadius),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text('Button Radius'),
                        const Spacer(),
                        Slider(
                            divisions: 20,
                            label: settings.buttonRadius.toString(),
                            value: settings.buttonRadius,
                            onChanged: (val) {
                              setState(() {
                                settings = settings.copyWith(buttonRadius: val);
                              });
                            },
                            max: 25,
                            min: 5)
                      ],
                    ),
                  ),
                  onPressed: () {
                    // Navigator.pushNamed(context, '/theme');
                  },
                ),
                const SizedBox(height: 18.0),
                NeumorphicButton(
                  borderRadius: BorderRadius.circular(settings.buttonRadius),
                  child: SwitchListTile(
                    value: settings.hapticEnabled,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(settings.buttonRadius)),
                    onChanged: (val) {
                      if (val) {
                        HapticFeedback.mediumImpact();
                      }
                      setState(() {
                        settings = settings.copyWith(hapticEnabled: val);
                      });
                    },
                    title: const Text('Vibrate on Tap'),
                  ),
                  onPressed: () {
                    // Navigator.pushNamed(context, '/theme');
                  },
                ),
                const SizedBox(height: 18.0),
                SplashEffect(
                  splash: splash,
                  child: NeumorphicButton(
                    borderRadius: BorderRadius.circular(settings.buttonRadius),
                    onPressed: null,
                    onLongPress: () => setState(() => splash = !splash),
                    child: SwitchListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(settings.buttonRadius)),
                      value: settings.splashEnabled,
                      onChanged: (val) => setState(
                        () => settings = settings.copyWith(splashEnabled: val),
                      ),
                      title: const Text('Splash Effect on AC'),
                      subtitle: const Text('Long tap here for demo'),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
