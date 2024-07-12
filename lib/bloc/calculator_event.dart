part of 'calculator_bloc.dart';

sealed class CalculatorEvent extends Equatable {
  const CalculatorEvent();
}

final class ClearCalculator extends CalculatorEvent {
  const ClearCalculator();
  @override
  List<Object> get props => [];
}

final class DeleteEntry extends CalculatorEvent {
  final int offset;
  const DeleteEntry(this.offset);
  @override
  List<Object> get props => [];
}

final class AddNumber extends CalculatorEvent {
  final String number;
  final int offset;
  const AddNumber(this.number, this.offset);
  @override
  List<Object> get props => [number];
}

final class AddDecimal extends CalculatorEvent {
  final int offset;
  const AddDecimal(this.offset);
  @override
  List<Object> get props => [offset];
}

final class AddOperator extends CalculatorEvent {
  final String operator;
  final int offset;
  const AddOperator(this.operator, this.offset);
  @override
  List<Object> get props => [operator];
}

final class Calculate extends CalculatorEvent {
  const Calculate();
  @override
  List<Object> get props => [];
}

final class Equals extends CalculatorEvent {
  const Equals();
  @override
  List<Object> get props => [];
}

final class LoadHistory extends CalculatorEvent {
  final ResultModel result;
  const LoadHistory(this.result);
  @override
  List<Object> get props => [result];
}
