import 'dart:convert';

import 'package:get/get.dart';
import 'package:neumorphic_calculator/repo/database.dart';
import 'package:neumorphic_calculator/utils/const.dart';
import 'package:neumorphic_calculator/utils/settings_model.dart';

class SettingsController extends GetxController with StateMixin<SettingsModel> {
  static SettingsController get instance => Get.find<SettingsController>();
  final DatabaseRepository _dataBase;
  SettingsController(this._dataBase);

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    try {
      final settings = _dataBase.get<String>(AppConst.settingsKey);
      Map<String, dynamic> settingsMap = jsonDecode(settings!);
      change(
        SettingsModel.fromMap(settingsMap),
        status: RxStatus.success(),
      );
    } catch (_) {
      change(
        SettingsModel.normal(),
        status: RxStatus.success(),
      );
    }
  }

  void updateSettings(SettingsModel settings) async {
    try {
      await _dataBase.set<String>(
        AppConst.settingsKey,
        jsonEncode(settings.toMap()),
      );
      update();

      change(settings, status: RxStatus.success());
    } catch (e) {
      change(
        settings,
        status: RxStatus.error('Failed to save settings: $e'),
      );
    }
  }
}
