import 'package:day_night_themed_switch/day_night_themed_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';
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
  String input = '';
  String result = '';
  Parser p = Parser();

  void calculate({bool skipErrorChecking = false}) {
    String finalInput = input;
    finalInput = finalInput.replaceAll('x', '*');
    finalInput = finalInput.replaceAll('÷', '/');
    // finalInput = finalInput.replaceAll('%', '/100');
    bool hasDouble = finalInput.contains('.');
    try {
      Expression exp = p.parse(finalInput);
      ContextModel ctxModel = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, ctxModel);
      // if (eval % 1 == 0 && !hasDouble) {
      //   result = eval.toInt().toString();
      // } else {
      //   result = eval.toString();
      // }
      result = eval.toString();
    } catch (e) {
      print(e.toString());
      if (skipErrorChecking) {
        result = '';
      } else {
        result = 'Format Error';
      }
    }
  }

  bool get canCalculate {
    if (input.isEmpty) {
      return false;
    }
    if (input.contains('x') || input.contains('÷')) {
      return true;
    }
    if (input.contains('+') || input.contains('-')) {
      return true;
    }
    return false;
  }

  bool darkMode = false;

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
                  Expanded(flex: 2, child: InputWidget(input)),
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
                        input += button.value;
                        if (canCalculate) {
                          calculate();
                        }
                      } else {
                        switch (button) {
                          case CalculatorButton.negative:
                            break;
                          case CalculatorButton.clear:
                            if (input.isNotEmpty) {
                              input = input.substring(0, input.length - 1);
                              if (canCalculate) {
                                calculate(skipErrorChecking: true);
                              }
                            }
                            if (input.isEmpty && result.isNotEmpty) {
                              result = '';
                            }
                            break;
                          case CalculatorButton.allClear:
                            input = '';
                            result = '';
                            break;
                          case CalculatorButton.equal:
                            if (input.isNotEmpty) {
                              calculate();
                            }
                            break;
                          case CalculatorButton.decimal:
                            if (input.isEmpty) {
                              input += '0.';
                            } else if (input.contains('.')) {
                              return;
                            } else {
                              input += button.value;
                            }
                            break;
                          default:
                            if (input.endsWith('+') ||
                                input.endsWith('-') ||
                                input.endsWith('x') ||
                                input.endsWith('÷') ||
                                input.isEmpty) {
                              return;
                            }

                            if (input.isNotEmpty) {
                              input += button.value;
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
