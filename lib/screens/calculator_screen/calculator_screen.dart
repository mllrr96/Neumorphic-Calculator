import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neumorphic_calculator/screens/settings_screen/settings_controller.dart';
import 'package:neumorphic_calculator/utils/enum.dart';
import 'package:neumorphic_calculator/widgets/number_pad.dart';

import 'calculator_controller.dart';

class CalculatorScreen extends GetView<CalculatorController> {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<SettingsController>(builder: (settingsModel) {
          return NumberPad(
            borderRadius: settingsModel.state?.buttonRadius ?? 0.0,
            onNumberPressed: (number) {
              controller.onNumberPressed(number);
            },
            onOperationPressed: (button) {
              switch (button) {
                case CalculatorButton.openParenthesis ||
                      CalculatorButton.closeParenthesis:
                  controller.onParenthesesPressed(button.value);
                  break;
                case CalculatorButton.clear:
                  controller.onDeletePressed();
                  break;
                case CalculatorButton.allClear:
                  controller.onClearAllPressed();
                  break;
                case CalculatorButton.equal:
                  controller.onEqualPressed();
                  break;
                case CalculatorButton.decimal:
                  controller.onDecimalPressed();
                  break;
                default:
                  controller.onOperatorPressed(button.value);
              }
            },
          );
        }),
      ),
    );
  }
}
