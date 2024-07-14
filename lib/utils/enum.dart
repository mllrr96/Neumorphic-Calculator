import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme.dart';

enum CalculatorButton {
  allClear('AC'),
  openParenthesis('('),
  closeParenthesis(')'),
  percent('%'),
  divide('÷'),
  //
  seven('7'),
  eight('8'),
  nine('9'),
  multiply('x'),
  //
  four('4'),
  five('5'),
  six('6'),
  subtract('-'),
  //
  one('1'),
  two('2'),
  three('3'),
  add('+'),
  //
  zero('0'),
  decimal('.'),
  clear('C'),
  equal('=');

  final String value;
  const CalculatorButton(this.value);

  bool get isNumber => int.tryParse(value) != null;
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
  rubik,
  roboto,
  arsenal,
  montserrat,
  merriweather,
  ptSans,
  margarine,
  dancingScript,
  kodeMono,
  cabin,
  pacifico;

  ThemeData setToTheme(ThemeData theme) {
    switch (this) {
      case Fonts.rubik:
        return theme.copyWith(
          textTheme: GoogleFonts.rubikTextTheme(),
        );
      case Fonts.roboto:
        return theme.copyWith(
          textTheme: GoogleFonts.robotoTextTheme(),
        );
      case Fonts.montserrat:
        return theme.copyWith(
          textTheme: GoogleFonts.montserratTextTheme(),
        );
      case Fonts.arsenal:
        return theme.copyWith(
          textTheme: GoogleFonts.arsenalTextTheme(),
        );
      case Fonts.merriweather:
        return theme.copyWith(
          textTheme: GoogleFonts.merriweatherTextTheme(),
        );

      case Fonts.ptSans:
        return theme.copyWith(
          textTheme: GoogleFonts.ptSansTextTheme(),
        );
      case Fonts.margarine:
        return theme.copyWith(
          textTheme: GoogleFonts.margarineTextTheme(),
        );
      case Fonts.dancingScript:
        return theme.copyWith(
          textTheme: GoogleFonts.dancingScriptTextTheme(),
        );

      case Fonts.kodeMono:
        return theme.copyWith(
          textTheme: GoogleFonts.kodeMonoTextTheme(),
        );

      case Fonts.cabin:
        return theme.copyWith(
          textTheme: GoogleFonts.cabinTextTheme(),
        );
      case Fonts.pacifico:
        return theme.copyWith(
          textTheme: GoogleFonts.pacificoTextTheme(),
        );
    }
  }
}
