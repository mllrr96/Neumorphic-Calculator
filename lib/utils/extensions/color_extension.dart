import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension ColorExtension on Color {
  ThemeData getTheme(TextTheme textTheme, {Brightness? brightness}) {
    return ThemeData(
        textTheme: textTheme,
        splashColor: const Color.fromRGBO(207, 88, 41, 1),
        scaffoldBackgroundColor:
            brightness == Brightness.dark ? const Color(0xff374353) : null,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: brightness == Brightness.dark
              ? SystemUiOverlayStyle.light.copyWith(
                  statusBarColor: Colors.transparent,
                  systemNavigationBarColor: const Color(0xff374353),
                )
              : SystemUiOverlayStyle.dark.copyWith(
                  statusBarColor: Colors.transparent,
                  systemNavigationBarColor: const Color(0xffFAFBFF),
                ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: this,
          brightness: brightness ?? Brightness.light,
        ));
  }
}
