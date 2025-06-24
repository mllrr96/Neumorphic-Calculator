import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neumorphic_calculator/repo/database.dart';
import 'package:neumorphic_calculator/screens/dashboard_screen/dashboard_screen.dart';
import 'package:neumorphic_calculator/service/preference_service.dart';
import 'package:neumorphic_calculator/service/theme_controller.dart';
import 'package:neumorphic_calculator/utils/bindings.dart';
import 'package:neumorphic_calculator/utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system_theme/system_theme.dart';
import 'utils/enum.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await SystemTheme.accentColor.load();
  await Get.putAsync<SharedPreferences>(
      () async => await SharedPreferences.getInstance());
  Get.put(DatabaseRepository(Get.find<SharedPreferences>()));
  Get.put(PreferencesController(Get.find<DatabaseRepository>()));

  // Load all the licenses for the fonts
  LicenseRegistry.addLicense(() async* {
    for (final font in Fonts.values) {
      final license = await font.license();
      yield LicenseEntryWithLineBreaks(['google_fonts'], license);
    }
  });

  runApp(const NeumorphicCalculatorApp());
}

class NeumorphicCalculatorApp extends StatelessWidget {
  const NeumorphicCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      init: ThemeController(
          Get.find<DatabaseRepository>(), Get.find<PreferencesController>()),
      builder: (ctrl) {
        return GetMaterialApp(
          initialBinding: InitBindings(),
          debugShowCheckedModeBanner: false,
          title: AppConst.appName,
          themeMode: ctrl.themeMode,
          theme: ctrl.lightTheme,
          darkTheme: ctrl.darkTheme,
          home: DashboardScreen(),
        );
      },
    );
  }
}
