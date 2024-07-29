import 'package:flutter/material.dart';
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
      this.onScientificButtonsPressed,
      required this.isScientific,
      required this.borderRadius});
  final void Function(String number)? onNumberPressed;
  final void Function(CalculatorButton button)? onOperationPressed;
  final void Function(ScientificButton value)? onScientificButtonsPressed;
  final bool isScientific;
  final double borderRadius;
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
        if (isScientific)
          ScientificButtons(
            borderRadius: borderRadius,
            onScientificButtonsPressed: onScientificButtonsPressed,
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NeumorphicButton(
              borderRadius: borderRadius,
              child:
                  Text(CalculatorButton.allClear.value, style: operationStyle),
              onPressed: () {
                onOperationPressed?.call(CalculatorButton.allClear);
              },
            ),
            SizedBox(
                width: 75,
                child: StackedButton(
                  borderRadius: borderRadius,
                  firstChild: Text('(', style: operationStyle),
                  secondChild: Text(')', style: operationStyle),
                  onFirstChildPressed: () => onOperationPressed
                      ?.call(CalculatorButton.openParenthesis),
                  onSecondChildPressed: () => onOperationPressed
                      ?.call(CalculatorButton.closeParenthesis),
                )),
            NeumorphicButton(
              borderRadius: borderRadius,
              child: Icon(CalculatorIcons.percentage,
                  color: primaryColor, size: 24),
              onPressed: () =>
                  onOperationPressed?.call(CalculatorButton.percent),
            ),
            NeumorphicButton(
              borderRadius: borderRadius,
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
              borderRadius: borderRadius,
              child: Text(CalculatorButton.seven.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.seven.value),
            ),
            NeumorphicButton(
              borderRadius: borderRadius,
              child: Text(CalculatorButton.eight.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.eight.value),
            ),
            NeumorphicButton(
              borderRadius: borderRadius,
              child: Text(CalculatorButton.nine.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.nine.value),
            ),
            NeumorphicButton(
              borderRadius: borderRadius,
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
              borderRadius: borderRadius,
              child: Text(CalculatorButton.four.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.four.value),
            ),
            NeumorphicButton(
              borderRadius: borderRadius,
              child: Text(CalculatorButton.five.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.five.value),
            ),
            NeumorphicButton(
              borderRadius: borderRadius,
              child: Text(CalculatorButton.six.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.six.value),
            ),
            NeumorphicButton(
              borderRadius: borderRadius,
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
              borderRadius: borderRadius,
              child: Text(CalculatorButton.one.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.one.value),
            ),
            NeumorphicButton(
              borderRadius: borderRadius,
              child: Text(CalculatorButton.two.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.two.value),
            ),
            NeumorphicButton(
              borderRadius: borderRadius,
              child: Text(CalculatorButton.three.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.three.value),
            ),
            NeumorphicButton(
              borderRadius: borderRadius,
              child: Icon(CalculatorIcons.plus, color: primaryColor, size: 24),
              onPressed: () => onOperationPressed?.call(CalculatorButton.add),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NeumorphicButton(
              borderRadius: borderRadius,
              child: Text(CalculatorButton.zero.value, style: numberStyle),
              onPressed: () =>
                  onNumberPressed?.call(CalculatorButton.zero.value),
            ),
            NeumorphicButton(
              borderRadius: borderRadius,
              child:
                  Text(CalculatorButton.decimal.value, style: operationStyle),
              onPressed: () =>
                  onOperationPressed?.call(CalculatorButton.decimal),
            ),
            NeumorphicButton(
              borderRadius: borderRadius,
              child: Icon(Icons.backspace, size: 24, color: primaryColor),
              onPressed: () => onOperationPressed?.call(CalculatorButton.clear),
            ),
            NeumorphicButton(
              borderRadius: borderRadius,
              child: Icon(CalculatorIcons.calc, color: primaryColor, size: 24),
              onPressed: () => onOperationPressed?.call(CalculatorButton.equal),
            ),
          ],
        ),
      ],
    );
  }
}
