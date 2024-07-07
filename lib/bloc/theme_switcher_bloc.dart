import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_switcher_event.dart';
part 'theme_switcher_state.dart';

class ThemeSwitcherBloc extends Bloc<ThemeSwitcherEvent, ThemeSwitcherState> {
  ThemeSwitcherBloc() : super(const ThemeSwitcherLoaded(ThemeState())) {
    on<UpdateTheme>(_onUpdateTheme);
  }

  void _onUpdateTheme(UpdateTheme event, Emitter<ThemeSwitcherState> emit) {
    emit(ThemeSwitcherLoaded(
      ThemeState(
        themeMode: event.themeMode ?? ThemeMode.system,
        lightTheme: event.lightTheme,
        darkTheme: event.darkTheme,
      ),
    ));
  }

  void _animateChange() {}
}
