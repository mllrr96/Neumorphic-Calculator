import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  static ThemeData blueLight = ThemeData(
    scaffoldBackgroundColor: Colors.grey[300],
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
    splashColor: Colors.blue[100],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[300],
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.grey[300],
      ),
    ),
    fontFamily: GoogleFonts.cairo().fontFamily,
    textTheme: GoogleFonts.cairoTextTheme(),
  );

  static ThemeData blueDark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue, brightness: Brightness.dark),
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xff2E3239),
    splashColor: Colors.blue[100],
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xff2E3239),
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xff2E3239),
      ),
    ),
    fontFamily: GoogleFonts.cairo().fontFamily,
    textTheme: GoogleFonts.cairoTextTheme(),
  );
  static ThemeData pinkLight = ThemeData(
    scaffoldBackgroundColor: Colors.grey[300],
    colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xffc04e6e), primary: const Color(0xffc04e6e)),
    useMaterial3: true,
    splashColor: Colors.pink[100],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[300],
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.grey[300],
      ),
    ),
    fontFamily: GoogleFonts.cairo().fontFamily,
    textTheme: GoogleFonts.cairoTextTheme(),
  );

  static ThemeData pinkDark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xffc04e6e),
        primary: const Color(0xffc04e6e),
        brightness: Brightness.dark),
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xff2E3239),
    splashColor: Colors.pink[100],
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xff2E3239),
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xff2E3239),
      ),
    ),
    fontFamily: GoogleFonts.cairo().fontFamily,
    textTheme: GoogleFonts.cairoTextTheme(),
  );
}
