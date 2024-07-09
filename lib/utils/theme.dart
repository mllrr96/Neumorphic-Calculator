import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class BlueTheme {
  static ThemeData light = ThemeData(
    scaffoldBackgroundColor: const Color(0xffFAFBFF),
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff006FF1)),
    useMaterial3: true,
    splashColor: const Color.fromARGB(255, 207, 88, 41),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xffFAFBFF),
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xffFAFBFF),
      ),
    ),
    textTheme: GoogleFonts.cairoTextTheme(),
  );

  static ThemeData dark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff006FF1), brightness: Brightness.dark),
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xff374353),
    splashColor: const Color.fromARGB(255, 207, 88, 41),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xff374353),
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xff374353),
      ),
    ),
    textTheme: GoogleFonts.cairoTextTheme(),
  );
}

class PinkTheme {
  static ThemeData light = ThemeData(
    scaffoldBackgroundColor: const Color(0xffFFF6F9),
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffC34568)),
    useMaterial3: true,
    splashColor: const Color.fromARGB(255, 207, 88, 41),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xffFFF6F9),
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xffFFF6F9),
      ),
    ),
    textTheme: GoogleFonts.cairoTextTheme(),
  );

  static ThemeData dark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xffC34568), brightness: Brightness.dark),
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xff374353),
    splashColor: const Color.fromARGB(255, 207, 88, 41),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xff374353),
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xff374353),
      ),
    ),
    textTheme: GoogleFonts.cairoTextTheme(),
  );
}
