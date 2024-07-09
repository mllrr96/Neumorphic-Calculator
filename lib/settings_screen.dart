import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neumorphic_calculator/service/preference_service.dart';
import 'package:neumorphic_calculator/utils/const.dart';
import 'package:neumorphic_calculator/utils/extensions/string_extension.dart';
import 'package:neumorphic_calculator/utils/settings_model.dart';
import 'package:simple_icons/simple_icons.dart';
import 'utils/enum.dart';
import 'widgets/neumorphic_button.dart';
import 'widgets/splash_effect.dart';
import 'package:url_launcher/url_launcher.dart';

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
    settings = preferencesService.settingsModel;

    super.initState();
  }

  PreferencesService get preferencesService => PreferencesService.instance;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final contentTextStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: isDark ? Colors.white : Colors.black,
        );
    return ThemeSwitchingArea(
      child: PopScope(
        canPop: settings == preferencesService.settingsModel,
        onPopInvoked: _onPopInvoked,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Settings'),
              centerTitle: true,
            ),
            bottomNavigationBar: BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '@2024 Neumorphic Calculator',
                        style: contentTextStyle?.copyWith(color: Colors.grey),
                      ),
                      Text(
                        'Made with ❤️ by Mohammed Ragheb',
                        style: contentTextStyle,
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () async {
                      try {
                        await launchUrl(Uri.parse(AppConst.githubLink));
                      } catch (_) {}
                    },
                    icon: Icon(
                      SimpleIcons.github,
                      color: isDark ? Colors.white : SimpleIconColors.github,
                      size: 40,
                    ),
                  )
                ],
              ),
            ),
            floatingActionButton: settings != preferencesService.settingsModel
                ? FloatingActionButton.extended(
                    onPressed: () {
                      final result = PreferencesService
                              .instance.settingsModel.buttonRadius !=
                          settings.buttonRadius;
                      preferencesService.updateSettings(settings);

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
                        selected: {preferencesService.themeType},
                        onSelectionChanged: (value) {
                          final font = preferencesService.settingsModel.font;
                          ThemeData lightTheme = value.first.themeData.$1;
                          ThemeData darkTheme = value.first.themeData.$2;
                          if (font != Fonts.cabin) {
                            lightTheme = font.setToTheme(lightTheme);
                            darkTheme = font.setToTheme(darkTheme);
                          }
                          context.updateTheme(
                            lightTheme: lightTheme,
                            darkTheme: darkTheme,
                          );
                          preferencesService.saveTheme(value.first);
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
                        selected: {preferencesService.themeMode},
                        onSelectionChanged: (value) {
                          preferencesService.saveThemeMode(value.first);
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
                                    ? e.setToTheme(preferencesService.darkTheme)
                                    : e.setToTheme(
                                        preferencesService.lightTheme);
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
                                      preferencesService.updateSettings(
                                          settings.copyWith(font: e));
                                      Navigator.pop(context);
                                    },
                                    title: Text(e.name.capitilize),
                                    subtitle: const Text(
                                        'This is demo text 1234567890'),
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
                    title: const Text('Haptic feedback'),
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

  void _onPopInvoked(bool value) {
    if (value) return;
    // show dialog
    showDialog(
        context: context,
        builder: (context) {
          return DiscardDialog(onDiscard: () {
            settings = preferencesService.settingsModel;
          });
        });
  }
}

class DiscardDialog extends StatelessWidget {
  const DiscardDialog({super.key, required this.onDiscard});
  final void Function() onDiscard;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // When showing dialog in dark mode the text remians black, this is a workaround
    final titleTextStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: isDark ? Colors.white : Colors.black,
        );
    final contentTextStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: isDark ? Colors.white : Colors.black,
        );
    return AlertDialog(
      title: const Text('Discard Changes?'),
      titleTextStyle: titleTextStyle,
      contentTextStyle: contentTextStyle,
      content: const Text('Are you sure you want to discard changes?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onDiscard();
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: const Text('Discard'),
        ),
      ],
    );
  }
}
