import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:neumorphic_calculator/di/di.dart';
import 'package:neumorphic_calculator/utils/result_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/settings_model.dart';

@singleton
class PreferencesService {
  PreferencesService(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
  }
  static PreferencesService get instance => getIt<PreferencesService>();
  static late SharedPreferences _sharedPreferences;
  static const String _settingsKey = 'settings';
  static const String _resultsKey = 'results';
  static const String _firstRunKey = 'firstRun';
  static const String _firstCallKey = 'firstKey';

  static late SettingsModel _settingsModel;
  SettingsModel get settingsModel => _settingsModel;

  static late List<ResultModel> _results;
  List<ResultModel> get results => _results;

  static bool get isFirstRun {
    if (_firstRun == null) {
      try {
        final bool firstRun = _sharedPreferences.getBool(_firstRunKey) ?? true;
        _sharedPreferences.setBool(_firstRunKey, false);
        _firstRun = firstRun;
        return firstRun;
      } catch (_) {
        _sharedPreferences.setBool(_firstRunKey, false);
        _firstRun = true;
        return true;
      }
    } else {
      return _firstRun!;
    }
  }

  static bool? _firstRun;

  static bool get isFirstCall {
    try {
      final bool firstCall = _sharedPreferences.getBool(_firstCallKey) ?? true;
      _sharedPreferences.setBool(_firstCallKey, false);
      return firstCall;
    } catch (_) {
      _sharedPreferences.setBool(_firstCallKey, false);
      return true;
    }
  }

  static void reset() {
    _sharedPreferences.setBool(_firstRunKey, true);
    _sharedPreferences.setBool(_firstCallKey, true);
  }

  @PostConstruct()
  void init() {
    _settingsModel = _loadSettingsModel();
    _results = _loadResults();
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
      // if (_settingsModel.font != settingsModel.font) {
      //   _lightTheme = settingsModel.font.setToTheme(_themeType.themeData.$1);
      //   _darkTheme = settingsModel.font.setToTheme(_themeType.themeData.$2);
      // }
      _settingsModel = settingsModel;
      _sharedPreferences.setString(
          _settingsKey, jsonEncode(settingsModel.toMap()));
    } catch (_) {
      _settingsModel = settingsModel;
    }
  }

  static List<ResultModel> _loadResults() {
    try {
      final results = _sharedPreferences.getStringList('results');
      if (results != null) {
        return results
            .map((result) => ResultModel.fromJson(jsonDecode(result)))
            .toList();
      } else {
        return [];
      }
    } catch (_) {
      return [];
    }
  }

  void saveResult(ResultModel result) {
    try {
      // Save only 40 results
      if (_results.length >= 40) _results.removeLast();
      _results.insert(0, result);
      _sharedPreferences.setStringList(_resultsKey,
          _results.map((result) => jsonEncode(result.toJson())).toList());
    } catch (_) {}
  }

  void clearResults() {
    try {
      _results.clear();
      _sharedPreferences.remove(_resultsKey);
    } catch (_) {}
  }
}
