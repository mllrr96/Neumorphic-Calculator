import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class BlueTheme {
  static ThemeData light = ThemeData(
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
    textTheme: GoogleFonts.cairoTextTheme(),
  );

  static ThemeData dark = ThemeData(
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
    textTheme: GoogleFonts.cairoTextTheme(),
  );
}

class PinkTheme {
  static ThemeData light = ThemeData(
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
    textTheme: GoogleFonts.cairoTextTheme(),
  );

  static ThemeData dark = ThemeData(
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
    textTheme: GoogleFonts.cairoTextTheme(),
  );
}

enum ThemeType {
  blue,
  pink;

  (ThemeData, ThemeData) get themeData {
    switch (this) {
      case ThemeType.blue:
        return (BlueTheme.light, BlueTheme.dark);
      case ThemeType.pink:
        return (PinkTheme.light, PinkTheme.dark);
    }
  }
}

enum Fonts {
  cairo,
  roboto,
  lato,
  montserrat,
  notoSans,
  openSans,
  poppins,
  raleway,
  robotoMono,
  ubuntu,
  workSans;

  ThemeData setToTheme(ThemeData theme) {
    switch (this) {
      case Fonts.cairo:
        return theme.copyWith(
          textTheme: GoogleFonts.cairoTextTheme(),
        );
      case Fonts.roboto:
        return theme.copyWith(
          textTheme: GoogleFonts.robotoTextTheme(),
        );
      case Fonts.lato:
        return theme.copyWith(
          textTheme: GoogleFonts.latoTextTheme(),
        );
      case Fonts.montserrat:
        return theme.copyWith(
          textTheme: GoogleFonts.montserratTextTheme(),
        );
      case Fonts.notoSans:
        return theme.copyWith(
          textTheme: GoogleFonts.notoSansTextTheme(),
        );
      case Fonts.openSans:
        return theme.copyWith(
          textTheme: GoogleFonts.openSansTextTheme(),
        );
      case Fonts.poppins:
        return theme.copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(),
        );
      case Fonts.raleway:
        return theme.copyWith(
          textTheme: GoogleFonts.ralewayTextTheme(),
        );
      case Fonts.robotoMono:
        return theme.copyWith(
          textTheme: GoogleFonts.robotoMonoTextTheme(),
        );
      case Fonts.ubuntu:
        return theme.copyWith(
          textTheme: GoogleFonts.ubuntuTextTheme(),
        );
      case Fonts.workSans:
        return theme.copyWith(
          textTheme: GoogleFonts.workSansTextTheme(),
        );
    }
  }
}
