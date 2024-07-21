import 'package:flutter/material.dart';
import 'package:neumorphic_calculator/widgets/neumorphic_button.dart';
import 'package:neumorphic_calculator/widgets/stacked_button.dart';
import '../calculator_icons.dart';
import '../utils/enum.dart';

class NumberPad extends StatefulWidget {
  const NumberPad(
      {super.key,
      this.onNumberPressed,
      this.onOperationPressed,
      this.onAdditionalButtonsPressed});
  final void Function(String number)? onNumberPressed;
  final void Function(CalculatorButton button)? onOperationPressed;
  final void Function(ScientificButton value)? onAdditionalButtonsPressed;

  @override
  State<NumberPad> createState() => _NumberPadState();
}

class _NumberPadState extends State<NumberPad> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool showAdditionalButtons = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 0, end: 100).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    TextStyle numberStyle = TextStyle(
        color: Theme.of(context).iconTheme.color,
        fontSize: 24,
        fontWeight: FontWeight.bold);
    TextStyle operationStyle = TextStyle(
        color: primaryColor, fontSize: 24, fontWeight: FontWeight.w900);
    final additionalButtons = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        StackedButton(
          firstChild: Text(ScientificButton.pow.value),
          secondChild: Text(ScientificButton.fact.value),
          onFirstChildPressed: () =>
              widget.onAdditionalButtonsPressed?.call(ScientificButton.pow),
          onSecondChildPressed: () =>
              widget.onAdditionalButtonsPressed?.call(ScientificButton.fact),
        ),
        StackedButton.vertical(
          firstChild: Text(ScientificButton.sin.value.replaceAll('(', '')),
          secondChild: Text(ScientificButton.cos.value.replaceAll('(', '')),
          onFirstChildPressed: () =>
              widget.onAdditionalButtonsPressed?.call(ScientificButton.sin),
          onSecondChildPressed: () =>
              widget.onAdditionalButtonsPressed?.call(ScientificButton.cos),
        ),
        StackedButton.vertical(
          firstChild: Text(ScientificButton.tan.value.replaceAll('(', '')),
          secondChild: Text(ScientificButton.log.value.replaceAll('(', '')),
          onFirstChildPressed: () =>
              widget.onAdditionalButtonsPressed?.call(ScientificButton.tan),
          onSecondChildPressed: () =>
              widget.onAdditionalButtonsPressed?.call(ScientificButton.log),
        ),
        StackedButton(
          firstChild: Text(ScientificButton.sqrt.value),
          secondChild: Text(ScientificButton.pi.value),
          onFirstChildPressed: () =>
              widget.onAdditionalButtonsPressed?.call(ScientificButton.sqrt),
          onSecondChildPressed: () =>
              widget.onAdditionalButtonsPressed?.call(ScientificButton.pi),
        ),
      ],
    );
    final additionalButtons2 = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        StackedButton.vertical(
          firstChild: const Text(''),
          secondChild: const Text('INV'),
          onFirstChildPressed: () {},
          onSecondChildPressed: () {},
        ),
        StackedButton.vertical(
          firstChild: Text(ScientificButton.asin.value.replaceAll('(', '')),
          secondChild: Text(ScientificButton.acos.value.replaceAll('(', '')),
          onFirstChildPressed: () =>
              widget.onAdditionalButtonsPressed?.call(ScientificButton.asin),
          onSecondChildPressed: () =>
              widget.onAdditionalButtonsPressed?.call(ScientificButton.acos),
        ),
        StackedButton.vertical(
          firstChild: const Text('10\u02e3'),
          secondChild: const Text('e\u02e3'),
          onFirstChildPressed: () {},
          onSecondChildPressed: () {},
        ),
        StackedButton(
          firstChild: Text(ScientificButton.e.value.replaceAll('(', '')),
          secondChild: Text(ScientificButton.ln.value.replaceAll('(', '')),
          onFirstChildPressed: () =>
              widget.onAdditionalButtonsPressed?.call(ScientificButton.e),
          onSecondChildPressed: () =>
              widget.onAdditionalButtonsPressed?.call(ScientificButton.ln),
        ),
      ],
    );
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // AnimatedSwitcher(
        //     duration: const Duration(milliseconds: 200),
        //     child: showAdditionalButtons
        //         ? additionalButtons
        //         : const SizedBox.shrink(),
        //     transitionBuilder: (child, animation) {
        //       return SizeTransition(sizeFactor: animation, child: child);
        //     }),
        // AnimatedSwitcher(
        //     duration: const Duration(milliseconds: 200),
        //     child: showAdditionalButtons
        //         ? additionalButtons
        //         : const SizedBox.shrink(),
        //     transitionBuilder: (child, animation) {
        //       return SizeTransition(sizeFactor: animation, child: child);
        //     }),
        additionalButtons2,
        additionalButtons,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NeumorphicButton(
              child:
                  Text(CalculatorButton.allClear.value, style: operationStyle),
              onPressed: () {
                if (_controller.isCompleted) {
                  _controller.reverse();
                } else {
                  _controller.forward();
                }
                setState(() {
                  showAdditionalButtons = !showAdditionalButtons;
                });
                widget.onOperationPressed?.call(CalculatorButton.allClear);
              },
            ),
            SizedBox(
                width: 75,
                child: StackedButton(
                  firstChild: const Text('('),
                  secondChild: const Text(')'),
                  onFirstChildPressed: () => widget.onOperationPressed
                      ?.call(CalculatorButton.openParenthesis),
                  onSecondChildPressed: () => widget.onOperationPressed
                      ?.call(CalculatorButton.closeParenthesis),
                )),
            NeumorphicButton(
              child: Icon(CalculatorIcons.percentage,
                  color: primaryColor, size: 24),
              onPressed: () =>
                  widget.onOperationPressed?.call(CalculatorButton.percent),
            ),
            NeumorphicButton(
              child:
                  Icon(CalculatorIcons.divide, color: primaryColor, size: 24),
              onPressed: () =>
                  widget.onOperationPressed?.call(CalculatorButton.divide),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NeumorphicButton(
              child: Text(CalculatorButton.seven.value, style: numberStyle),
              onPressed: () =>
                  widget.onNumberPressed?.call(CalculatorButton.seven.value),
            ),
            NeumorphicButton(
              child: Text(CalculatorButton.eight.value, style: numberStyle),
              onPressed: () =>
                  widget.onNumberPressed?.call(CalculatorButton.eight.value),
            ),
            NeumorphicButton(
              child: Text(CalculatorButton.nine.value, style: numberStyle),
              onPressed: () =>
                  widget.onNumberPressed?.call(CalculatorButton.nine.value),
            ),
            NeumorphicButton(
              child:
                  Icon(CalculatorIcons.cancel, color: primaryColor, size: 24),
              onPressed: () =>
                  widget.onOperationPressed?.call(CalculatorButton.multiply),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NeumorphicButton(
              child: Text(CalculatorButton.four.value, style: numberStyle),
              onPressed: () =>
                  widget.onNumberPressed?.call(CalculatorButton.four.value),
            ),
            NeumorphicButton(
              child: Text(CalculatorButton.five.value, style: numberStyle),
              onPressed: () =>
                  widget.onNumberPressed?.call(CalculatorButton.five.value),
            ),
            NeumorphicButton(
              child: Text(CalculatorButton.six.value, style: numberStyle),
              onPressed: () =>
                  widget.onNumberPressed?.call(CalculatorButton.six.value),
            ),
            NeumorphicButton(
              child: Icon(CalculatorIcons.minus, color: primaryColor, size: 24),
              onPressed: () =>
                  widget.onOperationPressed?.call(CalculatorButton.subtract),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NeumorphicButton(
              child: Text(CalculatorButton.one.value, style: numberStyle),
              onPressed: () =>
                  widget.onNumberPressed?.call(CalculatorButton.one.value),
            ),
            NeumorphicButton(
              child: Text(CalculatorButton.two.value, style: numberStyle),
              onPressed: () =>
                  widget.onNumberPressed?.call(CalculatorButton.two.value),
            ),
            NeumorphicButton(
              child: Text(CalculatorButton.three.value, style: numberStyle),
              onPressed: () =>
                  widget.onNumberPressed?.call(CalculatorButton.three.value),
            ),
            NeumorphicButton(
              child: Icon(CalculatorIcons.plus, color: primaryColor, size: 24),
              onPressed: () =>
                  widget.onOperationPressed?.call(CalculatorButton.add),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NeumorphicButton(
              child: Text(CalculatorButton.zero.value, style: numberStyle),
              onPressed: () =>
                  widget.onNumberPressed?.call(CalculatorButton.zero.value),
            ),
            NeumorphicButton(
              child:
                  Text(CalculatorButton.decimal.value, style: operationStyle),
              onPressed: () =>
                  widget.onOperationPressed?.call(CalculatorButton.decimal),
            ),
            NeumorphicButton(
              child: Icon(Icons.backspace, size: 24, color: primaryColor),
              onPressed: () =>
                  widget.onOperationPressed?.call(CalculatorButton.clear),
            ),
            NeumorphicButton(
              child: Icon(CalculatorIcons.calc, color: primaryColor, size: 24),
              onPressed: () =>
                  widget.onOperationPressed?.call(CalculatorButton.equal),
            ),
          ],
        ),
      ],
    );
  }
}
