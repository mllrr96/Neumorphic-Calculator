import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

extension CalculatorExtension on String {
  String get input => this;

  String calculate({bool skipErrorChecking = false, Parser? parser}) {
    Parser p = parser ?? Parser();
    String finalInput = input;
    finalInput = finalInput.replaceAll('x', '*');
    finalInput = finalInput.replaceAll('÷', '/');
    if (finalInput.endsWith('%')) {
      finalInput = finalInput.replaceAll('%', '/100');
    } else {
      finalInput = finalInput.replaceAll('%', '/100*');
    }
    bool hasDouble = finalInput.contains('.');
    try {
      Expression exp = p.parse(finalInput);
      ContextModel ctxModel = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, ctxModel);
      if (eval % 1 == 0 && !hasDouble) {
        return eval.toInt().toString();
      } else {
        return eval.toString();
      }
      // result = eval.toString();
    } catch (e) {
      if (skipErrorChecking) {
        return '';
      } else {
        return 'Format Error';
      }
    }
  }

  bool get isNumber => double.tryParse(input) != null;

  bool get canCalculate {
    if (input.isEmpty ||
        (!input.contains('x') &&
            !input.contains('÷') &&
            !input.contains('+') &&
            !input.contains('-'))) {
      return false;
    }
    if (input.endsWith('x') ||
        input.endsWith('÷') ||
        input.endsWith('+') ||
        input.endsWith('-')) {
      return false;
    }
    return true;
  }
}

extension TextEditingContollerExtension on TextEditingController {
  bool get noSelection =>
      selection.base.offset == -1 || selection.base.offset == text.length;

  void removeLastCharacter() {
    try {
      if (text.isNotEmpty && noSelection) {
        text = text.substring(0, text.length - 1);
      }
    } catch (_) {}
  }

  void addTextToOffset(String value) {
    try {
      final offset = selection.base.offset;
      final firstPart = text.substring(0, offset);
      final lastPart = text.substring(offset);
      final oldOffset = offset;
      // To avoid adding multiple operators in a row
      if ((firstPart.endsWith('x') ||
              firstPart.endsWith('÷') ||
              firstPart.endsWith('+') ||
              firstPart.endsWith('-') ||
              firstPart.endsWith('%')) &&
          !value.isNumber) {
        text = firstPart.substring(0, offset - 1) + value + lastPart;
        selection = TextSelection.collapsed(offset: oldOffset);
      } else if ((lastPart.startsWith('x') ||
              lastPart.startsWith('÷') ||
              lastPart.startsWith('+') ||
              lastPart.startsWith('-') ||
              lastPart.startsWith('%')) &&
          !value.isNumber) {
        text = firstPart + value + lastPart.substring(1);
        selection = TextSelection.collapsed(offset: oldOffset);
      } else {
        text = firstPart + value + lastPart;
        selection = TextSelection.collapsed(offset: oldOffset + 1);
      }
    } catch (_) {}
  }

  void removeTextAtOffset() {
    try {
      final offset = selection.base.offset;
      final firstPartWithoutLastCharacter = text.substring(0, offset - 1);
      final lastPart = text.substring(offset);
      final oldOffset = offset;
      text = firstPartWithoutLastCharacter + lastPart;
      selection = TextSelection.collapsed(offset: oldOffset - 1);
    } catch (_) {}
  }
}
