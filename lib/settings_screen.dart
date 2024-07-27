import 'package:flutter/material.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neumorphic_calculator/bloc/preference_cubit/preference_cubit.dart';
import 'package:neumorphic_calculator/service/theme_service.dart';
import 'package:neumorphic_calculator/utils/extensions/extensions.dart';
import 'package:neumorphic_calculator/widgets/button_radius_dialog.dart';
import 'bloc/preference_cubit/preference_state.dart';
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

  ThemeService get themeService => ThemeService.instance;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferenceCubit, PreferenceState>(
      builder: (context, state) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final titleTextStyle =
            Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: isDark ? Colors.white : Colors.black,
                );
        final settings = state.settings;
        return ThemeSwitchingArea(
          child: Scaffold(
              appBar: AppBar(title: const Text('Settings')),
              bottomNavigationBar: const BottomAppBar(
                padding: EdgeInsets.zero,
                child: MadeBy(),
              ),
              body: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                children: [
                  NeumorphicButton(
                    borderRadius: settings.buttonRadius,
                    onPressed: null,
                    child: ThemeSwitcher(builder: (context) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SegmentedButton<ThemeType>(
                          segments: ThemeType.values.map((e) {
                            return ButtonSegment<ThemeType>(
                              value: e,
                              label: Text(
                                  e.toString().split('.').last.capitilize,
                                  style: TextStyle(
                                      color: e == ThemeType.blue
                                          ? Colors.blue
                                          : Colors.pink)),
                            );
                          }).toList(),
                          selected: {themeService.themeType},
                          onSelectionChanged: (value) {
                            final font = settings.font;
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
                            themeService.saveTheme(value.first);
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 18.0),
                  NeumorphicButton(
                    borderRadius: settings.buttonRadius,
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
                          selected: {themeService.themeMode},
                          onSelectionChanged: (value) {
                            themeService.saveThemeMode(value.first);
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
                    borderRadius: settings.buttonRadius,
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
                                titleTextStyle: titleTextStyle,
                                children: Fonts.values.map((font) {
                                  final theme = isDark
                                      ? font.setToTheme(themeService.darkTheme)
                                      : font
                                          .setToTheme(themeService.lightTheme);
                                  return Theme(
                                    data: theme,
                                    child: ListTile(
                                      onTap: () {
                                        if (font == settings.font) {
                                          return Navigator.pop(context);
                                        }
                                        context.updateTheme(
                                            lightTheme: font.setToTheme(
                                                themeService.lightTheme),
                                            darkTheme: font.setToTheme(
                                                themeService.darkTheme));
                                        context
                                            .read<PreferenceCubit>()
                                            .updateSettings(
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
                    borderRadius: settings.buttonRadius,
                    child: ListTile(
                      title: const Text('Button Radius'),
                      trailing: Text(settings.buttonRadius.toString()),
                      onTap: () async {
                        await ButtonRadiusDialog(
                                buttonRadius: settings.buttonRadius)
                            .show(context)
                            .then(
                          (result) {
                            if (result is double) {
                              context.read<PreferenceCubit>().updateSettings(
                                  settings.copyWith(buttonRadius: result));
                            }
                          },
                        );
                      },
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 18.0),
                  SplashEffect(
                    splash: splash,
                    child: NeumorphicButton(
                      borderRadius: settings.buttonRadius,
                      onPressed: null,
                      onLongPress: () => setState(() => splash = !splash),
                      child: SwitchListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(settings.buttonRadius)),
                        value: settings.splashEnabled,
                        onChanged: (val) {
                          context.read<PreferenceCubit>().updateSettings(
                              settings.copyWith(splashEnabled: val));
                        },
                        title: const Text('Splash Effect on AC'),
                        subtitle: const Text('Long tap here for demo'),
                      ),
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}
