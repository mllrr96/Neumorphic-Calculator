part of 'calculator_bloc.dart';

class CalculatorState extends Equatable {
  final String expression;
  final String output;
  final int? offset;
  final bool splash;
  const CalculatorState(
      {required this.expression,
      required this.output,
      this.offset,
      this.splash = false});
  const CalculatorState.initial(
      {this.expression = '',
      this.output = '',
      this.offset,
      this.splash = false});

  CalculatorState copyWith(
      {String? expression, String? output, int? offset, bool? splash}) {
    return CalculatorState(
      expression: expression ?? this.expression,
      output: output ?? this.output,
      offset: offset ?? this.offset,
      splash: false,
    );
  }

  @override
  List<Object?> get props => [expression, output, offset];
}
