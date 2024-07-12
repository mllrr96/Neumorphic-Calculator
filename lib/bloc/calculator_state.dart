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

  CalculatorState copyWith({String? expression, String? output, int? offset}) {
    return CalculatorState(
      expression: expression ?? this.expression,
      output: output ?? this.output,
      offset: offset ?? this.offset,
    );
  }

  @override
  List<Object?> get props => [expression, output, offset];
}

// final class CalculatorResult extends Equatable {
//   final String expression;
//   final String output;
//   const CalculatorResult({required this.expression, required this.output});
//   const CalculatorResult.initial({this.expression = '', this.output = ''});

//   CalculatorResult copyWith({String? expression, String? output}) {
//     return CalculatorResult(
//       expression: expression ?? this.expression,
//       output: output ?? this.output,
//     );
//   }

//   @override
//   List<Object> get props => [expression, output];
// }
