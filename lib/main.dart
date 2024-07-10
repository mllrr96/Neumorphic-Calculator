import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:neumorphic_calculator/service/preference_service.dart';
import 'package:neumorphic_calculator/utils/const.dart';
import 'calculator_screen.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  getIt.registerSingletonAsync<PreferencesService>(
    () async => await PreferencesService.init(),
  );
  await getIt.allReady(timeout: const Duration(seconds: 10));

  runApp(const NeumorphicCalculatorApp());
}

class NeumorphicCalculatorApp extends StatelessWidget {
  const NeumorphicCalculatorApp({super.key});
  @override
  Widget build(BuildContext context) {
    final themeMode = PreferencesService.instance.themeMode;
    final lightTheme = PreferencesService.instance.lightTheme;
    final darkTheme = PreferencesService.instance.darkTheme;
    return ThemeProvider(
      themeModel: ThemeModel(
        themeMode: themeMode,
        lightTheme: lightTheme,
        darkTheme: darkTheme,
      ),
      builder: (context, theme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppConst.appName,
          themeMode: theme.themeMode,
          theme: theme.lightTheme,
          darkTheme: theme.darkTheme,
          home: const CalculatorScreen(),
        );
      },
    );
  }
}
