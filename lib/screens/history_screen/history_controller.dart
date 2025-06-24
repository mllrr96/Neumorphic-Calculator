import 'dart:convert';

import 'package:get/get.dart';
import 'package:neumorphic_calculator/repo/database.dart';
import 'package:neumorphic_calculator/utils/const.dart';
import 'package:neumorphic_calculator/utils/result_model.dart';

class HistoryController extends GetxController
    with StateMixin<List<ResultModel>> {
  HistoryController(this._database);
  static HistoryController get instance => Get.find<HistoryController>();

  final DatabaseRepository _database;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  void _loadData() {
    final result = _database.get<List<String>>(AppConst.historyKey);

    switch (result) {
      case List<String> value:
        if (value.isEmpty) {
          change([], status: RxStatus.empty());
        } else {
          final List<ResultModel> results = value
              .map((String e) => ResultModel.fromJson(jsonDecode(e)))
              .toList();
          change(results, status: RxStatus.success());
        }
        break;
      default:
        change(null, status: RxStatus.error('Expression history = 0'));
    }
  }

  void addData(ResultModel resultModel) {
    final List<String> history =
        _database.get<List<String>>(AppConst.historyKey) ?? [];
    history.insert(0, jsonEncode(resultModel.toJson()));
    _database.set<List<String>>(AppConst.historyKey, history);
    _loadData();
  }

  void clearData() {
    _database.remove(AppConst.historyKey);
    change([], status: RxStatus.empty());
  }
}
