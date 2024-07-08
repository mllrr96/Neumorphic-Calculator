import 'package:flutter/material.dart';
import 'package:neumorphic_calculator/service/preference_service.dart';
import 'package:neumorphic_calculator/widgets/button.dart';

import '../calculator_icons.dart';
import '../utils/enum.dart';

class NumberPad extends StatelessWidget {
  const NumberPad({super.key, this.onNumberPressed, this.onOperationPressed});
  final void Function(String number)? onNumberPressed;
  final void Function(CalculatorButton button)? onOperationPressed;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final buttonRadius = PreferencesService.instance.settingsModel.buttonRadius;
    TextStyle numberStyle = TextStyle(
        color: Theme.of(context).iconTheme.color,
        fontSize: 24,
        fontWeight: FontWeight.bold);
    TextStyle operationStyle = TextStyle(
        color: primaryColor, fontSize: 24, fontWeight: FontWeight.w900);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NeumorphicButton(
              borderRadius: BorderRadius.circular(buttonRadius),
              child:
                  Text(CalculatorButton.allClear.value, style: operationStyle),
              onPressed: () =>
                  onOperationPressed?.call(CalculatorButton.allClear),
            ),
            NeumorphicButton(
              borderRadius: BorderRadius.circular(buttonRadius),
              child: Text(CalculatorButton.seven.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.seven.value),
            ),
            NeumorphicButton(
              borderRadius: BorderRadius.circular(buttonRadius),
              child: Text(CalculatorButton.four.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.four.value),
            ),
            NeumorphicButton(
              borderRadius: BorderRadius.circular(buttonRadius),
              child: Text(CalculatorButton.one.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.one.value),
            ),
            NeumorphicButton(
              borderRadius: BorderRadius.circular(buttonRadius),
              child: Text(CalculatorButton.zero.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.zero.value),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NeumorphicButton(
              borderRadius: BorderRadius.circular(buttonRadius),
              child:
                  Text(CalculatorButton.negative.value, style: operationStyle),
              onPressed: () =>
                  onOperationPressed?.call(CalculatorButton.negative),
            ),
            NeumorphicButton(
              borderRadius: BorderRadius.circular(buttonRadius),
              child: Text(CalculatorButton.eight.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.eight.value),
            ),
            NeumorphicButton(
              borderRadius: BorderRadius.circular(buttonRadius),
              child: Text(CalculatorButton.five.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.five.value),
            ),
            NeumorphicButton(
              borderRadius: BorderRadius.circular(buttonRadius),
              child: Text(CalculatorButton.two.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.two.value),
            ),
            NeumorphicButton(
              borderRadius: BorderRadius.circular(buttonRadius),
              child:
                  Text(CalculatorButton.decimal.value, style: operationStyle),
              onPressed: () =>
                  onOperationPressed?.call(CalculatorButton.decimal),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NeumorphicButton(
              borderRadius: BorderRadius.circular(buttonRadius),
              child: Icon(CalculatorIcons.percentage,
                  color: primaryColor, size: 24),
              onPressed: () =>
                  onOperationPressed?.call(CalculatorButton.percent),
            ),
            NeumorphicButton(
              borderRadius: BorderRadius.circular(buttonRadius),
              child: Text(CalculatorButton.nine.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.nine.value),
            ),
            NeumorphicButton(
              borderRadius: BorderRadius.circular(buttonRadius),
              child: Text(CalculatorButton.six.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.six.value),
            ),
            NeumorphicButton(
              borderRadius: BorderRadius.circular(buttonRadius),
              child: Text(CalculatorButton.three.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.three.value),
            ),
            NeumorphicButton(
              borderRadius: BorderRadius.circular(buttonRadius),
              child: Icon(Icons.backspace, size: 24, color: primaryColor),
              onPressed: () => onOperationPressed?.call(CalculatorButton.clear),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NeumorphicButton(
              borderRadius: BorderRadius.circular(buttonRadius),
              child:
                  Icon(CalculatorIcons.divide, color: primaryColor, size: 24),
              onPressed: () =>
                  onOperationPressed?.call(CalculatorButton.divide),
            ),
            NeumorphicButton(
              borderRadius: BorderRadius.circular(buttonRadius),
              child:
                  Icon(CalculatorIcons.cancel, color: primaryColor, size: 24),
              onPressed: () =>
                  onOperationPressed?.call(CalculatorButton.multiply),
            ),
            NeumorphicButton(
              borderRadius: BorderRadius.circular(buttonRadius),
              child: Icon(CalculatorIcons.minus, color: primaryColor, size: 24),
              onPressed: () =>
                  onOperationPressed?.call(CalculatorButton.subtract),
            ),
            NeumorphicButton(
              borderRadius: BorderRadius.circular(buttonRadius),
              child: Icon(CalculatorIcons.plus, color: primaryColor, size: 24),
              onPressed: () => onOperationPressed?.call(CalculatorButton.add),
            ),
            NeumorphicButton(
              borderRadius: BorderRadius.circular(buttonRadius),
              child: Icon(CalculatorIcons.calc, color: primaryColor, size: 24),
              onPressed: () => onOperationPressed?.call(CalculatorButton.equal),
            ),
          ],
        ),
      ],
    );
  }
}
