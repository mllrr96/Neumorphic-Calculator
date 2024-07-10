import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';

extension CalculatorExtension on String {
  String get input => this;

  String calculate({bool skipErrorChecking = false, Parser? parser}) {
    Parser p = parser ?? Parser();
    String finalInput = input;
    finalInput = finalInput.replaceAll('x', '*');
    finalInput = finalInput.replaceAll('÷', '/');
    finalInput = finalInput.replaceAll('%', '/100');
    finalInput = finalInput.replaceAll(',', '');
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
    } catch (e) {
      if (skipErrorChecking) {
        return '';
      } else {
        return 'Format Error';
      }
    }
  }

  bool get isNumber =>
      double.tryParse(input) != null || int.tryParse(input) != null;

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

  String formatExpression(NumberFormat formatter) {
    String expression = replaceAll(',', '');
    String parts = expression.splitMapJoin(
      RegExp(r"[+\-x÷%]"),
      onMatch: (m) => m.group(0)!,
      onNonMatch: (n) {
        return n.replaceAll(' ', '').formatThousands(formatter);
      },
    );
    return parts;
  }

  String formatThousands(NumberFormat formatter) {
    String number = this;
    if (number.replaceAll(' ', '').isEmpty) return number;

    if (!number.isNumber) {
      return number;
    }

    final isInt = !number.contains('.');
    if (isInt) {
      formatter = NumberFormat("#,###");
      final partAsInt = int.tryParse(number);
      if (partAsInt == null) {
        return number;
      }
      String formattedString = formatter.format(int.tryParse(number));

      return formattedString;
    } else {
      bool shouldAddDecimal;
      if (number.characters.last == '.') {
        shouldAddDecimal = true;
      } else {
        shouldAddDecimal = false;
      }
      // Remove trailing decimal point if there is more than one decimal point
      if (number.endsWith('.') &&
          number.substring(0, number.length - 1).contains('.')) {
        shouldAddDecimal = false;
        number = number.substring(0, number.length - 1);
      }
      final numOfDecimalPlaces =
          number.split('.').last == '0' ? 1 : number.split('.').last.length;
      formatter =
          NumberFormat.decimalPatternDigits(decimalDigits: numOfDecimalPlaces);
      final partAsDouble = double.tryParse(number);
      if (partAsDouble == null) {
        return number;
      }
      String formattedString = formatter.format(double.tryParse(number)) +
          (shouldAddDecimal ? '.' : '');

      return formattedString;
    }
  }

  bool endsWithAny(List<String> suffixes) {
    for (final suffix in suffixes) {
      if (input.endsWith(suffix)) {
        return true;
      }
    }
    return false;
  }

  bool startsWithAny(List<String> prefixes) {
    for (final prefix in prefixes) {
      if (input.startsWith(prefix)) {
        return true;
      }
    }
    return false;
  }
}

extension StringExtension on String {
  String get capitilize => this[0].toUpperCase() + substring(1);
}
