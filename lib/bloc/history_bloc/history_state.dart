part of 'history_bloc.dart';

sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

final class HistoryInitial extends HistoryState {}

final class HistoryLoading extends HistoryState {}

final class HistoryEmpty extends HistoryState {
  const HistoryEmpty();
}

final class HistoryLoaded extends HistoryState {
  final List<ResultModel> results;
  const HistoryLoaded(this.results);

  @override
  List<Object> get props => [results];
}

final class HistoryFailure extends HistoryState {
  final String error;
  const HistoryFailure(this.error);
  @override
  List<Object> get props => [error];
}
