import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neumorphic_calculator/bloc/preference_cubit/preference_cubit.dart';
import 'package:neumorphic_calculator/service/theme_service.dart';
import 'package:neumorphic_calculator/utils/extensions/color_extension.dart';
import 'package:neumorphic_calculator/utils/extensions/extensions.dart';
import 'package:neumorphic_calculator/widgets/button_radius_dialog.dart';
import 'package:system_theme/system_theme.dart';
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
        final isDynamicColorAvailable =
            SystemTheme.accentColor.accent != SystemTheme.fallbackColor &&
                defaultTargetPlatform.supportsAccentColor;
        return ThemeSwitchingArea(
          child: Scaffold(
              appBar: AppBar(
                systemOverlayStyle:
                    Theme.of(context).appBarTheme.systemOverlayStyle?.copyWith(
                          systemNavigationBarColor:
                              Theme.of(context).scaffoldBackgroundColor,
                        ),
                title: const Text('Settings'),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),
              bottomNavigationBar: const BottomAppBar(
                padding: EdgeInsets.zero,
                child: MadeBy(),
              ),
              body: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                children: [
                  ThemeSwitcher(builder: (context) {
                    return SizedBox(
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
                                  final accentColor = SystemTheme
                                      .accentColor.accent
                                      .withOpacity(1);
                                  context
                                      .read<PreferenceCubit>()
                                      .updateSettings(settings.copyWith(
                                          dynamicColor: true));
                                  final light = accentColor
                                      .getTheme(settings.font.textTheme);
                                  final dark = accentColor.getTheme(
                                      settings.font.textTheme,
                                      brightness: Brightness.dark);
                                  context.updateTheme(
                                      lightTheme: light, darkTheme: dark);
                                  ThemeService.instance.loadTheme(accentColor);
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: SystemTheme.accentColor.accent
                                        .withOpacity(1),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: settings.dynamicColor
                                      ? const Icon(Icons.check,
                                          color: Colors.white)
                                      : null,
                                ),
                              );
                            }
                            final themeColor = ThemeColor.values[index - 1];
                            return NeumorphicButton(
                              borderRadius: settings.buttonRadius,
                              onPressed: () {
                                context.read<PreferenceCubit>().updateSettings(
                                    settings.copyWith(
                                        themeColor: themeColor,
                                        dynamicColor: false));

                                final light = themeColor.color
                                    .getTheme(settings.font.textTheme);
                                final dark = themeColor.color.getTheme(
                                    settings.font.textTheme,
                                    brightness: Brightness.dark);
                                context.updateTheme(
                                    lightTheme: light, darkTheme: dark);
                                ThemeService.instance
                                    .loadTheme(themeColor.color);
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
                                    ? const Icon(Icons.check,
                                        color: Colors.white)
                                    : null,
                              ),
                            );
                          }),
                    );
                  }),
                  const SizedBox(height: 18.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ThemeSwitcher(builder: (context) {
                        return NeumorphicButton(
                          borderRadius: settings.buttonRadius,
                          onPressed: () async {
                            final avoidTransition =
                                MediaQuery.of(context).platformBrightness !=
                                    Theme.of(context).brightness;
                            themeService.saveThemeMode(ThemeMode.system);
                            context.updateThemeMode(
                                animateTransition: avoidTransition,
                                themeMode: ThemeMode.system,
                                isReversed:
                                    MediaQuery.of(context).platformBrightness ==
                                        Brightness.dark);
                            // Calling setState to update the UI,
                            // as the theme is not changing but theme mode is
                            if (!avoidTransition) {
                              setState(() {});
                            }
                          },
                          child: Icon(
                            Icons.brightness_auto,
                            size: 28,
                            color: themeService.themeMode == ThemeMode.system
                                ? Theme.of(context).colorScheme.primary
                                : isDark
                                    ? Colors.white
                                    : Colors.black54,
                          ),
                        );
                      }),
                      ThemeSwitcher(builder: (context) {
                        return NeumorphicButton(
                          borderRadius: settings.buttonRadius,
                          onPressed: () {
                            themeService.saveThemeMode(ThemeMode.light);
                            context.updateThemeMode(
                              themeMode: ThemeMode.light,
                            );
                          },
                          child: Icon(
                            Icons.light_mode,
                            size: 28,
                            color: themeService.themeMode == ThemeMode.light
                                ? Theme.of(context).colorScheme.primary
                                : isDark
                                    ? Colors.white
                                    : Colors.black54,
                          ),
                        );
                      }),
                      ThemeSwitcher(builder: (context) {
                        return NeumorphicButton(
                          borderRadius: settings.buttonRadius,
                          onPressed: () {
                            themeService.saveThemeMode(ThemeMode.dark);

                            context.updateThemeMode(
                              themeMode: ThemeMode.dark,
                              isReversed: true,
                            );
                          },
                          child: Icon(
                            Icons.dark_mode,
                            size: 28,
                            color: themeService.themeMode == ThemeMode.dark
                                ? Theme.of(context).colorScheme.primary
                                : isDark
                                    ? Colors.white
                                    : Colors.black54,
                          ),
                        );
                      }),
                    ],
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
                                      trailing: settings.font == font
                                          ? const Icon(Icons.check)
                                          : null,
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
