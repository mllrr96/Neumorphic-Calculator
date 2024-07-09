import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'string_extension.dart';

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

  String? onNumberPressed(String number, {Parser? parser}) {
    if (noSelection) {
      text += number;
    } else {
      addTextToOffset(number);
    }
    if (text.canCalculate) {
      return text.calculate(parser: parser);
    }
    return null;
  }

  String? onBackspacePressed(Parser parser) {
    if (text.isNotEmpty && noSelection) {
      removeLastCharacter();
      if (text.isEmpty) {
        return '';
      }
      if (text.canCalculate) {
        return text.calculate(parser: parser, skipErrorChecking: true);
      } else {
        return '';
      }
    } else {
      removeTextAtOffset();
    }
    return null;
  }

  String? onEqualPressed(Parser parser) {
    if (text.endsWith('x') ||
        text.endsWith('÷') ||
        text.endsWith('+') ||
        text.endsWith('-')) {
      return null;
    }
    return text.calculate(parser: parser);
  }

  bool onDecimalPressed() {
    if (text.isEmpty) {
      text += '0.';
    } else if (noSelection && !text.endsWith('.')) {
      text += '.';
    } else if (text.contains('.') && noSelection) {
      return false;
    } else {
      addTextToOffset('.');
    }
    return true;
  }

  String? onOperationPressed(String operator, {Parser? parser}) {
    if ((text.endsWith('+') ||
            text.endsWith('-') ||
            text.endsWith('x') ||
            text.endsWith('÷') ||
            text.isEmpty) &&
        noSelection) {
      removeLastCharacter();
      text += operator;
    } else if (text.isEmpty || noSelection) {
      text += operator;
    } else {
      addTextToOffset(operator);
    }
    if (text.canCalculate) {
      return text.calculate(parser: parser);
    }
    return null;
  }
}
