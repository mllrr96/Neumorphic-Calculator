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
    if (finalInput.endsWith('%')) {
      finalInput = finalInput.replaceAll('%', '/100');
    } else {
      finalInput = finalInput.replaceAll('%', '/100*');
    }
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

  String formatExpression(NumberFormat formatter) {
    // Remove all commas
    final number = replaceAll(',', '');

    // Split the number by operators (+, -, *, /, %)
    List<String> parts = number.split(RegExp(r"[+\-/%x]"));

    // If the number is empty or only contains an operator, return the number
    if (parts.isEmpty) return number;
    if (parts.length == 1) return _formatThousands(parts[0], formatter);

    // Remove empty parts
    parts.removeWhere((part) => part.isEmpty);

    // Format each part with thousands separators
    List<String> formattedParts = parts
        .map((part) => _formatThousands(part.replaceAll(' ', ''), formatter))
        .toList();

    // List operators
    List<String> operators =
        number.replaceAll('.', '').replaceAll(RegExp(r"[0-9]+"), "").split('');

    // Rebuild the number with operators
    String result = '';
    for (int i = 0; i < formattedParts.length; i++) {
      result += formattedParts[i];
      if (i < operators.length) {
        result += operators[i];
      }
    }

    return result;
  }

  String _formatThousands(String value, NumberFormat formatter) {
    String part = value.replaceAll(',', "");
    final isInt = !part.contains('.');
    if (isInt) {
      formatter = NumberFormat("#,###");
      final partAsInt = int.tryParse(part);
      if (partAsInt == null) {
        return part;
      }
      return formatter.format(int.tryParse(part));
    } else {
      bool shouldAddDecimal;
      if (part.characters.last == '.') {
        shouldAddDecimal = true;
      } else {
        shouldAddDecimal = false;
      }
      // Remove trailing decimal point if there is more than one decimal point
      if (part.endsWith('.') &&
          part.substring(0, part.length - 1).contains('.')) {
        shouldAddDecimal = false;
        part = part.substring(0, part.length - 1);
      }
      final numOfDecimalPlaces =
          part.split('.').last == '0' ? 1 : part.split('.').last.length;
      formatter =
          NumberFormat.decimalPatternDigits(decimalDigits: numOfDecimalPlaces);
      final partAsDouble = double.tryParse(part);
      if (partAsDouble == null) {
        return part;
      }
      return formatter.format(double.tryParse(part)) +
          (shouldAddDecimal ? '.' : '');
    }
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

extension StringExtension on String {
  String get capitilize => this[0].toUpperCase() + substring(1);
}
