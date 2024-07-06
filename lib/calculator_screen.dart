import 'package:day_night_themed_switch/day_night_themed_switch.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:neumorphic_calculator/extension.dart';
import 'button.dart';
import 'enum.dart';
import 'result_widget.dart';
import 'input_widget.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  CalculatorScreenState createState() => CalculatorScreenState();
}

class CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController controller = TextEditingController();
  String get input => controller.text;
  String result = '';
  Parser p = Parser();

  bool darkMode = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 80,
                child: DayNightSwitch(
                  value: darkMode,
                  onChanged: (val) {
                    darkMode = val;
                  },
                ),
              ),
              IconButton(
                padding: const EdgeInsets.all(16),
                onPressed: () {
                  // SystemNavigator.pop();
                },
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 2, child: InputWidget(controller)),
                  Expanded(child: ResultWidget(result)),
                ],
              ),
            )),
            Flexible(
              flex: 2,
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: CalculatorButton.values.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 14.0,
                    mainAxisSpacing: 14.0,
                    crossAxisCount: 4),
                itemBuilder: (context, index) {
                  return NeumorphicCustomButton(
                    onPressed: () {
                      CalculatorButton button = CalculatorButton.values[index];
                      if (button.isNumber) {
                        if (controller.noSelection) {
                          controller.text += button.value;
                        } else {
                          controller.addTextToOffset(button.value);
                        }
                        if (input.canCalculate) {
                          result = input.calculate(parser: p);
                        }
                      } else {
                        switch (button) {
                          case CalculatorButton.negative:
                            break;
                          case CalculatorButton.clear:
                            if (input.isNotEmpty && controller.noSelection) {
                              controller.eraseLastCharacter();
                              if (input.canCalculate) {
                                result = input.calculate(
                                    parser: p, skipErrorChecking: true);
                              }
                            } else {
                              controller.removeTextAtOffset();
                            }

                            if (input.isEmpty && result.isNotEmpty) {
                              result = '';
                            }
                            break;
                          case CalculatorButton.allClear:
                            // TODO: Add all clear animation to flush the screen
                            controller.text = '';
                            result = '';
                            break;
                          case CalculatorButton.equal:
                            if (input.isNotEmpty) {
                              result = input.calculate(parser: p);
                            }
                            break;
                          case CalculatorButton.decimal:
                            if (input.isEmpty) {
                              controller.text += '0.';
                            } else if (controller.noSelection &&
                                !input.endsWith('.')) {
                              controller.text += '.';
                            } else if (input.contains('.') &&
                                controller.noSelection) {
                              return;
                            } else {
                              controller.addTextToOffset('.');
                            }
                            break;
                          default:
                            if ((input.endsWith('+') ||
                                    input.endsWith('-') ||
                                    input.endsWith('x') ||
                                    input.endsWith('÷') ||
                                    input.isEmpty) &&
                                controller.noSelection) {
                              return;
                            }

                            if (input.isEmpty || controller.noSelection) {
                              controller.text += button.value;
                            } else {
                              controller.addTextToOffset(button.value);
                            }
                        }
                      }
                      setState(() {});
                    },
                    width: 40,
                    height: 40,
                    child: Center(
                      child: CalculatorButton.values[index] ==
                              CalculatorButton.clear
                          ? Icon(Icons.backspace_outlined,
                              size: 24, color: primaryColor)
                          : Text(
                              CalculatorButton.values[index].value,
                              style: TextStyle(
                                  color:
                                      CalculatorButton.values[index].isNumber ||
                                              CalculatorButton.values[index] ==
                                                  CalculatorButton.decimal
                                          ? Theme.of(context).iconTheme.color
                                          : primaryColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
