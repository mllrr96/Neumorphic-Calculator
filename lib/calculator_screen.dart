import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late bool scientific;

  @override
  void initState() {
    scientific = preferencesService.settingsModel.scientific;
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

  PreferencesService get preferencesService => PreferencesService.instance;
  bool get splashEnabled => preferencesService.settingsModel.splashEnabled;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      direction: Axis.vertical,
      key: const ValueKey(0),
      endActionPane: ActionPane(
        extentRatio: 0.2,
        motion: const BehindMotion(),
        children: [
          Expanded(
            child: Material(
              color: Theme.of(context).bottomAppBarTheme.color,
              child: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SwitchListTile(
                        title: const Text('Scientific'),
                        value: scientific,
                        onChanged: (value) {
                          preferencesService.updateSettings(preferencesService
                              .settingsModel
                              .copyWith(scientific: value));
                          setState(() {
                            scientific = value;
                          });
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Haptic feedback'),
                        value: preferencesService.settingsModel.hapticEnabled,
                        onChanged: (val) {
                          preferencesService.updateSettings(
                              preferencesService.settingsModel.copyWith(
                                  hapticEnabled: !preferencesService
                                      .settingsModel.hapticEnabled));
                          setState(() {});
                          if (val) {
                            HapticFeedback.mediumImpact();
                          }
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Other settings'),
                        value: false,
                        onChanged: (_) {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      child: BlocListener<CalculatorBloc, CalculatorState>(
        listener: (context, state) {
          if (state.splash) {
            setState(() => splash = !splash);
          }

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
              value: Theme.of(context).appBarTheme.systemOverlayStyle ??
                  SystemUiOverlayStyle.light,
              child: Scaffold(
                appBar: const CalculatorAppBar(),
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
                                        flex: 2,
                                        child: InputWidget(controller)),
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
                        flex:
                            preferencesService.settingsModel.scientific ? 4 : 2,
                        child: Material(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: NumberPad(
                            onNumberPressed: (number) {
                              context.read<CalculatorBloc>().add(AddNumber(
                                  number, controller.selection.baseOffset));
                              mediumHaptic();
                            },
                            onScientificButtonsPressed: (val) {
                              context.read<CalculatorBloc>().add(
                                  AddScientificButton(
                                      val, controller.selection.baseOffset));
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
                                  context.read<CalculatorBloc>().add(AddDecimal(
                                      controller.selection.baseOffset));
                                  mediumHaptic();
                                  break;
                                default:
                                  context.read<CalculatorBloc>().add(
                                      AddOperator(button.value,
                                          controller.selection.baseOffset));
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
      ),
    );
  }
}
