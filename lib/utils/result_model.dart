import 'package:equatable/equatable.dart';

class ResultModel extends Equatable {
  final String output;
  final String expression;
  final DateTime dateTime;
  const ResultModel({
    required this.output,
    required this.expression,
    required this.dateTime,
  });

  factory ResultModel.empty() {
    return ResultModel(
      output: '',
      expression: '',
      dateTime: DateTime.now(),
    );
  }

  factory ResultModel.formatError() {
    return ResultModel(
      output: 'Format Error',
      expression: '',
      dateTime: DateTime.now(),
    );
  }
  factory ResultModel.error(String error) {
    return ResultModel(
      output: error,
      expression: '',
      dateTime: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [output, expression, dateTime];
}
