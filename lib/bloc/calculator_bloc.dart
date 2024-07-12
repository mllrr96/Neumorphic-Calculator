import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neumorphic_calculator/utils/extensions/extensions.dart';
import 'package:neumorphic_calculator/utils/result_model.dart';
part 'calculator_event.dart';
part 'calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  CalculatorBloc() : super(const CalculatorState.initial()) {
    on<AddNumber>(_addNumber);
    on<AddOperator>(_addOperator);
    on<ClearCalculator>(_clearCalculator);
    on<DeleteEntry>(_deleteEntry);
    on<Calculate>(_calculate);
    on<AddDecimal>(_addDecimal);
    on<Equals>(_equals);
    on<LoadHistory>(_loadHistory);
  }

  _loadHistory(LoadHistory event, Emitter<CalculatorState> emit) {
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
    emit(state.copyWith(
      expression: state.expression + event.number,
    ));
  }

  _addDecimal(AddDecimal event, Emitter<CalculatorState> emit) {
    bool noSelection =
        event.offset == -1 || event.offset == state.expression.length;
    final expression = state.expression;
    if (expression.isEmpty) {
      emit(state.copyWith(expression: '0.'));
    } else if (noSelection && !expression.endsWith('.')) {
      emit(state.copyWith(expression: '$expression.'));
    } else if (expression.contains('.') && noSelection) {
      return;
    } else {
      emit(state.copyWith(
          expression: expression.insertText('.', event.offset).$1,
          offset: expression.insertText('.', event.offset).$2));
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
          return emit(state.copyWith(expression: expression + operator));
        } else
        // If the user tries to add an operator after another operator, replace the last operator with the new one
        if (expression.endsWithAny(['x', '÷', '+', '-'])) {
          if (expression.length != 1 && expression != '-') {
            return emit(state.copyWith(
                expression:
                    expression.substring(0, event.offset - 1) + operator));
          }
        }
        // If the user tries to add an operator after a number, add the operator
        else {
          return emit(state.copyWith(expression: expression + operator));
        }
      } else {
        // Need to handle updating negative numbers
        final result = expression.insertText(operator, event.offset);
        emit(state.copyWith(expression: result.$1, offset: result.$2));
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
      emit(state.copyWith(expression: expression.removeLastChar));
    }
    if (noOffset) {
      if (expression.isNotEmpty) {
        final result = expression.removeLastChar;
        emit(state.copyWith(expression: result));
      }
    } else {
      final result = expression.removeCharAt(event.offset);
      emit(state.copyWith(expression: result.$1, offset: result.$2));
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
      final result = expression.calculate();
      emit(state.copyWith(output: result.output));
    } catch (_) {
      emit(state.copyWith(output: 'Internal Error'));
    }
  }
}
