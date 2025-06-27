import 'dart:convert';
import 'package:get/get.dart';
import 'package:neumorphic_calculator/repo/database.dart';
import 'package:neumorphic_calculator/utils/const.dart';
import 'package:neumorphic_calculator/utils/result_model.dart';
import 'package:neumorphic_calculator/utils/settings_model.dart';

class PreferencesController extends GetxService {
  PreferencesController(this._repo);

  static PreferencesController get instance => Get.find<PreferencesController>();

  final DatabaseRepository _repo;

  static const String _firstRunKey = AppConst.firstRunKey;
  static const String _firstCallKey = AppConst.firstCallKey;
  static const String _settingsKey = AppConst.settingsKey;
  static const String _resultsKey = AppConst.resultsKey;

  static late SettingsModel _settingsModel;

  SettingsModel get settingsModel => _settingsModel;

  static late List<ResultModel> _results;

  List<ResultModel> get results => _results;

  bool get isFirstRun {
    if (_firstRun == null) {
      try {
        final bool firstRun = _repo.get<bool>(_firstRunKey) ?? true;
        _repo.set<bool>(_firstRunKey, false);
        _firstRun = firstRun;
        return firstRun;
      } catch (_) {
        _repo.set<bool>(_firstRunKey, false);
        _firstRun = true;
        return true;
      }
    } else {
      return _firstRun!;
    }
  }

  static bool? _firstRun;

  bool get isFirstCall {
    try {
      final bool firstCall = _repo.get<bool>(_firstCallKey) ?? true;
      _repo.set<bool>(_firstCallKey, false);
      return firstCall;
    } catch (_) {
      _repo.set<bool>(_firstCallKey, false);
      return true;
    }
  }

  void reset() {
    _repo.set<bool>(_firstRunKey, true);
    _repo.set<bool>(_firstCallKey, true);
  }

  @override
  void onInit() {
    _settingsModel = _loadSettingsModel();
    _results = _loadResults();
    super.onInit();
  }

  SettingsModel _loadSettingsModel() {
    try {
      final settings = _repo.get<String>(_settingsKey);
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
      _repo.set<String>(_settingsKey, jsonEncode(settingsModel.toMap()));
    } catch (_) {
      _settingsModel = settingsModel;
    }
  }

  List<ResultModel> _loadResults() {
    try {
      final results = _repo.get<List<String>>(_resultsKey);
      return results!
          .map((result) => ResultModel.fromJson(jsonDecode(result)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  void saveResult(ResultModel result) {
    try {
      // Save only 40 results
      if (_results.length >= 40) _results.removeLast();
      _results.insert(0, result);
      _repo.set<List<String>>(_resultsKey,
          _results.map((result) => jsonEncode(result.toJson())).toList());
    } catch (_) {}
  }

  void clearResults() {
    try {
      _results.clear();
      _repo.remove(_resultsKey);
    } catch (_) {}
  }
}
