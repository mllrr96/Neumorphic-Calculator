import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neumorphic_calculator/repo/database.dart';
import 'package:neumorphic_calculator/service/preference_service.dart';
import 'package:neumorphic_calculator/utils/const.dart';
import 'package:neumorphic_calculator/utils/enum.dart';
import 'package:neumorphic_calculator/utils/extensions/color_extension.dart';
import 'package:system_theme/system_theme.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

class ThemeController extends GetxController {
  ThemeController(this._repo, this.preferencesService);

  static ThemeController get instance => Get.find<ThemeController>();

  late final DatabaseRepository _repo;
  final PreferencesController preferencesService;

  final String _themeModeKey = AppConst.themeModeKey;

  late ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;

  late ThemeData _lightTheme;
  ThemeData get lightTheme => _lightTheme;

  late ThemeData _darkTheme;
  ThemeData get darkTheme => _darkTheme;

  @override
  void onInit() {
    _themeMode = _loadThemeMode();
    _loadThemes();
    super.onInit();
  }

  void _loadThemes() {
    final accentColor = SystemTheme.accentColor.accent;
    final themeColor = preferencesService.settingsModel.themeColor.color;
    if (preferencesService.settingsModel.dynamicColor &&
        accentColor != SystemTheme.fallbackColor &&
        defaultTargetPlatform.supportsAccentColor) {
      _applyColorToTheme(accentColor);
    } else {
      _applyColorToTheme(themeColor);
    }
  }

  void _applyColorToTheme(Color color) {
    final textTheme = PreferencesController.instance.settingsModel.font.textTheme;
    _lightTheme = color.getTheme(textTheme);
    _darkTheme = color.getTheme(textTheme, brightness: Brightness.dark);
    update();
  }

  ThemeMode _loadThemeMode() {
    try {
      final int? themeModeIndex = _repo.get<int>(_themeModeKey);
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
      _repo.set<int>(_themeModeKey, themeMode.index);
      _themeMode = themeMode;
      update();
    } catch (_) {}
  }

  void updateFont(Fonts font) {
    _lightTheme = font.setToTheme(_lightTheme);
    _darkTheme = font.setToTheme(_darkTheme);
    update();
  }

  void updateTheme(ThemeData light, ThemeData dark) {
    _lightTheme = light;
    _darkTheme = dark;
    update();
  }
}
