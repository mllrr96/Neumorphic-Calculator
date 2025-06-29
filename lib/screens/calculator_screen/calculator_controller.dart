import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neumorphic_calculator/screens/history_screen/history_controller.dart';
import 'package:neumorphic_calculator/screens/settings_screen/settings_controller.dart';
import 'package:neumorphic_calculator/utils/extensions/extensions.dart';
import 'package:neumorphic_calculator/utils/result_model.dart';

class CalculatorController extends GetxController {
  static CalculatorController get instance => Get.find<CalculatorController>();

  String output = '';

  String get exp => textCtrl.text;

  bool isClearing = false;
  final textCtrl = TextEditingController();

  int get baseOffset => textCtrl.selection.baseOffset;

  @override
  void dispose() {
    textCtrl.dispose();
    super.dispose();
  }

  void updateExpression(String newExp, int? newOffset,
      {bool autoCalculate = true}) {
    textCtrl.value = TextEditingValue(
      text: newExp.formatExpression(),
      selection: TextSelection.collapsed(offset: newOffset ?? -1),
    );
    if (autoCalculate) {
      if (newExp.canCalculate) {
        _calculate(skipError: true);
      } else {
        output = '';
      }
    }
    update();
  }

  void _addNumber(String number, [int? position]) {
    try {
      String newExp;
      int newOffset = -1;
      if (exp.isNoSelection(baseOffset)) {
        newExp = exp + number;
      } else {
        final rawExp = exp.removeCommas;
        final rawPosition = _mapFormattedOffsetToRaw(exp, position!);

        final result = rawExp.insertText(number, rawPosition);

        newExp = result.$1.formatExpression();
        newOffset = _mapRawOffsetToFormatted(result.$1, newExp, result.$2);
      }
      updateExpression(newExp, newOffset);
    } catch (_) {
      updateExpression(exp + number, null);
    }
  }

  void _addOperator(String operator, [int? position]) {
    String newExp;
    int newOffset = -1;
    if (exp.isNoSelection(position)) {
      if (exp.isEmpty) {
        if (operator == '-') newExp = operator;
        return;
      }

      if (operator == '-' && exp.endsWithAny(['x', '÷', '+'])) {
        newExp = (exp + operator);
      } else if (exp.endsWithOperator) {
        if (exp.length > 1) {
          newExp = (exp.substring(0, exp.length - 1) + operator);
        } else {
          newExp = operator;
        }
      } else {
        newExp = (exp + operator);
        // offset.value = -1;
      }
    } else {
      final rawExp = exp.removeCommas;
      final rawPosition = _mapFormattedOffsetToRaw(exp, position!);

      final result = rawExp.insertText(operator, rawPosition);

      newExp = result.$1.formatExpression();
      newOffset = _mapRawOffsetToFormatted(result.$1, newExp, result.$2);
    }
    updateExpression(newExp, newOffset);
  }

  void _addDecimal([int? position]) {
    String newExp;
    int newOffset = -1;
    if (exp.isEmpty) {
      newExp = '0.';
    }

    if (exp.isNoSelection(position)) {
      final parts = exp.split(RegExp(r"[+\-x÷%]"));
      if (!parts.last.contains('.')) {
        newExp = '$exp.';
      } else {
        // If the last part already contains a decimal, do nothing
        return;
      }
    } else {
      final rawExp = exp.removeCommas;
      final rawPosition = _mapFormattedOffsetToRaw(exp, position!);

      final result = rawExp.insertText('.', rawPosition, skipFormatting: true);

      newExp = result.$1.formatExpression();

      newOffset = _mapRawOffsetToFormatted(result.$1, newExp, result.$2);
    }
    updateExpression(newExp, newOffset);
  }

  void _calculate({bool skipError = false}) {
    if (!exp.isValidForCalculation) {
      output = '';
      return;
    }

    try {
      final result = exp.calculate(skipErrorChecking: skipError);
      output = result.output;
    } catch (_) {
      output = 'Invalid expression';
    }
  }

  void _equals() {
    if (output.isEmpty || output.contains('/') || output.endsWithOperator) {
      return;
    }
    final isOutputValid = output.isDouble && !output.isInt;
    final newExp = output;
    output = isOutputValid ? output.toFraction : ' ';
    updateExpression(newExp, null, autoCalculate: false);
  }

  void _delete([int? position]) {
    // if (exp.isEmpty) {
    //   expression.value = exp;
    //   return;
    // }

    if (exp.isNoSelection(position)) {
      final newExp = exp.removeLastChar;
      if (!newExp.canCalculate) {
        output = '';
      }
      updateExpression(newExp, null);
    } else {
      final result = exp.removeCharAt(position!);
      updateExpression(result.$1, result.$2);
    }
    _mediumHaptic();
  }

  void _addParentheses(String p, [int? position]) {
    final isClose = p == ')';
    String newExp;
    int? newOffset;
    if (exp.isNoSelection(position)) {
      if (isClose) {
        final openCount = exp.count('(');
        final closeCount = exp.count(')');
        if (closeCount >= openCount) return; // prevent unbalanced close
      }
      newExp = (exp + p).formatExpression();
    } else {
      final result = exp.insertText(p, position!);
      newExp = result.$1;
      newOffset = result.$2;
    }
    updateExpression(newExp, newOffset);
  }

  /// Maps a cursor position in formatted text to raw text (without commas).
  int _mapFormattedOffsetToRaw(String formatted, int formattedOffset) {
    int rawOffset = 0;
    for (int i = 0; i < formattedOffset; i++) {
      if (formatted[i] != ',') {
        rawOffset++;
      }
    }
    return rawOffset;
  }

  /// Maps a cursor position in raw text to formatted text (with commas).
  int _mapRawOffsetToFormatted(String raw, String formatted, int rawOffset) {
    int count = 0;
    int formattedOffset = 0;
    while (formattedOffset < formatted.length && count < rawOffset) {
      if (formatted[formattedOffset] != ',') {
        count++;
      }
      formattedOffset++;
    }
    return formattedOffset;
  }

  void _mediumHaptic() {
    if (SettingsController.instance.state?.hapticEnabled ?? false) {
      HapticFeedback.mediumImpact();
    }
  }

  void _heavyHaptic() {
    if (SettingsController.instance.state?.hapticEnabled ?? false) {
      HapticFeedback.heavyImpact();
    }
  }

  void _saveResult(String expression, String output) {
    if (output.toLowerCase().contains('error') || output.isEmpty) return;
    final result = ResultModel(
      output: output,
      expression: expression,
      dateTime: DateTime.now(),
    );

    final historyController = Get.find<HistoryController>();
    final history = historyController.state ?? [];
    if (history.isEmpty || history.first != result) {
      historyController.addData(result);
    }
  }

  void onClearAllPressed() {
    if (exp.isNotEmpty && output.isNotEmpty) {
      isClearing = true;
    } else {
      output = '';
      textCtrl.clear();
    }
    update();
    _heavyHaptic();
  }

  void onEqualPressed() {
    final exp = this.exp;
    final output = this.output;
    _calculate();
    _equals();
    _saveResult(exp, output);
    _heavyHaptic();
  }

  void onDecimalPressed() {
    _addDecimal(baseOffset);
    _mediumHaptic();
  }

  void onOperatorPressed(String value) {
    _addOperator(value, baseOffset);
    _mediumHaptic();
  }

  void onDeletePressed() {
    _delete(baseOffset);
    _mediumHaptic();
  }

  void onParenthesesPressed(String value) {
    _addParentheses(value, baseOffset);
    _mediumHaptic();
  }

  void onNumberPressed(String number) {
    _addNumber(number, baseOffset);
    _mediumHaptic();
  }

  void onWipeComplete() {
    isClearing = false;
    output = '';
    textCtrl.clear();
    update();
  }
}
