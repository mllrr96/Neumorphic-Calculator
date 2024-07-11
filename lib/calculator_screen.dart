import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:neumorphic_calculator/service/preference_service.dart';
import 'utils/extensions/extensions.dart';
import 'package:neumorphic_calculator/widgets/calculator_app_bar.dart';
import 'widgets/input_widget.dart';
import 'widgets/result_widget.dart';
import 'widgets/splash_effect.dart';
import 'widgets/number_pad.dart';
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

  void mediumHaptic() {
    if (preferencesService.settingsModel.hapticEnabled) {
      HapticFeedback.mediumImpact();
    }
  }

  void heavyHaptic() {
    if (preferencesService.settingsModel.hapticEnabled) {
      HapticFeedback.heavyImpact();
    }
  }

  PreferencesService get preferencesService => PreferencesService.instance;
  bool get splashEnabled => preferencesService.settingsModel.splashEnabled;

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Builder(builder: (context) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: Theme.of(context).appBarTheme.systemOverlayStyle ??
              SystemUiOverlayStyle.light,
          child: Scaffold(
            appBar: CalculatorAppBar(
              onButtonSizeChanged: () => setState(() {}),
            ),
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: SplashEffect(
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
                        onNumberPressed: (number) {
                          final val = controller.onNumberPressed(number,
                              parser: parser);
                          if (val != null) {
                            result = val.output.formatThousands();
                            setState(() {});
                          }
                          mediumHaptic();
                        },
                        onOperationPressed: (button) {
                          switch (button) {
                            case CalculatorButton.negative:
                              // TODO: Handle this case.
                              mediumHaptic();
                              break;
                            case CalculatorButton.clear:
                              final val = controller.onBackspacePressed(parser);
                              if (val != null) {
                                result = val.output.formatThousands();
                              }
                              mediumHaptic();
                              break;
                            case CalculatorButton.allClear:
                              if (input.isNotEmpty &&
                                  result.isNotEmpty &&
                                  splashEnabled) {
                                setState(() => splash = !splash);
                              }
                              controller.text = '';
                              result = '';
                              heavyHaptic();
                              break;
                            case CalculatorButton.equal:
                              if (result.isEmpty || result.contains('/')) {
                                heavyHaptic();
                                return;
                              }

                              final resultModel =
                                  controller.onEqualPressed(parser);
                              if (resultModel != null) {
                                controller.text = result.formatThousands();
                                if (!resultModel.output.isInt &&
                                    resultModel.output.isDouble) {
                                  result = resultModel.output.toFraction;
                                } else {
                                  result = '';
                                }
                                if (resultModel.output != 'Format Error' ||
                                    resultModel.output != 'Error') {
                                  preferencesService.saveResult(resultModel);
                                }
                                heavyHaptic();
                              }
                              break;
                            case CalculatorButton.decimal:
                              final haptic = controller.onDecimalPressed();
                              if (haptic) {
                                mediumHaptic();
                              }
                              break;
                            default:
                              final val = controller.onOperationPressed(
                                  button.value,
                                  parser: parser);
                              if (val != null) {
                                result = val.output.formatThousands();
                              }
                              mediumHaptic();
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
