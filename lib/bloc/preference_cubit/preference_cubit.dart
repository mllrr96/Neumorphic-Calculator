import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:neumorphic_calculator/di/di.dart';
import 'package:neumorphic_calculator/service/preference_service.dart';
import 'package:neumorphic_calculator/service/theme_service.dart';
import 'package:neumorphic_calculator/utils/settings_model.dart';

import 'preference_state.dart';

@injectable
class PreferenceCubit extends Cubit<PreferenceState> {
  PreferenceCubit(
      PreferencesService preferenceService, ThemeService themeService)
      : _service = preferenceService,
        _themeService = themeService,
        super(PreferenceState(SettingsModel.normal()));

  void loadSettings() {
    emit(PreferenceState(_service.settingsModel));
  }

  void updateSettings(SettingsModel settings) {
    final oldSettings = _service.settingsModel;
    if (oldSettings.font != settings.font) {
      _themeService.updateFont(settings.font);
    }
    _service.updateSettings(settings);
    emit(PreferenceState(settings));
  }

  final PreferencesService _service;
  final ThemeService _themeService;
  static PreferenceCubit get instance => getIt<PreferenceCubit>();
}
