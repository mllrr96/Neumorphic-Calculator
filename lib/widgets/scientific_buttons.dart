import 'package:flutter/material.dart';
import 'package:neumorphic_calculator/utils/enum.dart';
import 'package:neumorphic_calculator/widgets/stacked_button.dart';

class ScientificButtons extends StatelessWidget {
  const ScientificButtons(
      {super.key, this.onScientificButtonsPressed, required this.borderRadius});
  final void Function(ScientificButton value)? onScientificButtonsPressed;
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    TextStyle operationStyle = TextStyle(
        color: primaryColor, fontSize: 24, fontWeight: FontWeight.w900);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StackedButton(
              borderRadius: borderRadius,
              firstChild:
                  Text(ScientificButton.pow.value, style: operationStyle),
              secondChild:
                  Text(ScientificButton.fact.value, style: operationStyle),
              onFirstChildPressed: () =>
                  onScientificButtonsPressed?.call(ScientificButton.pow),
              onSecondChildPressed: () =>
                  onScientificButtonsPressed?.call(ScientificButton.fact),
            ),
            StackedButton.vertical(
              borderRadius: borderRadius,
              firstChild:
                  Text(ScientificButton.sin.name, style: operationStyle),
              secondChild:
                  Text(ScientificButton.cos.name, style: operationStyle),
              onFirstChildPressed: () =>
                  onScientificButtonsPressed?.call(ScientificButton.sin),
              onSecondChildPressed: () =>
                  onScientificButtonsPressed?.call(ScientificButton.cos),
            ),
            StackedButton.vertical(
              borderRadius: borderRadius,
              firstChild:
                  Text(ScientificButton.tan.name, style: operationStyle),
              secondChild:
                  Text(ScientificButton.log.name, style: operationStyle),
              onFirstChildPressed: () =>
                  onScientificButtonsPressed?.call(ScientificButton.tan),
              onSecondChildPressed: () =>
                  onScientificButtonsPressed?.call(ScientificButton.log),
            ),
            StackedButton(
              borderRadius: borderRadius,
              firstChild: Text(ScientificButton.sqrt.value.replaceAll('(', ''),
                  style: operationStyle),
              secondChild:
                  Text(ScientificButton.pi.value, style: operationStyle),
              onFirstChildPressed: () =>
                  onScientificButtonsPressed?.call(ScientificButton.sqrt),
              onSecondChildPressed: () =>
                  onScientificButtonsPressed?.call(ScientificButton.pi),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StackedButton.vertical(
              borderRadius: borderRadius,
              firstChild: Text('', style: operationStyle),
              secondChild: Text('INV', style: operationStyle),
              onFirstChildPressed: () {},
              onSecondChildPressed: () {},
            ),
            StackedButton.vertical(
              borderRadius: borderRadius,
              firstChild:
                  Text(ScientificButton.asin.name, style: operationStyle),
              secondChild:
                  Text(ScientificButton.acos.name, style: operationStyle),
              onFirstChildPressed: () =>
                  onScientificButtonsPressed?.call(ScientificButton.asin),
              onSecondChildPressed: () =>
                  onScientificButtonsPressed?.call(ScientificButton.acos),
            ),
            StackedButton.vertical(
              borderRadius: borderRadius,
              firstChild: Text('10\u02e3', style: operationStyle),
              secondChild: Text('e\u02e3', style: operationStyle),
              onFirstChildPressed: () {},
              onSecondChildPressed: () =>
                  onScientificButtonsPressed?.call(ScientificButton.exp),
            ),
            StackedButton(
              borderRadius: borderRadius,
              firstChild: Text(ScientificButton.e.value, style: operationStyle),
              secondChild:
                  Text(ScientificButton.ln.name, style: operationStyle),
              onFirstChildPressed: () =>
                  onScientificButtonsPressed?.call(ScientificButton.e),
              onSecondChildPressed: () =>
                  onScientificButtonsPressed?.call(ScientificButton.ln),
            ),
          ],
        )
      ],
    );
  }
}
