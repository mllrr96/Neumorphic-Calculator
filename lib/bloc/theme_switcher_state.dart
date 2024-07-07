part of 'theme_switcher_bloc.dart';

sealed class ThemeSwitcherState extends Equatable {
  const ThemeSwitcherState();
}

final class ThemeSwitcherLoaded extends ThemeSwitcherState {
  const ThemeSwitcherLoaded(this.themeState);
  final ThemeState themeState;

  @override
  List<Object?> get props => [themeState];
}

class ThemeState extends Equatable {
  const ThemeState({
    this.themeMode = ThemeMode.system,
    this.lightTheme,
    this.darkTheme,
  });
  final ThemeMode themeMode;
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;

  factory ThemeState.defaultTheme() {
    return ThemeState(
      themeMode: ThemeMode.system,
      lightTheme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }

  ThemeState copyWith({
    ThemeMode? themeMode,
    ThemeData? lightTheme,
    ThemeData? darkTheme,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      lightTheme: lightTheme ?? this.lightTheme,
      darkTheme: darkTheme ?? this.darkTheme,
    );
  }

  @override
  List<Object?> get props => [themeMode, lightTheme, darkTheme];
}
