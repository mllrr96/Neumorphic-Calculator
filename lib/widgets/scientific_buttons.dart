import 'package:flutter/widgets.dart';
import 'package:neumorphic_calculator/utils/enum.dart';
import 'package:neumorphic_calculator/widgets/stacked_button.dart';

class ScientificButtons extends StatelessWidget {
  const ScientificButtons({super.key, this.onScientificButtonsPressed});
  final void Function(ScientificButton value)? onScientificButtonsPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StackedButton(
              firstChild: Text(ScientificButton.pow.value),
              secondChild: Text(ScientificButton.fact.value),
              onFirstChildPressed: () =>
                  onScientificButtonsPressed?.call(ScientificButton.pow),
              onSecondChildPressed: () =>
                  onScientificButtonsPressed?.call(ScientificButton.fact),
            ),
            StackedButton.vertical(
              firstChild: Text(ScientificButton.sin.name),
              secondChild: Text(ScientificButton.cos.name),
              onFirstChildPressed: () =>
                  onScientificButtonsPressed?.call(ScientificButton.sin),
              onSecondChildPressed: () =>
                  onScientificButtonsPressed?.call(ScientificButton.cos),
            ),
            StackedButton.vertical(
              firstChild: Text(ScientificButton.tan.name),
              secondChild: Text(ScientificButton.log.name),
              onFirstChildPressed: () =>
                  onScientificButtonsPressed?.call(ScientificButton.tan),
              onSecondChildPressed: () =>
                  onScientificButtonsPressed?.call(ScientificButton.log),
            ),
            StackedButton(
              firstChild: Text(ScientificButton.sqrt.value.replaceAll('(', '')),
              secondChild: Text(ScientificButton.pi.value),
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
              firstChild: const Text(''),
              secondChild: const Text('INV'),
              onFirstChildPressed: () {},
              onSecondChildPressed: () {},
            ),
            StackedButton.vertical(
              firstChild: Text(ScientificButton.asin.name),
              secondChild: Text(ScientificButton.acos.name),
              onFirstChildPressed: () =>
                  onScientificButtonsPressed?.call(ScientificButton.asin),
              onSecondChildPressed: () =>
                  onScientificButtonsPressed?.call(ScientificButton.acos),
            ),
            StackedButton.vertical(
              firstChild: const Text('10\u02e3'),
              secondChild: const Text('e\u02e3'),
              onFirstChildPressed: () {},
              onSecondChildPressed: () {},
            ),
            StackedButton(
              firstChild: Text(ScientificButton.e.value),
              secondChild: Text(ScientificButton.ln.name),
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
