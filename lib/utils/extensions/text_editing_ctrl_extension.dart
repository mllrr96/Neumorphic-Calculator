import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:neumorphic_calculator/utils/result_model.dart';
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
      if (firstPart.endsWithAny(['x', '÷', '+', '-', '%']) && !value.isNumber) {
        text = firstPart.substring(0, offset - 1) + value + lastPart;
        selection = TextSelection.collapsed(offset: oldOffset);
      } else if (lastPart.startsWithAny(['x', '÷', '+', '-', '%']) &&
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

  ResultModel? onNumberPressed(String number, {Parser? parser}) {
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

  ResultModel? onBackspacePressed(Parser parser) {
    if (text.isNotEmpty && noSelection) {
      removeLastCharacter();
      if (text.isEmpty) {
        return ResultModel.empty();
      }
      if (text.canCalculate) {
        return text.calculate(parser: parser, skipErrorChecking: true);
      } else {
        return ResultModel.empty();
      }
    } else {
      removeTextAtOffset();
    }
    return null;
  }

  ResultModel? onEqualPressed(Parser parser) {
    if (text.isEmpty) {
      return null;
    }
    if (text.endsWithAny(['x', '÷', '+', '-'])) {
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

  ResultModel? onOperationPressed(String operator, {Parser? parser}) {
    try {
      // If no selection the user is typing a new expression
      if (noSelection) {
        // Do not allow adding oeprators in the beginning unless it's (-)
        if (text.isEmpty) {
          if (operator == '-') {
            text += operator;
          }
          return null;
        }

        // allow adding negative numbers after operation symbols
        if (operator == '-' && text.endsWithAny(['x', '÷', '+'])) {
          text += operator;
        } else
        // If the user tries to add an operator after another operator, replace the last operator with the new one
        if (text.endsWithAny(['x', '÷', '+', '-'])) {
          if (text.length != 1 && text != '-') {
            removeLastCharacter();
            text += operator;
          }
        }
        // If the user tries to add an operator after a number, add the operator
        else {
          text += operator;
        }
      } else {
        // Need to handle updating negative numbers
        addTextToOffset(operator);
      }
      if (text.canCalculate) {
        return text.calculate(parser: parser);
      }
      return null;
    } catch (_) {
      return ResultModel.error('Internal Error');
    }
  }
}
