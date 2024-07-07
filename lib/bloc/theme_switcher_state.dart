part of 'theme_switcher_bloc.dart';

sealed class ThemeSwitcherState extends Equatable {
  const ThemeSwitcherState();
}

final class ThemeSwitcherInitial extends ThemeSwitcherState {
  @override
  List<Object> get props => [];
}
