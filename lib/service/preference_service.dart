import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neumorphic_calculator/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../utils/settings_model.dart';

class PreferencesService {
  static PreferencesService get instance => getIt<PreferencesService>();
  static late SharedPreferences _sharedPreferences;
  static const String _themeModeKey = 'theme_mode';
  static const String _themeKey = 'theme';
  static const String _settingsKey = 'settings';

  static late ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;

  static late ThemeData _lightTheme;
  ThemeData get lightTheme => _lightTheme;

  static late ThemeData _darkTheme;
  ThemeData get darkTheme => _darkTheme;

  static late ThemeType _themeType;
  ThemeType get themeType => _themeType;

  static late SettingsModel _settingsModel;
  SettingsModel get settingsModel => _settingsModel;

  static Future<PreferencesService> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _settingsModel = _loadSettingsModel();
    _themeMode = _loadThemeMode();
    _themeType = _loadTheme();
    _lightTheme = _settingsModel.font.setToTheme(_themeType.themeData.$1);
    _darkTheme = _settingsModel.font.setToTheme(_themeType.themeData.$2);
    return PreferencesService();
  }

  static SettingsModel _loadSettingsModel() {
    try {
      final settings = _sharedPreferences.getString(_settingsKey);
      Map<String, dynamic> settingsMap = jsonDecode(settings!);
      return SettingsModel.fromMap(settingsMap);
    } catch (_) {
      return SettingsModel.normal();
    }
  }

  void updateSettings(SettingsModel settingsModel) {
    try {
      // Check if font changed and update theme
      if (_settingsModel.font != settingsModel.font) {
        _lightTheme = settingsModel.font.setToTheme(_themeType.themeData.$1);
        _darkTheme = settingsModel.font.setToTheme(_themeType.themeData.$2);
      }
      _settingsModel = settingsModel;
      _sharedPreferences.setString(
          _settingsKey, jsonEncode(settingsModel.toMap()));
    } catch (_) {
      _settingsModel = settingsModel;
    }
  }

  void saveThemeMode(ThemeMode themeMode) {
    try {
      _sharedPreferences.setInt(_themeModeKey, themeMode.index);
      _themeMode = themeMode;
    } catch (_) {}
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

  void saveTheme(ThemeType type) {
    try {
      _sharedPreferences.setInt(_themeKey, type.index);
      _themeType = type;
    } catch (_) {}
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
}
