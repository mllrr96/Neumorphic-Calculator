import 'package:flutter/material.dart';
import 'package:neumorphic_calculator/widgets/button.dart';

import '../calculator_icons_icons.dart';
import '../utils/enum.dart';

class NumberPad extends StatelessWidget {
  const NumberPad({super.key, this.onNumberPressed, this.onOperationPressed});
  final void Function(String number)? onNumberPressed;
  final void Function(CalculatorButton button)? onOperationPressed;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
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
              child:
                  Text(CalculatorButton.allClear.value, style: operationStyle),
              onPressed: () =>
                  onOperationPressed?.call(CalculatorButton.allClear),
            ),
            NeumorphicButton(
              child: Text(CalculatorButton.seven.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.seven.value),
            ),
            NeumorphicButton(
              child: Text(CalculatorButton.four.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.four.value),
            ),
            NeumorphicButton(
              child: Text(CalculatorButton.one.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.one.value),
            ),
            NeumorphicButton(
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
              child:
                  Text(CalculatorButton.negative.value, style: operationStyle),
              onPressed: () =>
                  onOperationPressed?.call(CalculatorButton.negative),
            ),
            NeumorphicButton(
              child: Text(CalculatorButton.eight.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.eight.value),
            ),
            NeumorphicButton(
              child: Text(CalculatorButton.five.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.five.value),
            ),
            NeumorphicButton(
              child: Text(CalculatorButton.two.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.two.value),
            ),
            NeumorphicButton(
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
              child: Icon(CalculatorIcons.percentage,
                  color: primaryColor, size: 24),
              onPressed: () =>
                  onOperationPressed?.call(CalculatorButton.percent),
            ),
            NeumorphicButton(
              child: Text(CalculatorButton.nine.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.nine.value),
            ),
            NeumorphicButton(
              child: Text(CalculatorButton.six.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.six.value),
            ),
            NeumorphicButton(
              child: Text(CalculatorButton.three.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.three.value),
            ),
            NeumorphicButton(
              child: Icon(Icons.backspace, size: 24, color: primaryColor),
              onPressed: () => onOperationPressed?.call(CalculatorButton.clear),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NeumorphicButton(
              child:
                  Icon(CalculatorIcons.divide, color: primaryColor, size: 24),
              onPressed: () =>
                  onOperationPressed?.call(CalculatorButton.divide),
            ),
            NeumorphicButton(
              child:
                  Icon(CalculatorIcons.cancel, color: primaryColor, size: 24),
              onPressed: () =>
                  onOperationPressed?.call(CalculatorButton.multiply),
            ),
            NeumorphicButton(
              child: Icon(CalculatorIcons.minus, color: primaryColor, size: 24),
              onPressed: () =>
                  onOperationPressed?.call(CalculatorButton.subtract),
            ),
            NeumorphicButton(
              child: Icon(CalculatorIcons.plus, color: primaryColor, size: 24),
              onPressed: () => onOperationPressed?.call(CalculatorButton.add),
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
