import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neumorphic_calculator/bloc/preference_cubit/preference_cubit.dart';
import 'package:neumorphic_calculator/utils/result_model.dart';
import 'package:neumorphic_calculator/utils/settings_model.dart';
import 'package:neumorphic_calculator/widgets/quick_settings.dart';
import 'bloc/calculator_bloc/calculator_bloc.dart';
import 'bloc/history_bloc/history_bloc.dart';
import 'bloc/preference_cubit/preference_state.dart';
import 'utils/extensions/extensions.dart';
import 'package:neumorphic_calculator/widgets/calculator_app_bar.dart';
import 'widgets/input_widget.dart';
import 'widgets/result_widget.dart';
import 'widgets/splash_effect.dart';
import 'widgets/number_pad.dart';
import 'utils/enum.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  CalculatorScreenState createState() => CalculatorScreenState();
}

class CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController controller = TextEditingController();
  String get input => controller.text;
  bool splash = false;
  SettingsModel get settingsModel =>
      context.read<PreferenceCubit>().state.settings;

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
    if (settingsModel.hapticEnabled) {
      HapticFeedback.mediumImpact();
    }
  }

  void heavyHaptic() {
    if (settingsModel.hapticEnabled) {
      HapticFeedback.heavyImpact();
    }
  }

  void _addToResult() {
    final calculatorState = context.read<CalculatorBloc>().state;
    final historyState = context.read<HistoryBloc>().state;
    final result = ResultModel(
        output: calculatorState.output,
        expression: calculatorState.expression,
        dateTime: DateTime.now());
    if (calculatorState.output.toLowerCase().contains('error') ||
        calculatorState.output.isEmpty) {
      return;
    }
    if (historyState is HistoryLoaded) {
      if (historyState.results.isNotEmpty) {
        if (historyState.results.first != result) {
          context.read<HistoryBloc>().add(AddHistory(result));
        }
      } else {
        context.read<HistoryBloc>().add(AddHistory(result));
      }
    } else if (historyState is HistoryEmpty) {
      context.read<HistoryBloc>().add(AddHistory(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      direction: Axis.vertical,
      key: const ValueKey(0),
      endActionPane: const ActionPane(
        extentRatio: 0.15,
        motion: BehindMotion(),
        children: [Expanded(child: QuickSettings())],
      ),
      child: BlocListener<CalculatorBloc, CalculatorState>(
        listener: (context, state) {
          controller.value = TextEditingValue(
            text: state.expression,
            selection: TextSelection.collapsed(offset: state.offset ?? -1),
          );
          if (state.expression.canCalculate) {
            context
                .read<CalculatorBloc>()
                .add(const Calculate(skipError: true));
          }
        },
        child: ThemeSwitchingArea(
          child: Builder(builder: (context) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: Theme.of(context).appBarTheme.systemOverlayStyle?.copyWith(
                        systemNavigationBarColor:
                            Theme.of(context).scaffoldBackgroundColor,
                      ) ??
                  SystemUiOverlayStyle.light,
              child: Scaffold(
                appBar: const CalculatorAppBar(),
                body: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<CalculatorBloc, CalculatorState>(
                        builder: (context, state) {
                          if (state.splash) {
                            splash = !splash;
                          }
                          return Flexible(
                            child: SplashEffect(
                              splash: splash,
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: InputWidget(controller)),
                                    Expanded(
                                        child: ResultWidget(
                                            state.output.formatThousands())),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      BlocBuilder<PreferenceCubit, PreferenceState>(
                        builder: (context, state) {
                          return Flexible(
                            flex: state.settings.scientific ? 4 : 2,
                            child: Material(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: NumberPad(
                                borderRadius: state.settings.buttonRadius,
                                isScientific: state.settings.scientific,
                                onNumberPressed: (number) {
                                  context.read<CalculatorBloc>().add(AddNumber(
                                      number, controller.selection.baseOffset));
                                  mediumHaptic();
                                },
                                onScientificButtonsPressed: (val) {
                                  context.read<CalculatorBloc>().add(
                                      AddScientificButton(val,
                                          controller.selection.baseOffset));
                                  mediumHaptic();
                                },
                                onOperationPressed: (button) {
                                  switch (button) {
                                    case CalculatorButton.openParenthesis ||
                                          CalculatorButton.closeParenthesis:
                                      context.read<CalculatorBloc>().add(
                                          AddParentheses(button.value,
                                              controller.selection.baseOffset));
                                      mediumHaptic();
                                      break;
                                    case CalculatorButton.clear:
                                      context.read<CalculatorBloc>().add(
                                          DeleteEntry(
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
                                          .add(const Calculate());
                                      context
                                          .read<CalculatorBloc>()
                                          .add(const Equals());

                                      _addToResult();
                                      heavyHaptic();

                                      break;
                                    case CalculatorButton.decimal:
                                      context.read<CalculatorBloc>().add(
                                          AddDecimal(
                                              controller.selection.baseOffset));
                                      mediumHaptic();
                                      break;
                                    default:
                                      context.read<CalculatorBloc>().add(
                                          AddOperator(button.value,
                                              controller.selection.baseOffset));
                                      mediumHaptic();
                                  }
                                  // setState(() {});
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
