import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:neumorphic_calculator/service/preference_service.dart';
import 'package:neumorphic_calculator/utils/result_model.dart';
import 'bloc/calculator_bloc/calculator_bloc.dart';
import 'bloc/history_bloc/history_bloc.dart';
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
    return BlocListener<CalculatorBloc, CalculatorState>(
      listener: (context, state) {
        if (state.splash) {
          setState(() => splash = !splash);
        }

        controller.value = TextEditingValue(
          text: state.expression,
          selection: TextSelection.collapsed(offset: state.offset ?? -1),
          // composing: TextRange
        );
        if (state.expression.canCalculate) {
          context.read<CalculatorBloc>().add(const Calculate());
        }
      },
      child: ThemeSwitchingArea(
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
                          child: BlocBuilder<CalculatorBloc, CalculatorState>(
                            builder: (context, state) {
                              return Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      flex: 2, child: InputWidget(controller)),
                                  Expanded(
                                      child: ResultWidget(
                                          state.output.formatThousands())),
                                ],
                              );
                            },
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
                            context.read<CalculatorBloc>().add(AddNumber(
                                number, controller.selection.baseOffset));
                            mediumHaptic();
                          },
                          onOperationPressed: (button) {
                            switch (button) {
                              case CalculatorButton.negative:
                                // TODO: Handle this case.
                                mediumHaptic();
                                break;
                              case CalculatorButton.clear:
                                context.read<CalculatorBloc>().add(DeleteEntry(
                                    controller.selection.baseOffset));
                                mediumHaptic();
                                break;
                              case CalculatorButton.allClear:
                                context
                                    .read<CalculatorBloc>()
                                    .add(const ClearCalculator());
                                heavyHaptic();
                                break;
                              case CalculatorButton.equal:
                                context
                                    .read<CalculatorBloc>()
                                    .add(const Equals());

                                //TODO: add result to history using history bloc
                                // context.watch<HistoryBloc>().state.;
                                context.read<HistoryBloc>().add(AddHistory(
                                    ResultModel(
                                        output: '12',
                                        expression: '11+1',
                                        dateTime: DateTime.now())));
                                heavyHaptic();
                                break;
                              case CalculatorButton.decimal:
                                context.read<CalculatorBloc>().add(AddDecimal(
                                    controller.selection.baseOffset));
                                // final haptic = controller.onDecimalPressed();
                                // if (haptic) {
                                mediumHaptic();
                                // }
                                break;
                              default:
                                context.read<CalculatorBloc>().add(AddOperator(
                                    button.value,
                                    controller.selection.baseOffset));
                                // final val = controller.onOperationPressed(
                                //     button.value,
                                //     parser: parser);
                                // if (val != null) {
                                //   result = val.output.formatThousands();
                                // }
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
      ),
    );
  }
}
