part of 'history_bloc.dart';

sealed class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object> get props => [];
}

final class LoadHistory extends HistoryEvent {
  const LoadHistory();
}

final class AddHistory extends HistoryEvent {
  final ResultModel result;
  const AddHistory(this.result);
  @override
  List<Object> get props => [result];
}

final class ClearHistory extends HistoryEvent {
  const ClearHistory();
}
