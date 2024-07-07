import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'theme_switcher_event.dart';
part 'theme_switcher_state.dart';

class ThemeSwitcherBloc extends Bloc<ThemeSwitcherEvent, ThemeSwitcherState> {
  ThemeSwitcherBloc() : super(ThemeSwitcherInitial()) {
    on<ThemeSwitcherEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
