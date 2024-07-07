import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/theme.dart';
import 'calculator_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const NeumorphicCalculatorApp());
}

class NeumorphicCalculatorApp extends StatelessWidget {
  const NeumorphicCalculatorApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      initTheme: Themes.pinkLight,
      builder: (context, theme) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          // themeMode: ThemeMode.dark,
          theme: theme,
          home: const CalculatorScreen(),
        );
      },
    );
  }
}
