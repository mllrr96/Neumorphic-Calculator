part of 'page_cubit.dart';

sealed class PageState extends Equatable {
  const PageState();
  @override
  List<Object?> get props => [];
}

final class Initial extends PageState {
  const Initial();
}

final class NavigateToMain extends PageState {
  const NavigateToMain();
}

final class NavigateToHistory extends PageState {
  const NavigateToHistory();
}

final class NavigateToSettings extends PageState {
  const NavigateToSettings();
}
