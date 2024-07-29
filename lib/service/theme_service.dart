import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:neumorphic_calculator/di/di.dart';
import 'package:neumorphic_calculator/service/preference_service.dart';
import 'package:neumorphic_calculator/utils/enum.dart';
import 'package:neumorphic_calculator/utils/extensions/color_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system_theme/system_theme.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

@singleton
class ThemeService {
  ThemeService(SharedPreferences sharedPreferences, this.preferencesService) {
    _sharedPreferences = sharedPreferences;
  }
  static ThemeService get instance => getIt<ThemeService>();

  static late SharedPreferences _sharedPreferences;
  final PreferencesService preferencesService;

  static const String _themeModeKey = 'theme_mode';

  static late ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;

  static late ThemeData _lightTheme;
  ThemeData get lightTheme => _lightTheme;

  static late ThemeData _darkTheme;
  ThemeData get darkTheme => _darkTheme;

  @PostConstruct()
  void init() {
    _themeMode = _loadThemeMode();
    _loadTheme();
  }

  void _loadTheme() {
    final accentColor = SystemTheme.accentColor.accent;
    final themeColor = preferencesService.settingsModel.themeColor.color;
    if (preferencesService.settingsModel.dynamicColor &&
        accentColor != SystemTheme.fallbackColor &&
        defaultTargetPlatform.supportsAccentColor) {
      loadTheme(accentColor);
    } else {
      loadTheme(themeColor);
    }
  }

  void loadTheme(Color color) {
    final textTheme = PreferencesService.instance.settingsModel.font.textTheme;
    _lightTheme = color.getTheme(textTheme);
    _darkTheme = color.getTheme(textTheme, brightness: Brightness.dark);
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

  void saveThemeMode(ThemeMode themeMode) {
    try {
      _sharedPreferences.setInt(_themeModeKey, themeMode.index);
      _themeMode = themeMode;
    } catch (_) {}
  }

  void updateFont(Fonts font) {
    _lightTheme = font.setToTheme(_lightTheme);
    _darkTheme = font.setToTheme(_darkTheme);
  }
}
