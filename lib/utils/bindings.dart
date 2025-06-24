import 'package:get/get.dart';
import 'package:neumorphic_calculator/repo/database.dart';
import 'package:neumorphic_calculator/screens/dashboard_screen/dashboard_controller.dart';
import 'package:neumorphic_calculator/screens/calculator_screen/calculator_controller.dart';
import 'package:neumorphic_calculator/screens/history_screen/history_controller.dart';
import 'package:neumorphic_calculator/screens/settings_screen/settings_controller.dart';

class InitBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
    Get.put(SettingsController(Get.find<DatabaseRepository>()));
    Get.put(HistoryController(Get.find<DatabaseRepository>()));
    Get.put(CalculatorController());
  }
}
