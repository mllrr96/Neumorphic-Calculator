import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:neumorphic_calculator/di/di.dart';
import 'package:neumorphic_calculator/utils/enum.dart';
import 'package:neumorphic_calculator/utils/extensions/extensions.dart';
import 'package:neumorphic_calculator/utils/result_model.dart';
part 'calculator_event.dart';
part 'calculator_state.dart';

@injectable
class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  CalculatorBloc() : super(const CalculatorState.initial()) {
    on<AddNumber>(_addNumber);
    on<AddOperator>(_addOperator);
    on<ClearCalculator>(_clearCalculator);
    on<DeleteEntry>(_deleteEntry);
    on<Calculate>(_calculate);
    on<AddDecimal>(_addDecimal);
    on<Equals>(_equals);
    on<LoadCalculation>(_loadCalculation);
    on<AddParentheses>(_addParentheses);
    on<AddScientificButton>(_addScientificButton);
  }

  _addScientificButton(
      AddScientificButton event, Emitter<CalculatorState> emit) {
    final expression = state.expression;
    final offset = event.offset;
    final button = event.value;
    final noSelection = offset == -1 || offset == expression.length;
    switch (noSelection) {
      case true:
        if (expression.isEmpty) {
          emit(state.copyWith(
              expression: (expression + button.value).formatExpression(),
              offset: -1));
        } else {
          // Check if the last character is a number, pi, e,  or
          // a close parentheses to add a multiplication sign
          if (expression.contains(RegExp(r'[0-9)eπ]$'))) {
            emit(state.copyWith(
                expression:
                    ('${expression}x${button.value}').formatExpression(),
                offset: -1));
          } else {
            emit(state.copyWith(
                expression: (expression + button.value).formatExpression(),
                offset: -1));
          }
        }
        break;
      case false:
        final result = expression.insertScienticButton(button, offset);
        emit(state.copyWith(
            expression: result.$1.formatExpression(), offset: result.$2));
        break;
    }
  }

  _addParentheses(AddParentheses event, Emitter<CalculatorState> emit) {
    bool noSelection =
        event.offset == -1 || event.offset == state.expression.length;
    final expression = state.expression;
    final parentheses = event.parentheses;
    final isCloseParentheses = parentheses == ')';

    switch (noSelection) {
      case true:
        // Prevent adding ')' at the beginning of the expression
        if (expression.isEmpty && isCloseParentheses) {
          return;
        }
        return emit(
            state.copyWith(expression: expression + parentheses, offset: -1));

      case false:
        final result = expression.insertText(parentheses, event.offset);
        emit(state.copyWith(
            expression: result.$1.formatExpression(), offset: result.$2));
    }
  }

  _loadCalculation(LoadCalculation event, Emitter<CalculatorState> emit) {
    emit(state.copyWith(
        expression: event.result.expression, output: event.result.output));
  }

  _equals(Equals event, Emitter<CalculatorState> emit) {
    if (state.output.isEmpty || state.output.contains('/')) {
      return;
    }
    if (state.output.endsWithAny(['x', '÷', '+', '-'])) {
      return;
    }
    if (!state.output.isInt && state.output.isDouble) {
      emit(state.copyWith(
          expression: state.output, output: state.output.toFraction));
    } else {
      // Have space in output to trigger splash effect
      emit(state.copyWith(expression: state.output, output: ' '));
    }
  }

  _addNumber(AddNumber event, Emitter<CalculatorState> emit) {
    bool noSelection =
        event.offset == -1 || event.offset == state.expression.length;
    if (noSelection) {
      // Check if the last character is pi, e,  or
      // a close parentheses to add a multiplication sign
      if (state.expression.contains(RegExp(r'[eπ)]$'))) {
        emit(state.copyWith(
            expression:
                ('${state.expression}x${event.number}').formatExpression(),
            offset: -1));
      } else {
        emit(state.copyWith(
            expression: (state.expression + event.number).formatExpression(),
            offset: -1));
      }
    } else {
      (String, int) result;
      // Check if the last character before selection is pi, e,  or
      // a close parentheses to add a multiplication sign
      state.expression.substring(0, event.offset).contains(RegExp(r'[eπ)]$'))
          ? result =
              state.expression.insertText('x${event.number}', event.offset)
          : result = state.expression.insertText(event.number, event.offset);

      emit(state.copyWith(
          expression: result.$1.formatExpression(), offset: result.$2));
    }
  }

  _addDecimal(AddDecimal event, Emitter<CalculatorState> emit) {
    bool noSelection =
        event.offset == -1 || event.offset == state.expression.length;
    final expression = state.expression;
    if (expression.isEmpty) {
      return emit(state.copyWith(expression: '0.'));
    }
    switch (noSelection) {
      case true:
        final splittedExpression = expression.split(
          RegExp(r"[+\-x÷%]"),
        );

        if (splittedExpression.last.contains('.')) {
          return;
        }

        if (!splittedExpression.last.endsWith('.')) {
          return emit(state.copyWith(expression: '$expression.'));
        }
      case false:
        final result =
            expression.insertText('|', event.offset, skipFormatting: true);
        final index = result.$1
            .split(RegExp(r"[+\-x÷%]"))
            .indexWhere((e) => e.contains('|'));
        if (index == -1) {
          return;
        }
        final selectedText = result.$1.split(RegExp(r"[+\-x÷%]"))[index];
        if (selectedText.contains('.')) {
          return;
        } else {
          return emit(state.copyWith(
              expression: result.$1.replaceAll('|', '.').formatExpression(),
              offset: result.$2));
        }
    }
  }

  _addOperator(AddOperator event, Emitter<CalculatorState> emit) {
    bool noOffset =
        event.offset == -1 || event.offset == state.expression.length;
    String expression = state.expression;
    final operator = event.operator;
    try {
      // If no selection the user is typing a new expression
      if (noOffset) {
        // Do not allow adding oeprators in the beginning unless it's (-)
        if (expression.isEmpty) {
          if (operator == '-') {
            return emit(state.copyWith(expression: operator));
          }
          return;
        }

        // allow adding negative numbers after operation symbols
        if (operator == '-' && expression.endsWithAny(['x', '÷', '+'])) {
          return emit(state.copyWith(
              expression: (expression + operator).formatExpression()));
        } else
        // If the user tries to add an operator after another operator, replace the last operator with the new one
        if (expression.endsWithAny(['x', '÷', '+', '-'])) {
          if (expression.length != 1 && expression != '-') {
            return emit(state.copyWith(
                expression:
                    (expression.substring(0, event.offset - 1) + operator)
                        .formatExpression()));
          }
        }
        // If the user tries to add an operator after a number, add the operator
        else {
          return emit(
              state.copyWith(expression: expression + operator, offset: -1));
        }
      } else {
        // Need to handle updating negative numbers
        final result = expression.insertText(operator, event.offset);
        emit(state.copyWith(
            expression: result.$1.formatExpression(), offset: result.$2));
      }
    } catch (_) {
      emit(state.copyWith(output: 'Internal Error'));
    }
  }

  _clearCalculator(ClearCalculator event, Emitter<CalculatorState> emit) {
    emit(CalculatorState.initial(
        splash: state.expression.isNotEmpty && state.output.isNotEmpty));
  }

  _deleteEntry(DeleteEntry event, Emitter<CalculatorState> emit) {
    bool noOffset =
        event.offset == -1 || event.offset == state.expression.length;
    final expression = state.expression;

    if (expression.isEmpty) {
      emit(state.copyWith(expression: expression.formatExpression()));
    }

    switch (noOffset) {
      case true:
        if (expression.isNotEmpty) {
          // Check if the last character is cos, acos, sin, asin, tan, log, ln, or sqrt
          // to remove the whole function
          if (expression.isLastCharFunction) {
            final result = expression.removeLastFunction(event.offset);
            emit(state.copyWith(expression: result.$1.formatExpression()));
          } else {
            final result = expression.removeLastChar;
            emit(state.copyWith(expression: result.formatExpression()));
          }
        }
        break;
      case false:
        if (expression.substring(0, event.offset).isLastCharFunction) {
          final firstPart = expression
              .substring(0, event.offset)
              .removeLastFunction(event.offset);
          final result = firstPart.$1 + expression.substring(event.offset);
          emit(state.copyWith(
              expression: result.formatExpression(), offset: firstPart.$2));
        } else {
          final result = expression.removeCharAt(event.offset);
          emit(state.copyWith(
              expression: result.$1.formatExpression(), offset: result.$2));
        }
        break;
    }
  }

  _calculate(Calculate event, Emitter<CalculatorState> emit) {
    final expression = state.expression;
    if (expression.isEmpty) {
      return emit(state.copyWith(output: ''));
    }
    if (expression.endsWithAny(['x', '÷', '+', '-'])) {
      return emit(state.copyWith(output: ''));
    }
    try {
      final result = expression.calculate(skipErrorChecking: event.skipError);
      emit(state.copyWith(output: result.output));
    } catch (_) {
      emit(state.copyWith(output: 'Internal Error'));
    }
  }

  static CalculatorBloc get instance => getIt<CalculatorBloc>();
}
