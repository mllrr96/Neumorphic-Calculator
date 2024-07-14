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
  factory ResultModel.fromJson(Map<String, dynamic> json) {
    return ResultModel(
      output: json['output'],
      expression: json['expression'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'output': output,
      'expression': expression,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [output, expression];
}
