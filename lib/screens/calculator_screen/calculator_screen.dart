import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neumorphic_calculator/screens/history_screen/history_controller.dart';
import 'package:neumorphic_calculator/screens/settings_screen/settings_controller.dart';
import 'package:neumorphic_calculator/utils/enum.dart';
import 'package:neumorphic_calculator/utils/result_model.dart';
import 'package:neumorphic_calculator/utils/settings_model.dart';
import 'package:neumorphic_calculator/widgets/number_pad.dart';

import 'calculator_controller.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  CalculatorScreenState createState() => CalculatorScreenState();
}

class CalculatorScreenState extends State<CalculatorScreen> {
  final textCtrl = TextEditingController();
  final calcController = Get.find<CalculatorController>();

  SettingsModel get settingsModel =>
      SettingsController.instance.state ?? SettingsModel.normal();

  @override
  void dispose() {
    textCtrl.dispose();
    super.dispose();
  }

  void mediumHaptic() {
    if (settingsModel.hapticEnabled) HapticFeedback.mediumImpact();
  }

  void heavyHaptic() {
    if (settingsModel.hapticEnabled) HapticFeedback.heavyImpact();
  }

  void _addToResult(String expression, String output) {
    if (output.toLowerCase().contains('error') || output.isEmpty) return;
    final result = ResultModel(
      output: output,
      expression: expression,
      dateTime: DateTime.now(),
    );

    final historyController = Get.find<HistoryController>();
    final history = historyController.state ?? [];
    if (history.isEmpty || history.first != result) {
      historyController.addData(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: GetBuilder<SettingsController>(builder: (_) {
            return NumberPad(
              borderRadius: settingsModel.buttonRadius,
              onNumberPressed: (number) {
                calcController.addNumber(number, textCtrl.selection.baseOffset);
                mediumHaptic();
              },
              onOperationPressed: (button) {
                switch (button) {
                  case CalculatorButton.openParenthesis ||
                        CalculatorButton.closeParenthesis:
                    calcController.addParentheses(
                        button.value, textCtrl.selection.baseOffset);
                    mediumHaptic();
                    break;
                  case CalculatorButton.clear:
                    calcController.delete(textCtrl.selection.baseOffset);
                    mediumHaptic();
                    break;
                  case CalculatorButton.allClear:
                    if (calcController.exp.isNotEmpty &&
                        calcController.output.value.isNotEmpty) {
                      calcController.isClearing.value = true;
                    } else {
                      calcController.clear();
                    }
                    heavyHaptic();
                    break;
                  case CalculatorButton.equal:
                    final exp = calcController.expression.value;
                    final output = calcController.output.value;
                    calcController.calculate();
                    calcController.equals();
                    _addToResult(exp, output);
                    heavyHaptic();
                    break;
                  case CalculatorButton.decimal:
                    calcController.addDecimal(textCtrl.selection.baseOffset);
                    mediumHaptic();
                    break;
                  default:
                    calcController.addOperator(
                        button.value, textCtrl.selection.baseOffset);
                    mediumHaptic();
                }
              },
            );
          }),
        ),
      ),
    );
  }
}
