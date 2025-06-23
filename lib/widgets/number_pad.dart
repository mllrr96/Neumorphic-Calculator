import 'package:flutter/material.dart';
import 'package:neumorphic_calculator/calculator_icons.dart';
import 'package:neumorphic_calculator/utils/enum.dart';
import 'package:neumorphic_calculator/widgets/neumorphic_button.dart';
import 'package:neumorphic_calculator/widgets/stacked_button.dart';

class NumberPad extends StatelessWidget {
  const NumberPad({
    super.key,
    this.onNumberPressed,
    this.onOperationPressed,
    required this.borderRadius,
  });

  final void Function(String number)? onNumberPressed;
  final void Function(CalculatorButton button)? onOperationPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final numberStyle = TextStyle(
      color: Theme.of(context).iconTheme.color,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
    final operationStyle = TextStyle(
      color: primaryColor,
      fontSize: 24,
      fontWeight: FontWeight.w900,
    );

    Widget buildTextBtn(String label, VoidCallback onPressed, TextStyle style) {
      return NeumorphicButton(
        borderRadius: borderRadius,
        onPressed: onPressed,
        child: Text(label, style: style),
      );
    }

    Widget buildIconBtn(IconData icon, VoidCallback onPressed) {
      return NeumorphicButton(
        borderRadius: borderRadius,
        onPressed: onPressed,
        child: Icon(icon, color: primaryColor, size: 24),
      );
    }

    return RepaintBoundary(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildTextBtn(CalculatorButton.allClear.value,
                      () => onOperationPressed?.call(CalculatorButton.allClear), operationStyle),
              SizedBox(
                width: 75,
                child: StackedButton(
                  borderRadius: borderRadius,
                  firstChild: Text('(', style: operationStyle),
                  secondChild: Text(')', style: operationStyle),
                  onFirstChildPressed: () => onOperationPressed?.call(CalculatorButton.openParenthesis),
                  onSecondChildPressed: () => onOperationPressed?.call(CalculatorButton.closeParenthesis),
                ),
              ),
              buildIconBtn(CalculatorIcons.percentage, () => onOperationPressed?.call(CalculatorButton.percent)),
              buildIconBtn(CalculatorIcons.divide, () => onOperationPressed?.call(CalculatorButton.divide)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildTextBtn('7', () => onNumberPressed?.call('7'), numberStyle),
              buildTextBtn('8', () => onNumberPressed?.call('8'), numberStyle),
              buildTextBtn('9', () => onNumberPressed?.call('9'), numberStyle),
              buildIconBtn(CalculatorIcons.cancel, () => onOperationPressed?.call(CalculatorButton.multiply)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildTextBtn('4', () => onNumberPressed?.call('4'), numberStyle),
              buildTextBtn('5', () => onNumberPressed?.call('5'), numberStyle),
              buildTextBtn('6', () => onNumberPressed?.call('6'), numberStyle),
              buildIconBtn(CalculatorIcons.minus, () => onOperationPressed?.call(CalculatorButton.subtract)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildTextBtn('1', () => onNumberPressed?.call('1'), numberStyle),
              buildTextBtn('2', () => onNumberPressed?.call('2'), numberStyle),
              buildTextBtn('3', () => onNumberPressed?.call('3'), numberStyle),
              buildIconBtn(CalculatorIcons.plus, () => onOperationPressed?.call(CalculatorButton.add)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildTextBtn('0', () => onNumberPressed?.call('0'), numberStyle),
              buildTextBtn('.', () => onOperationPressed?.call(CalculatorButton.decimal), operationStyle),
              buildIconBtn(Icons.backspace, () => onOperationPressed?.call(CalculatorButton.clear)),
              buildIconBtn(CalculatorIcons.calc, () => onOperationPressed?.call(CalculatorButton.equal)),
            ],
          ),
        ],
      ),
    );
  }
}
