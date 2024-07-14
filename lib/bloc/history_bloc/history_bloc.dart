import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:neumorphic_calculator/di/di.dart';
import 'package:neumorphic_calculator/repo/database.dart';
import 'package:neumorphic_calculator/utils/result_model.dart';

part 'history_event.dart';
part 'history_state.dart';

@injectable
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc(Database database)
      : _database = database,
        super(HistoryInitial()) {
    on<LoadHistory>(_loadHistory);
    on<AddHistory>(_addHistory);
    on<ClearHistory>(_clearHistory);
  }

  void _loadHistory(LoadHistory event, Emitter<HistoryState> emit) {
    emit(HistoryLoading());
    final result = _database.getStringList(_historyKey);
    if (result == null || result.isEmpty) {
      return emit(const HistoryEmpty());
    } else {
      final List<ResultModel> results = result
          .map((String e) => ResultModel.fromJson(jsonDecode(e)))
          .toList();
      emit(HistoryLoaded(results));
    }
  }

  void _addHistory(AddHistory event, Emitter<HistoryState> emit) {
    List<String> result = _database.getStringList(_historyKey) ?? [];

    result.insert(0, jsonEncode(event.result.toJson()));
    _database.setStringList(_historyKey, result);
    emit(HistoryLoaded(result
        .map((String e) => ResultModel.fromJson(jsonDecode(e)))
        .toList()));
  }

  void _clearHistory(ClearHistory event, Emitter<HistoryState> emit) {
    _database.remove(_historyKey);
    emit(const HistoryEmpty());
  }

  final Database _database;
  static const String _historyKey = 'history';
  static HistoryBloc get instance => getIt<HistoryBloc>();
}
