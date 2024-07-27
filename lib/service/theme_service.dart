import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:neumorphic_calculator/di/di.dart';
import 'package:neumorphic_calculator/service/preference_service.dart';
import 'package:neumorphic_calculator/utils/enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class ThemeService {
  ThemeService(SharedPreferences sharedPreferences, this.preferencesService) {
    _sharedPreferences = sharedPreferences;
  }
  static ThemeService get instance => getIt<ThemeService>();

  static late SharedPreferences _sharedPreferences;
  final PreferencesService preferencesService;

  static const String _themeModeKey = 'theme_mode';
  static const String _themeKey = 'theme';

  static late ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;

  static late ThemeData _lightTheme;
  ThemeData get lightTheme => _lightTheme;

  static late ThemeData _darkTheme;
  ThemeData get darkTheme => _darkTheme;

  static late ThemeType _themeType;
  ThemeType get themeType => _themeType;

  @PostConstruct()
  void init() {
    _themeMode = _loadThemeMode();
    _themeType = _loadTheme();
    _lightTheme = preferencesService.settingsModel.font
        .setToTheme(_themeType.themeData.$1);
    _darkTheme = preferencesService.settingsModel.font
        .setToTheme(_themeType.themeData.$2);
  }

  static ThemeMode _loadThemeMode() {
    try {
      final int? themeModeIndex = _sharedPreferences.getInt(_themeModeKey);
      if (themeModeIndex != null) {
        return ThemeMode.values[themeModeIndex];
      }
      return ThemeMode.system;
    } catch (_) {
      return ThemeMode.system;
    }
  }

  static ThemeType _loadTheme() {
    try {
      final int? themeIndex = _sharedPreferences.getInt(_themeKey);
      if (themeIndex != null) {
        return ThemeType.values[themeIndex];
      }
      return ThemeType.blue;
    } catch (_) {
      return ThemeType.blue;
    }
  }

  void saveTheme(ThemeType type) {
    try {
      _sharedPreferences.setInt(_themeKey, type.index);
      _themeType = type;
    } catch (_) {}
  }

  void saveThemeMode(ThemeMode themeMode) {
    try {
      _sharedPreferences.setInt(_themeModeKey, themeMode.index);
      _themeMode = themeMode;
    } catch (_) {}
  }

  void updateFont(Fonts font) {
    _lightTheme = font.setToTheme(_themeType.themeData.$1);
    _darkTheme = font.setToTheme(_themeType.themeData.$2);
  }
}
