import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neumorphic_calculator/bloc/calculator_bloc/calculator_bloc.dart';
import 'package:neumorphic_calculator/bloc/history_bloc/history_bloc.dart';
import 'package:neumorphic_calculator/di/di.dart';
import 'package:neumorphic_calculator/history_screen.dart';
import 'package:neumorphic_calculator/service/preference_service.dart';
import 'package:neumorphic_calculator/utils/const.dart';
import 'bloc/page_cubit/page_cubit.dart';
import 'calculator_screen.dart';
import 'widgets/keep_alive_wrapper.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await configureDependencies();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => CalculatorBloc.instance,
      ),
      BlocProvider(
        create: (context) => HistoryBloc.instance..add(const LoadHistory()),
      ),
      BlocProvider(
        create: (context) => PageCubit.instance,
      ),
    ],
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
    return BlocListener<PageCubit, PageState>(
      listenWhen: (_, __) => true,
      listener: (context, state) {
        switch (state) {
          case Initial():
            return;
          case NavigateToMain():
            _pageController.animateToPage(0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn);
          case NavigateToHistory():
            _pageController.animateToPage(1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn);
        }
      },
      child: ThemeProvider(
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
                onPageChanged: (index) {
                  setState(() => _index = index);
                  context.read<PageCubit>().updateIndex(-1);
                },
                controller: _pageController,
                dragStartBehavior: DragStartBehavior.down,
                children: const [
                  KeepAliveWrapper(child: CalculatorScreen()),
                  HistoryScreen()
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
