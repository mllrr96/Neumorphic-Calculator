import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:day_night_themed_switch/day_night_themed_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:neumorphic_calculator/custom_ink_response.dart';
import 'package:neumorphic_calculator/extension.dart';
import 'package:neumorphic_calculator/settings_screen.dart';
import 'button.dart';
import 'enum.dart';
import 'result_widget.dart';
import 'input_widget.dart';
import 'theme.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  CalculatorScreenState createState() => CalculatorScreenState();
}

class CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController controller = TextEditingController();
  String get input => controller.text;
  String result = '';
  Parser p = Parser();

  bool darkMode = false;
  bool splash = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
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
                        builder: (context) => DayNightSwitch(
                          value: darkMode,
                          onChanged: (val) {
                            darkMode = val;
                            ThemeSwitcher.of(context).changeTheme(
                                theme: darkMode ? Themes.dark : Themes.light,
                                isReversed: !darkMode);
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      padding: const EdgeInsets.all(16),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingsScreen()));
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
                    child: SplashContainer(
                      splash: splash,
                      // containedInkWell: true,
                      splashColor: Colors.orange.withOpacity(0.5),
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
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: CalculatorButton.values.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 14.0,
                              mainAxisSpacing: 14.0,
                              crossAxisCount: 4),
                      itemBuilder: (context, index) {
                        return NeumorphicCustomButton(
                          onPressed: () {
                            CalculatorButton button =
                                CalculatorButton.values[index];
                            if (button.isNumber) {
                              if (controller.noSelection) {
                                controller.text += button.value;
                              } else {
                                controller.addTextToOffset(button.value);
                              }
                              if (input.canCalculate) {
                                result = input.calculate(parser: p);
                              }
                              HapticFeedback.mediumImpact();
                            } else {
                              switch (button) {
                                case CalculatorButton.negative:
                                  HapticFeedback.mediumImpact();
                                  break;
                                case CalculatorButton.clear:
                                  if (input.isNotEmpty &&
                                      controller.noSelection) {
                                    controller.removeLastCharacter();
                                    if (input.canCalculate) {
                                      result = input.calculate(
                                          parser: p, skipErrorChecking: true);
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
                                  if (input.isNotEmpty && result.isNotEmpty) {
                                    setState(() => splash = !splash);
                                  }
                                  // TODO: Add all clear animation to flush the screen
                                  controller.text = '';
                                  result = '';
                                  HapticFeedback.heavyImpact();
                                  break;
                                case CalculatorButton.equal:
                                  if (input.isNotEmpty) {
                                    result = input.calculate(parser: p);
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
                                    result = input.calculate(parser: p);
                                  }
                                  HapticFeedback.mediumImpact();
                              }
                            }
                            setState(() {});
                          },
                          width: 40,
                          height: 40,
                          child: Center(
                            child: CalculatorButton.values[index] ==
                                    CalculatorButton.clear
                                ? Icon(Icons.backspace_outlined,
                                    size: 24, color: primaryColor)
                                : Text(
                                    CalculatorButton.values[index].value,
                                    style: TextStyle(
                                        color: CalculatorButton
                                                    .values[index].isNumber ||
                                                CalculatorButton
                                                        .values[index] ==
                                                    CalculatorButton.decimal
                                            ? Theme.of(context).iconTheme.color
                                            : primaryColor,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        );
                      },
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
