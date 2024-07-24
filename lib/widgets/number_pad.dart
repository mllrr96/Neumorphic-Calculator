import 'package:flutter/material.dart';
import 'package:neumorphic_calculator/service/preference_service.dart';
import 'package:neumorphic_calculator/widgets/neumorphic_button.dart';
import 'package:neumorphic_calculator/widgets/scientific_buttons.dart';
import 'package:neumorphic_calculator/widgets/stacked_button.dart';
import '../calculator_icons.dart';
import '../utils/enum.dart';

class NumberPad extends StatelessWidget {
  const NumberPad(
      {super.key,
      this.onNumberPressed,
      this.onOperationPressed,
      this.onScientificButtonsPressed});
  final void Function(String number)? onNumberPressed;
  final void Function(CalculatorButton button)? onOperationPressed;
  final void Function(ScientificButton value)? onScientificButtonsPressed;
  PreferencesService get preferencesService => PreferencesService.instance;
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    TextStyle numberStyle = TextStyle(
        color: Theme.of(context).iconTheme.color,
        fontSize: 24,
        fontWeight: FontWeight.bold);
    TextStyle operationStyle = TextStyle(
        color: primaryColor, fontSize: 24, fontWeight: FontWeight.w900);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (preferencesService.settingsModel.scientific)
          ScientificButtons(
              onScientificButtonsPressed: onScientificButtonsPressed),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NeumorphicButton(
              child:
                  Text(CalculatorButton.allClear.value, style: operationStyle),
              onPressed: () {
                onOperationPressed?.call(CalculatorButton.allClear);
              },
            ),
            SizedBox(
                width: 75,
                child: StackedButton(
                  firstChild: const Text('('),
                  secondChild: const Text(')'),
                  onFirstChildPressed: () => onOperationPressed
                      ?.call(CalculatorButton.openParenthesis),
                  onSecondChildPressed: () => onOperationPressed
                      ?.call(CalculatorButton.closeParenthesis),
                )),
            NeumorphicButton(
              child: Icon(CalculatorIcons.percentage,
                  color: primaryColor, size: 24),
              onPressed: () =>
                  onOperationPressed?.call(CalculatorButton.percent),
            ),
            NeumorphicButton(
              child:
                  Icon(CalculatorIcons.divide, color: primaryColor, size: 24),
              onPressed: () =>
                  onOperationPressed?.call(CalculatorButton.divide),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NeumorphicButton(
              child: Text(CalculatorButton.seven.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.seven.value),
            ),
            NeumorphicButton(
              child: Text(CalculatorButton.eight.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.eight.value),
            ),
            NeumorphicButton(
              child: Text(CalculatorButton.nine.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.nine.value),
            ),
            NeumorphicButton(
              child:
                  Icon(CalculatorIcons.cancel, color: primaryColor, size: 24),
              onPressed: () =>
                  onOperationPressed?.call(CalculatorButton.multiply),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NeumorphicButton(
              child: Text(CalculatorButton.four.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.four.value),
            ),
            NeumorphicButton(
              child: Text(CalculatorButton.five.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.five.value),
            ),
            NeumorphicButton(
              child: Text(CalculatorButton.six.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.six.value),
            ),
            NeumorphicButton(
              child: Icon(CalculatorIcons.minus, color: primaryColor, size: 24),
              onPressed: () =>
                  onOperationPressed?.call(CalculatorButton.subtract),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NeumorphicButton(
              child: Text(CalculatorButton.one.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.one.value),
            ),
            NeumorphicButton(
              child: Text(CalculatorButton.two.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.two.value),
            ),
            NeumorphicButton(
              child: Text(CalculatorButton.three.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.three.value),
            ),
            NeumorphicButton(
              child: Icon(CalculatorIcons.plus, color: primaryColor, size: 24),
              onPressed: () => onOperationPressed?.call(CalculatorButton.add),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NeumorphicButton(
              child: Text(CalculatorButton.zero.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.zero.value),
            ),
            NeumorphicButton(
              child:
                  Text(CalculatorButton.decimal.value, style: operationStyle),
              onPressed: () =>
                  onOperationPressed?.call(CalculatorButton.decimal),
            ),
            NeumorphicButton(
              child: Icon(Icons.backspace, size: 24, color: primaryColor),
              onPressed: () => onOperationPressed?.call(CalculatorButton.clear),
            ),
            NeumorphicButton(
              child: Icon(CalculatorIcons.calc, color: primaryColor, size: 24),
              onPressed: () => onOperationPressed?.call(CalculatorButton.equal),
            ),
          ],
        ),
      ],
    );
  }
}
