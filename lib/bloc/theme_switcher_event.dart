part of 'theme_switcher_bloc.dart';

sealed class ThemeSwitcherEvent extends Equatable {
  const ThemeSwitcherEvent();
}

final class LoadTheme extends ThemeSwitcherEvent {
  @override
  List<Object?> get props => [];
}

final class UpdateTheme extends ThemeSwitcherEvent {
  final ThemeMode? themeMode;
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;

  const UpdateTheme({
    this.themeMode,
    this.lightTheme,
    this.darkTheme,
  });

  @override
  List<Object?> get props => [
        themeMode,
        lightTheme,
        darkTheme,
      ];
}
