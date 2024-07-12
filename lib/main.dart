import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:neumorphic_calculator/bloc/calculator_bloc.dart';
import 'package:neumorphic_calculator/history_screen.dart';
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

  runApp(BlocProvider(
    create: (context) => CalculatorBloc(),
    child: const NeumorphicCalculatorApp(),
  ));
}

class NeumorphicCalculatorApp extends StatefulWidget {
  const NeumorphicCalculatorApp({super.key});

  @override
  State<NeumorphicCalculatorApp> createState() =>
      _NeumorphicCalculatorAppState();
}

class _NeumorphicCalculatorAppState extends State<NeumorphicCalculatorApp> {
  final PageController _pageController = PageController();
  int _index = 0;
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
          home: PopScope(
            canPop: _index == 0,
            onPopInvoked: (val) {
              if (val) return;
              _pageController.animateToPage(0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn);
            },
            child: PageView(
              onPageChanged: (index) => setState(() => _index = index),
              controller: _pageController,
              dragStartBehavior: DragStartBehavior.down,
              children: const [
                KeepAliveWidget(child: CalculatorScreen()),
                HistoryScreen()
              ],
            ),
          ),
        );
      },
    );
  }
}

class KeepAliveWidget extends StatefulWidget {
  const KeepAliveWidget({super.key, required this.child});
  final Widget child;

  @override
  State<KeepAliveWidget> createState() => _KeepAliveWidgetState();
}

class _KeepAliveWidgetState extends State<KeepAliveWidget>
    with AutomaticKeepAliveClientMixin<KeepAliveWidget> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
