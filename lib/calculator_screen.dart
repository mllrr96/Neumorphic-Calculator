import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:day_night_themed_switch/day_night_themed_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:neumorphic_calculator/service/preference_service.dart';
import 'widgets/input_widget.dart';
import 'widgets/result_widget.dart';
import 'widgets/splash_effect.dart';
import 'utils/extension.dart';
import 'widgets/number_pad.dart';
import 'settings_screen.dart';
import 'utils/enum.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  CalculatorScreenState createState() => CalculatorScreenState();
}

class CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController controller = TextEditingController();
  String get input => controller.text;
  String result = '';
  Parser parser = Parser();

  bool darkMode = false;
  bool splash = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Builder(builder: (context) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: Theme.of(context).appBarTheme.systemOverlayStyle ??
              SystemUiOverlayStyle.light,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 80,
                      child: ThemeSwitcher(
                        builder: (context) {
                          darkMode = PreferencesService.instance.themeMode ==
                                      ThemeMode.system &&
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                              ? true
                              : PreferencesService.instance.themeMode ==
                                  ThemeMode.dark;
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
                                builder: (context) =>
                                    const SettingsScreen())).then((result) {
                          // When result is true that means button radius has been changed
                          // so we need to rebuild the widget
                          if (result == true) {
                            setState(() {});
                          }
                        });
                      },
                      icon: const Icon(Icons.settings),
                    ),
                  ],
                ),
              ),
            ),
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: SplashEffect(
                      borderRadius: BorderRadius.circular(12.0),
                      splash: splash,
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(flex: 2, child: InputWidget(controller)),
                            Expanded(child: ResultWidget(result)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Material(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: NumberPad(
                        onNumberPressed: (value) {
                          if (controller.noSelection) {
                            controller.text += value;
                          } else {
                            controller.addTextToOffset(value);
                          }
                          if (input.canCalculate) {
                            result = input.calculate(parser: parser);
                          }
                          HapticFeedback.mediumImpact();
                          setState(() {});
                        },
                        onOperationPressed: (button) {
                          switch (button) {
                            case CalculatorButton.negative:
                              HapticFeedback.mediumImpact();
                              break;
                            case CalculatorButton.clear:
                              if (input.isNotEmpty && controller.noSelection) {
                                controller.removeLastCharacter();
                                if (input.canCalculate) {
                                  result = input.calculate(
                                      parser: parser, skipErrorChecking: true);
                                } else {
                                  result = '';
                                }
                              } else {
                                controller.removeTextAtOffset();
                              }

                              if (input.isEmpty && result.isNotEmpty) {
                                result = '';
                              }
                              HapticFeedback.mediumImpact();
                              break;
                            case CalculatorButton.allClear:
                              if (input.isNotEmpty &&
                                  result.isNotEmpty &&
                                  PreferencesService
                                      .instance.settingsModel.splashEnabled) {
                                setState(() => splash = !splash);
                              }
                              controller.text = '';
                              result = '';
                              HapticFeedback.heavyImpact();
                              break;
                            case CalculatorButton.equal:
                              if (input.endsWith('x') ||
                                  input.endsWith('÷') ||
                                  input.endsWith('+') ||
                                  input.endsWith('-')) {
                                break;
                              }
                              if (input.isNotEmpty) {
                                result = input.calculate(parser: parser);
                                HapticFeedback.heavyImpact();
                              }
                              break;
                            case CalculatorButton.decimal:
                              if (input.isEmpty) {
                                controller.text += '0.';
                              } else if (controller.noSelection &&
                                  !input.endsWith('.')) {
                                controller.text += '.';
                              } else if (input.contains('.') &&
                                  controller.noSelection) {
                                return;
                              } else {
                                controller.addTextToOffset('.');
                              }
                              HapticFeedback.mediumImpact();
                              break;
                            default:
                              if ((input.endsWith('+') ||
                                      input.endsWith('-') ||
                                      input.endsWith('x') ||
                                      input.endsWith('÷') ||
                                      input.isEmpty) &&
                                  controller.noSelection) {
                                controller.removeLastCharacter();
                                controller.text += button.value;
                                HapticFeedback.mediumImpact();
                                return;
                              }

                              if (input.isEmpty || controller.noSelection) {
                                controller.text += button.value;
                              } else {
                                controller.addTextToOffset(button.value);
                              }
                              // recalculate result if possible in case of operator change
                              if (input.canCalculate) {
                                result = input.calculate(parser: parser);
                              }
                              HapticFeedback.mediumImpact();
                          }
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
