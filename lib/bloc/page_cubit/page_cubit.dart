import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:neumorphic_calculator/di/di.dart';

part 'page_state.dart';

@injectable
class PageCubit extends Cubit<PageState> {
  PageCubit() : super(const Initial());

  void updateIndex(int index) {
    switch (index) {
      case -1:
        emit(const Initial());
        break;
      case 0:
        emit(const NavigateToSettings());
        break;
      case 1:
        emit(const NavigateToMain());
        break;
      case 2:
        emit(const NavigateToHistory());
        break;
    }
  }

  static PageCubit get instance => getIt<PageCubit>();
}
