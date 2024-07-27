import 'package:flutter/material.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:neumorphic_calculator/service/preference_service.dart';
import 'package:neumorphic_calculator/utils/extensions/extensions.dart';
import 'package:neumorphic_calculator/utils/settings_model.dart';
import 'utils/enum.dart';
import 'widgets/made_by.dart';
import 'widgets/neumorphic_button.dart';
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
    settings = preferencesService.settingsModel;
    super.initState();
  }

  @override
  void dispose() {
    updateSettings();
    super.dispose();
  }

  // TODO: fix button radius not changing in calculator screen
  void updateSettings() {
    if (settings.buttonRadius !=
        preferencesService.settingsModel.buttonRadius) {
      preferencesService.updateSettings(settings);
    }
  }

  PreferencesService get preferencesService => PreferencesService.instance;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final contentTextStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: isDark ? Colors.white : Colors.black,
        );
    final titleTextStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: isDark ? Colors.white : Colors.black,
        );
    return ThemeSwitchingArea(
      child: Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          bottomNavigationBar: const BottomAppBar(
            padding: EdgeInsets.zero,
            child: MadeBy(),
          ),
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
                                    MediaQuery.of(context).platformBrightness ==
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
                      Theme.of(context).textTheme.bodyLarge?.fontFamily ?? ''),
                ),
                onPressed: () {
                  showAdaptiveDialog<Fonts>(
                      context: context,
                      builder: (context) {
                        return ThemeSwitcher(builder: (context) {
                          return SimpleDialog(
                            title: const Text('Select Font'),
                            titleTextStyle: titleTextStyle,
                            children: Fonts.values.map((font) {
                              final theme = isDark
                                  ? font
                                      .setToTheme(preferencesService.darkTheme)
                                  : font.setToTheme(
                                      preferencesService.lightTheme);
                              return Theme(
                                data: theme,
                                child: ListTile(
                                  onTap: () {
                                    final settings =
                                        preferencesService.settingsModel;
                                    if (font == settings.font) {
                                      return Navigator.pop(context);
                                    }
                                    context.updateTheme(
                                        lightTheme: font.setToTheme(
                                            preferencesService.lightTheme),
                                        darkTheme: font.setToTheme(
                                            preferencesService.darkTheme));
                                    preferencesService.updateSettings(
                                        settings.copyWith(font: font));
                                    Navigator.pop(context);
                                  },
                                  title: Text(font.name.capitilize),
                                  subtitle: const Text(
                                      'This is demo text 1234567890'),
                                ),
                              );
                            }).toList(),
                          );
                        });
                      });
                },
              ),
              const SizedBox(height: 18.0),
              NeumorphicButton(
                border: Border.all(
                    color: Theme.of(context).splashColor, width: 0.5),
                borderRadius: BorderRadius.circular(settings.buttonRadius),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  height: 56.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Button Radius', style: contentTextStyle),
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
                          min: 5),
                    ],
                  ),
                ),
                onPressed: () {},
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
    );
  }
}
