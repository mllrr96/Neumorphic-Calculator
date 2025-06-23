import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:neumorphic_calculator/dashboard_screen.dart';
import 'package:neumorphic_calculator/di/di.dart';
import 'package:neumorphic_calculator/service/theme_service.dart';
import 'package:neumorphic_calculator/utils/bindings.dart';
import 'package:neumorphic_calculator/utils/const.dart';
import 'package:system_theme/system_theme.dart';
import 'utils/enum.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await SystemTheme.accentColor.load();
  await configureDependencies();

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
    final themeMode = ThemeService.instance.themeMode;
    final lightTheme = ThemeService.instance.lightTheme;
    final darkTheme = ThemeService.instance.darkTheme;
    return ThemeProvider(
      themeModel: ThemeModel(
        themeMode: themeMode,
        lightTheme: lightTheme,
        darkTheme: darkTheme,
      ),
      builder: (context, theme) {
        return GetMaterialApp(
          initialBinding: InitBindings(),
          debugShowCheckedModeBanner: false,
          title: AppConst.appName,
          themeMode: theme.themeMode,
          theme: theme.lightTheme,
          darkTheme: theme.darkTheme,
          home: DashboardScreen(),
        );
      },
    );
    // return BlocListener<PageCubit, PageState>(
    //   listenWhen: (_, __) => true,
    //   listener: (context, state) {
    //     switch (state) {
    //       case Initial():
    //         return;
    //       case NavigateToSettings():
    //         _pageController.animateToPage(0,
    //             duration: const Duration(milliseconds: 300),
    //             curve: Curves.easeIn);
    //       case NavigateToMain():
    //         _pageController.animateToPage(1,
    //             duration: const Duration(milliseconds: 300),
    //             curve: Curves.easeIn);
    //       case NavigateToHistory():
    //         _pageController.animateToPage(2,
    //             duration: const Duration(milliseconds: 300),
    //             curve: Curves.easeIn);
    //     }
    //   },
    //   child:
    // );
  }
}
