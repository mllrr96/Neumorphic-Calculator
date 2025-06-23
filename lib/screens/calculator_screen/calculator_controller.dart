import 'package:get/get.dart';
import 'package:neumorphic_calculator/utils/extensions/extensions.dart';
import 'package:neumorphic_calculator/utils/result_model.dart';

class CalculatorController extends GetxController {
  static CalculatorController get instance => Get.find<CalculatorController>();

  RxString expression = ''.obs;

  String get exp => expression.value;
  RxString output = ''.obs;
  RxInt offset = (-1).obs;

  @override
  void onInit() {
    debounce(expression, (_) {
      if (expression.value.canCalculate) {
        calculate(skipError: true);
      }
    }, time: const Duration(milliseconds: 100));
    super.onInit();
  }

  void _applyInsertion(String newExp, int newOffset) {
    expression.value = newExp.formatExpression();
    offset.value = newOffset;
  }

  // ─────────────────────────────────────────────────────
  // Number / Operator / Decimal
  // ─────────────────────────────────────────────────────

  void addNumber(String number, [int? position]) {
    final offsetVal = offset.value;

    if (exp.isNoSelection(offsetVal)) {
      expression.value = exp.needsMultiply
          ? ('${exp}x$number').formatExpression()
          : (exp + number).formatExpression();
      offset.value = -1;
    } else {
      final needsMultiply =
          exp.substring(0, position!).contains(RegExp(r'[eπ)]$'));
      final insertText = needsMultiply ? 'x$number' : number;
      final result = exp.insertText(insertText, position);
      _applyInsertion(result.$1, result.$2);
    }
  }

  void addOperator(String operator, [int? position]) {
    if (exp.isNoSelection(position)) {
      if (exp.isEmpty) {
        if (operator == '-') expression.value = operator;
        return;
      }

      if (operator == '-' && exp.endsWithAny(['x', '÷', '+'])) {
        expression.value = (exp + operator).formatExpression();
      } else if (exp.endsWithOperator) {
        if (exp.length > 1) {
          expression.value =
              (exp.substring(0, exp.length - 1) + operator).formatExpression();
        }
      } else {
        expression.value = (exp + operator).formatExpression();
        offset.value = -1;
      }
    } else {
      final result = exp.insertText(operator, position!);
      _applyInsertion(result.$1, result.$2);
    }
  }

  void addDecimal([int? position]) {
    if (exp.isEmpty) {
      expression.value = '0.';
      return;
    }

    if (exp.isNoSelection(position)) {
      final parts = exp.split(RegExp(r"[+\-x÷%]"));
      if (!parts.last.contains('.')) {
        expression.value = '$exp.';
      }
    } else {
      final result = exp.insertText('|', position!, skipFormatting: true);
      final parts = result.$1.split(RegExp(r"[+\-x÷%]"));
      final index = parts.indexWhere((e) => e.contains('|'));

      if (index != -1 && !parts[index].contains('.')) {
        expression.value = result.$1.replaceAll('|', '.').formatExpression();
        offset.value = result.$2;
      }
    }
  }

  // ─────────────────────────────────────────────────────
  // Calculation / Equals
  // ─────────────────────────────────────────────────────

  void calculate({bool skipError = false}) {
    if (!exp.isValidForCalculation) {
      output.value = '';
      return;
    }

    try {
      final result = exp.calculate(skipErrorChecking: skipError);
      output.value = result.output;
    } catch (_) {
      output.value = 'Internal Error';
    }
  }

  void equals() {
    final out = output.value;

    if (out.isEmpty || out.contains('/') || out.endsWithOperator) return;

    if (!out.isInt && out.isDouble) {
      expression.value = out;
      output.value = out.toFraction;
    } else {
      expression.value = out;
      output.value = ' ';
    }
  }

  // ─────────────────────────────────────────────────────
  // Clear / Delete / Load
  // ─────────────────────────────────────────────────────

  void clear() {
    final shouldSplash = expression.isNotEmpty && output.isNotEmpty;
    expression.value = '';
    output.value = shouldSplash ? ' ' : '';
  }

  void delete([int? position]) {
    if (exp.isEmpty) {
      expression.value = exp.formatExpression();
      return;
    }

    if (exp.isNoSelection(position)) {
      if (exp.isLastCharFunction) {
        final result = exp.removeLastFunction(position ?? -1);
        expression.value = result.$1.formatExpression();
      } else {
        expression.value = exp.removeLastChar.formatExpression();
      }
    } else {
      final before = exp.substring(0, position!);
      if (before.isLastCharFunction) {
        final firstPart = before.removeLastFunction(position);
        final result = firstPart.$1 + exp.substring(position);
        expression.value = result.formatExpression();
        offset.value = firstPart.$2;
      } else {
        final result = exp.removeCharAt(position);
        _applyInsertion(result.$1, result.$2);
      }
    }
  }

  void loadCalculation(ResultModel result) {
    expression.value = result.expression;
    output.value = result.output;
  }

  // ─────────────────────────────────────────────────────
  // Parentheses
  // ─────────────────────────────────────────────────────

  void addParentheses(String p, [int? position]) {
    final isClose = p == ')';

    if (exp.isNoSelection(position)) {
      if (exp.isEmpty && isClose) return;
      expression.value = (exp + p).formatExpression();
      offset.value = -1;
    } else {
      final result = exp.insertText(p, position!);
      _applyInsertion(result.$1, result.$2);
    }
  }

  void updateExpression(String newExp, {int offset = -1}) {
    expression.value = newExp.formatExpression();
    this.offset.value = offset;
  }
}
